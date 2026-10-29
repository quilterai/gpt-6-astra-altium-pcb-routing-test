"""Check content preservation and copy boundaries for checkpoint storage."""

import hashlib
import json
import os
import tempfile
import unittest
from pathlib import Path

from checkpoint_storage import compact, copy_project


class CheckpointStorageTests(unittest.TestCase):
    """Verify immutable reuse without sharing mutable working files."""

    def fixture(self, root, name, contents=b"immutable history"):
        """Create one manifest-backed checkpoint history file."""
        checkpoint = root / "runs/full-routing-2026-09-30/checkpoints" / name
        path = checkpoint / "QCMI_SOM8MM/History/board.zip"
        path.parent.mkdir(parents=True)
        path.write_bytes(contents)
        record = dict(path="History/board.zip", bytes=len(contents),
                      sha256=hashlib.sha256(contents).hexdigest())
        (checkpoint / "checkpoint.json").write_text(json.dumps(dict(files=[record])))
        return path

    def test_compact_preserves_distinct_content(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            first = self.fixture(root, "001")
            second = self.fixture(root, "002")
            different = self.fixture(root, "003", b"different history")
            result = compact(root)
            self.assertTrue(os.path.samefile(first, second))
            self.assertFalse(os.path.samefile(first, different))
            self.assertEqual(different.read_bytes(), b"different history")
            self.assertEqual(len(result["linked_files"]), 1)
            self.assertEqual(compact(root)["linked_files"], [])

    def test_new_copy_never_links_to_working_source(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            old = self.fixture(root, "001")
            work = root / "work"
            (work / "History").mkdir(parents=True)
            (work / "History/board.zip").write_bytes(old.read_bytes())
            (work / "board.PcbDoc").write_bytes(b"working board")
            target = root / "copied"
            result = copy_project(work, target, root)
            self.assertEqual(result["reused_files"], 1)
            self.assertTrue(os.path.samefile(old, target / "History/board.zip"))
            self.assertFalse(os.path.samefile(work / "History/board.zip", target / "History/board.zip"))
            self.assertFalse(os.path.samefile(work / "board.PcbDoc", target / "board.PcbDoc"))
            (work / "board.PcbDoc").write_bytes(b"new working board")
            self.assertEqual((target / "board.PcbDoc").read_bytes(), b"working board")

    def test_changed_manifest_source_is_refused(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = self.fixture(root, "001")
            source.write_bytes(b"changed contents!")
            with self.assertRaises(AssertionError):
                compact(root)
            self.assertEqual(source.read_bytes(), b"changed contents!")

    def test_manifest_cannot_escape_checkpoint(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = self.fixture(root, "001")
            manifest = source.parents[2] / "checkpoint.json"
            data = json.loads(manifest.read_text())
            data["files"][0]["path"] = "../../outside/History/board.zip"
            manifest.write_text(json.dumps(data))
            with self.assertRaises(AssertionError):
                compact(root)


if __name__ == "__main__":
    unittest.main()

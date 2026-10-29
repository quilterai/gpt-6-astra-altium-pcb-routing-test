"""Share identical immutable checkpoint files without changing their contents."""

import argparse
import hashlib
import json
import os
import shutil
import stat
import uuid
from datetime import datetime, timezone
from pathlib import Path


def digest(path):
    """Hash a file without loading it all into memory."""
    with path.open("rb") as source:
        return hashlib.file_digest(source, "sha256").hexdigest()


def project_records(root):
    """Yield manifest-backed files from immutable saved projects only."""
    checkpoints = root / "runs/full-routing-2026-09-30/checkpoints"
    results = root / "results"
    manifests = [(p, p.parent / "QCMI_SOM8MM", checkpoints)
                 for p in sorted(checkpoints.glob("*/checkpoint.json"))]
    manifests += [(p, p.parent, results) for p in sorted(results.glob("*/manifest.json"))]
    for manifest, base, boundary in manifests:
        data = json.loads(manifest.read_text(encoding="utf-8-sig"))
        records = data if isinstance(data, list) else data.get("files", [])
        for record in records:
            relative = Path(record["path"])
            if not ("History" in relative.parts or relative.suffix.lower() in {".pcblib", ".schlib"}):
                continue
            path = (base / relative).resolve()
            assert path.is_relative_to(base.resolve()) and path.is_relative_to(boundary.resolve()), path
            yield path, int(record.get("bytes", record.get("length", -1))), record["sha256"].lower()


def compact(root):
    """Link verified duplicate history and library files across saved projects."""
    root = Path(root).resolve()
    sources, verified, linked = {}, {}, []
    free_before = shutil.disk_usage(root).free
    for path, size, expected in project_records(root):
        info = path.stat()
        assert info.st_size == size, path
        identity = (info.st_dev, info.st_ino)
        if identity not in verified:
            verified[identity] = digest(path)
        assert verified[identity] == expected, path
        if expected not in sources:
            sources[expected] = path
            continue
        source = sources[expected]
        if os.path.samefile(source, path):
            continue
        temporary = path.with_name(".storage-link-" + uuid.uuid4().hex)
        os.link(source, temporary)
        previous_mode = info.st_mode
        try:
            os.chmod(path, previous_mode | stat.S_IWRITE)
            os.replace(temporary, path)
        except Exception:
            os.chmod(path, previous_mode)
            temporary.unlink(missing_ok=True)
            raise
        assert os.path.samefile(source, path) and digest(path) == expected, path
        linked.append(dict(path=str(path.relative_to(root)), source=str(source.relative_to(root)),
                           bytes=size, sha256=expected))
    return dict(created_utc=datetime.now(timezone.utc).isoformat(), free_before=free_before,
                free_after=shutil.disk_usage(root).free, linked_files=linked)


def copy_project(source, destination, root):
    """Copy a complete project while sharing verified immutable history and libraries."""
    root, source, destination = (Path(path).resolve() for path in (root, source, destination))
    sources, checked = {}, set()
    reused_files = reused_bytes = 0
    for path, size, expected in project_records(root):
        sources.setdefault((size, expected), path)

    def copy_file(source_file, target_file):
        """Reuse immutable matching bytes, or make an independent ordinary copy."""
        nonlocal reused_files, reused_bytes
        path = Path(source_file)
        relative = path.relative_to(source)
        if "History" in relative.parts or path.suffix.lower() in {".pcblib", ".schlib"}:
            size, expected = path.stat().st_size, digest(path)
            existing = sources.get((size, expected))
            if existing is not None:
                if existing not in checked:
                    assert existing.stat().st_size == size and digest(existing) == expected, existing
                    checked.add(existing)
                os.link(existing, target_file)
                reused_files += 1
                reused_bytes += size
                return str(target_file)
        return shutil.copy2(source_file, target_file)

    shutil.copytree(source, destination, copy_function=copy_file)
    return dict(reused_files=reused_files, reused_bytes=reused_bytes,
                scope="Manifest-verified immutable History and library files only")


def main():
    """Compact immutable snapshots and write a new audit receipt."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    assert not args.output.exists(), "Keep prior storage receipts"
    root = Path(__file__).resolve().parents[1]
    result = compact(root)
    args.output.write_text(json.dumps(result, indent=2))
    print(json.dumps({key: value for key, value in result.items() if key != "linked_files"}, indent=2))
    print("Verified duplicate files consolidated:", len(result["linked_files"]))


if __name__ == "__main__":
    main()

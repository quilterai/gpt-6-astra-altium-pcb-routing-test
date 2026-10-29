"""Check explicit track reconciliation against ambiguous and unrequested changes."""

import tempfile
import unittest
from copy import deepcopy
from pathlib import Path

import reconcile_tracks as reconcile


def track(x1, x2, net="N", y=10):
    """Build an inventory track with a direction that tests can reverse."""
    return {
        "net": net,
        "x1_raw": str(x1),
        "y1_raw": str(y),
        "x2_raw": str(x2),
        "y2_raw": str(y),
        "width_raw": "3",
        "layer_id": "1",
        "layer": "Top Layer",
        "selected": "false",
    }


def inventory(tracks):
    """Build a small comparison input with an unrelated named-net track."""
    return {
        "board": {
            "coordinate_units": "raw",
            "internal_units_per_mil": "10000",
            "x_origin_raw": "1",
            "y_origin_raw": "2",
            "board_file": "C:\\board.PcbDoc",
        },
        "tables": {
            "tracks": tracks,
            "pads": [{"refdes": "U1", "pad": "1", "net": "N", "x_raw": "20"}],
            "vias": [],
            "rules": [],
            "connections": [],
            "nets": [{"net": "N", "pin_count": "1"}, {"net": "M", "pin_count": "1"}],
        },
        "counts": {"track_segment_count": len(tracks)},
    }


def request(action, old, new, count=2):
    """Build a parsed request row with unchanged width, layer, and net."""
    row = {
        "action": action,
        "net": "N",
        "width_raw": "3",
        "layer_id": "1",
        "expected_track_count": str(count),
    }
    for prefix, endpoints in (("old", old), ("new", new)):
        row.update(
            dict(
                zip(
                    (f"{prefix}_{field}" for field in reconcile.TRACK_FIELDS[1:5]),
                    map(str, endpoints),
                )
            )
        )
    return row


class ReconciliationTests(unittest.TestCase):
    """Exercise complete multisets rather than aggregate object counts."""

    def setUp(self):
        self.before = inventory([track(10, 20), track(100, 200, net="M")])
        self.rows = [
            request("edit", (10, 10, 20, 10), (5, 10, 20, 10)),
            request("add", (0, 0, 0, 0), (20, 10, 30, 10)),
        ]

    def test_mixed_edit_add_and_reversed_readback_preserve_ordinary_flags(self):
        expected, removed, added = reconcile.plan_request(self.before, self.rows)
        after = inventory([track(20, 5), track(100, 200, net="M"), track(30, 20)])
        after["tables"]["tracks"][0]["selected"] = "true"
        result = reconcile.reconcile(self.before, after, expected, self.rows)
        self.assertTrue(result["request_compliant"])
        self.assertEqual((removed.total(), added.total(), expected.total()), (1, 2, 3))
        self.assertIn(
            "Baseline tracks removed or modified",
            result["ordinary_comparator_regressions"],
        )

    def test_same_count_unrelated_removal_and_duplicate_addition_fail(self):
        expected, _, _ = reconcile.plan_request(self.before, self.rows)
        after = inventory([track(5, 20), track(20, 30), track(30, 20)])
        result = reconcile.reconcile(self.before, after, expected, self.rows)
        self.assertFalse(result["request_compliant"])
        self.assertEqual(result["expected_track_count"], result["actual_track_count"])
        self.assertEqual(result["unexpected_track_changes"]["added_count"], 1)
        self.assertEqual(result["unexpected_track_changes"]["removed_count"], 1)

    def test_ambiguous_duplicate_original_target_fails(self):
        before = inventory([track(10, 20), track(20, 10)])
        with self.assertRaisesRegex(ValueError, "resolves to 2 tracks"):
            reconcile.plan_request(before, self.rows[:1])

    def test_stale_count_repeated_target_and_net_case_fail(self):
        stale = deepcopy(self.rows[:1])
        stale[0]["expected_track_count"] = "3"
        with self.assertRaisesRegex(ValueError, "before inventory has 2"):
            reconcile.plan_request(self.before, stale)
        repeated = [self.rows[0], request("edit", (20, 10, 10, 10), (6, 10, 20, 10))]
        with self.assertRaisesRegex(ValueError, "repeated old edit target"):
            reconcile.plan_request(self.before, repeated)
        wrong_case = deepcopy(self.rows[:1])
        wrong_case[0]["net"] = "n"
        with self.assertRaisesRegex(ValueError, "unknown exact net"):
            reconcile.plan_request(self.before, wrong_case)

    def test_pad_move_fails_even_when_requested_track_result_is_exact(self):
        expected, _, _ = reconcile.plan_request(self.before, self.rows)
        after = inventory([track(5, 20), track(100, 200, net="M"), track(20, 30)])
        after["tables"]["pads"][0]["x_raw"] = "21"
        result = reconcile.reconcile(self.before, after, expected, self.rows)
        self.assertFalse(result["request_compliant"])
        self.assertEqual(result["unexpected_track_changes"]["added_count"], 0)
        self.assertIn("Unrequested pads records changed", result["failures"])

    def test_request_reader_rejects_invalid_last_row_without_writing_source(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "request.tsv"
            valid = "\t".join(self.rows[0][field] for field in reconcile.REQUEST_FIELDS)
            invalid = "\t".join(
                self.rows[1][field] for field in reconcile.REQUEST_FIELDS
            ).replace("\t3\t1\t2", "\t3e0\t1\t2")
            text = (
                "\t".join(reconcile.REQUEST_FIELDS)
                + "\n"
                + valid
                + "\n"
                + invalid
                + "\n"
            )
            path.write_text(text, encoding="utf-8")
            original = path.read_bytes()
            with self.assertRaisesRegex(ValueError, "Row 2: invalid unsigned integer"):
                reconcile.read_request(path)
            self.assertEqual(path.read_bytes(), original)

    def test_l3_request_keeps_layer_in_exact_track_identity(self):
        rows = deepcopy(self.rows)
        for row in rows:
            row["layer_id"] = "3"
        before = deepcopy(self.before)
        before["tables"]["tracks"][0]["layer_id"] = "3"
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "request.tsv"
            path.write_text(
                "\t".join(reconcile.REQUEST_FIELDS)
                + "\n"
                + "\n".join(
                    "\t".join(row[field] for field in reconcile.REQUEST_FIELDS)
                    for row in rows
                )
                + "\n",
                encoding="utf-8",
            )
            parsed, _ = reconcile.read_request(path)
        expected, _, _ = reconcile.plan_request(before, parsed)
        after = inventory([track(20, 5), track(100, 200, net="M"), track(30, 20)])
        for index in (0, 2):
            after["tables"]["tracks"][index]["layer_id"] = "3"
        self.assertTrue(
            reconcile.reconcile(before, after, expected, parsed)["request_compliant"]
        )
        after["tables"]["tracks"][2]["layer_id"] = "1"
        self.assertFalse(
            reconcile.reconcile(before, after, expected, parsed)["request_compliant"]
        )

    def test_request_reader_rejects_other_layer_ids(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "request.tsv"
            for layer in ("2", "4", "7", "74"):
                with self.subTest(layer=layer):
                    row = {**self.rows[0], "layer_id": layer}
                    path.write_text(
                        "\t".join(reconcile.REQUEST_FIELDS)
                        + "\n"
                        + "\t".join(row[field] for field in reconcile.REQUEST_FIELDS)
                        + "\n",
                        encoding="utf-8",
                    )
                    with self.assertRaisesRegex(ValueError, "layer required"):
                        reconcile.read_request(path)

    def test_l6_control_trial_rejects_unreviewed_net_edit_and_width(self):
        valid = {
            **self.rows[1], "net": "RTC_RESET_B", "layer_id": "6",
            "width_raw": "32000",
        }
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "request.tsv"
            for changes, accepted in (
                ({}, True),
                ({"net": "PMIC_STBY_REQ", "width_raw": "100000"}, True),
                ({"net": "DSI_D1_P", "width_raw": "150000"}, True),
                ({"net": "DSI_D1_P", "width_raw": "149999"}, False),
                ({"net": "DSI_D1_P", "width_raw": "150000", "action": "edit"}, False),
                ({"net": "DSI_D1_N", "width_raw": "150000"}, False),
                ({"net": "GND"}, False),
                ({"net": "rtc_reset_b"}, False),
                ({"action": "edit"}, False),
                ({"width_raw": "31999"}, False),
                ({"width_raw": "100001"}, False),
            ):
                with self.subTest(changes=changes):
                    row = {**valid, **changes}
                    path.write_text(
                        "\t".join(reconcile.REQUEST_FIELDS) + "\n"
                        + "\t".join(row[field] for field in reconcile.REQUEST_FIELDS)
                        + "\n", encoding="utf-8",
                    )
                    if accepted:
                        parsed, _ = reconcile.read_request(path)
                        self.assertEqual(parsed, [row])
                    else:
                        with self.assertRaisesRegex(ValueError, "layer required"):
                            reconcile.read_request(path)


    def test_l2_escape_refuses_unreviewed_net_edit_and_width(self):
        valid = {
            **self.rows[1], "net": "SD2_CMD", "layer_id": "2",
            "width_raw": "32000",
        }
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "request.tsv"
            for changes, accepted in (
                ({}, True),
                ({"net": "USB1_ID"}, True),
                ({"net": "USB1_ID", "width_raw": "31999"}, False),
                ({"net": "USB1_ID", "width_raw": "100001"}, False),
                ({"net": "USB1_ID", "action": "edit"}, False),
                ({"net": "DSI_D3_P", "width_raw": "150000"}, True),
                ({"net": "DSI_D3_P", "width_raw": "149999"}, False),
                ({"net": "DSI_D3_P", "width_raw": "150000", "action": "edit"}, False),
                ({"net": "DSI_D3_N", "width_raw": "150000"}, False),
                ({"net": "CSI_D0_P", "width_raw": "150000"}, True),
                ({"net": "CSI_D0_P", "width_raw": "150001"}, False),
                ({"net": "CSI_D0_P", "width_raw": "150000", "action": "edit"}, False),
                ({"net": "CSI_D0_N", "width_raw": "150000"}, False),
                ({"net": "CSI_D2_P", "width_raw": "150000"}, True),
                ({"net": "CSI_D2_P", "width_raw": "150001"}, False),
                ({"net": "CSI_D2_P", "width_raw": "150000", "action": "edit"}, False),
                ({"net": "CSI_D2_N", "width_raw": "150000"}, False),
                ({"net": "NVCC_SNVS_1V8", "width_raw": "200000"}, True),
                ({"net": "NVCC_SNVS_1V8", "width_raw": "29999"}, False),
                ({"net": "NVCC_SNVS_1V8", "width_raw": "1000001"}, False),
                ({"net": "NVCC_SNVS_1V8", "action": "edit"}, False),
                ({"net": "GND"}, False),
                ({"net": "sd2_cmd"}, False),
                ({"action": "edit"}, False),
                ({"width_raw": "31999"}, False),
                ({"width_raw": "100001"}, False),
            ):
                with self.subTest(changes=changes):
                    row = {**valid, **changes}
                    path.write_text(
                        "\t".join(reconcile.REQUEST_FIELDS) + "\n"
                        + "\t".join(row[field] for field in reconcile.REQUEST_FIELDS)
                        + "\n", encoding="utf-8",
                    )
                    if accepted:
                        parsed, _ = reconcile.read_request(path)
                        self.assertEqual(parsed, [row])
                    else:
                        with self.assertRaisesRegex(ValueError, "layer required"):
                            reconcile.read_request(path)


    def test_l6_power_refuses_unreviewed_net_edit_and_width(self):
        valid = {
            **self.rows[1], "net": "VDD_SNVS_0V8", "layer_id": "6",
            "width_raw": "200000",
        }
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "request.tsv"
            for changes, accepted in (
                ({}, True),
                ({"net": "NVCC_ENET", "width_raw": "30000"}, True),
                ({"net": "NVCC_SD2", "width_raw": "1000000"}, True),
                ({"net": "VDD_PHY_0V9"}, True),
                ({"net": "GND"}, False),
                ({"net": "vdd_snvs_0v8"}, False),
                ({"action": "edit"}, False),
                ({"width_raw": "29999"}, False),
                ({"width_raw": "1000001"}, False),
            ):
                with self.subTest(changes=changes):
                    row = {**valid, **changes}
                    path.write_text(
                        "\t".join(reconcile.REQUEST_FIELDS) + "\n"
                        + "\t".join(row[field] for field in reconcile.REQUEST_FIELDS)
                        + "\n", encoding="utf-8",
                    )
                    if accepted:
                        parsed, _ = reconcile.read_request(path)
                        self.assertEqual(parsed, [row])
                    else:
                        with self.assertRaisesRegex(ValueError, "layer required"):
                            reconcile.read_request(path)


if __name__ == "__main__":
    unittest.main()

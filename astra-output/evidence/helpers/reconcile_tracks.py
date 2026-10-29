"""Reconcile an explicit FullTracks request with complete saved inventories."""

import argparse
import csv
import io
import json
import re
import sys
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path, PureWindowsPath

import compare_routing as compare


REQUEST_FIELDS = (
    "action net old_x1_raw old_y1_raw old_x2_raw old_y2_raw"
    " new_x1_raw new_y1_raw new_x2_raw new_y2_raw"
    " width_raw layer_id expected_track_count"
).split()
TRACK_FIELDS = "net x1_raw y1_raw x2_raw y2_raw width_raw layer_id".split()
L2_ESCAPE_NETS = frozenset(("SD2_CMD", "QSPIA_SCLK", "DRAMA_CA4", "DRAMA_CA5", "DRAMB_CKE1", "DRAMB_CA5", "DRAMB_DATA10", "DRAMA_DATA1", "SAI2_RXC", "SAI2_TXD", "USB1_ID", "SAI1_TXD0", "SAI2_MCLK", "SYS_STATUS", "DRAMA_DATA5", "SD3_CLK", "JTAG_TDO", "SAI1_TXC", "SAI1_RXD5", "SAI1_RXD1", "SAI5_RXFS", "SAI1_RXD7", "GPIO1_IO10", "GPIO1_IO09", "DRAMB_DATA0", "DRAMA_DATA3", "UART1_CTS", "SD2_DATA3", "SAI1_TXD4", "SAI1_TXD2", "SD3_DATA6", "SD1_DATA3", "QSPIA_DATA0", "SAI1_TXD7", "CLKIN2"))
L6_POWER_NETS = frozenset(("VDD_SNVS_0V8", "NVCC_ENET", "NVCC_SD2", "VDD_PHY_0V9"))
L4_POWER_NETS = frozenset(
    ("VDD_ARM_0V9", "VDD_SOC_0V8", "VDD_DRAM&PU_0V9", "VDD_1V8", "NVCC_SD2")
)
L6_NETS = frozenset(
    [
        'BT_WAKE_DEV',
        'CLKIN2',
        'CLKOUT1',
        'CLKOUT2',
        'CLK_32K_OUT',
        'DRAMA_CA4',
        'DRAMA_CA5',
        'DRAMA_CKE0',
        'DRAMA_CKE1',
        'DRAMA_DATA1',
        'DRAMA_DATA3',
        'DRAMA_DATA5',
        'DRAMA_nCS0',
        'DRAMB_CA4',
        'DRAMB_CA5',
        'DRAMB_CKE0',
        'DRAMB_CKE1',
        'DRAMB_DATA0',
        'DRAMB_DATA1',
        'DRAMB_DATA10',
        'DRAMB_DATA11',
        'DRAMB_DATA5',
        'DRAMB_nCS0',
        'DRAM_NRESET',
        'ECSPI2_MISO',
        'ECSPI2_MOSI',
        'ECSPI2_SCLK',
        'ECSPI2_SS0',
        'ENET_MDC',
        'ENET_RD2',
        'ENET_RD3',
        'ENET_RXC',
        'ENET_TD0',
        'ENET_TD1',
        'ENET_TD2',
        'ENET_TD3',
        'GPIO1_IO05',
        'GPIO1_IO07',
        'GPIO1_IO09',
        'I2C3_SDA',
        'JTAG_TCK',
        'JTAG_TDO',
        'NetR30_1',
        'NetR7_2',
        'PDM_CLK',
        'PDM_DATA3',
        'PMIC_STBY_REQ',
        'QSPIA_NSS0',
        'QSPIA_SCLK',
        'RTC_RESET_B',
        'SAI1_MCLK',
        'SAI1_RXC',
        'SAI1_RXD0',
        'SAI1_RXD1',
        'SAI1_RXD3',
        'SAI1_RXD4',
        'SAI1_RXD5',
        'SAI1_RXD6',
        'SAI1_RXD7',
        'SAI1_RXFS',
        'SAI1_TXD0',
        'SAI1_TXD1',
        'SAI1_TXD2',
        'SAI1_TXD3',
        'SAI1_TXD4',
        'SAI1_TXD5',
        'SAI1_TXD7',
        'SAI2_MCLK',
        'SAI2_RXC',
        'SAI2_RXD',
        'SAI2_RXFS',
        'SAI2_TXC',
        'SAI2_TXD',
        'SAI2_TXFS',
        'SAI3_MCLK',
        'SAI3_TXFS',
        'SAI5_MCLK',
        'SAI5_RXFS',
        'SD1_DATA0',
        'SD1_DATA1',
        'SD1_DATA3',
        'SD1_STROBE',
        'SD2_CLK',
        'SD2_CMD',
        'SD2_DATA3',
        'SD2_NCD',
        'SD2_NRST',
        'SD3_CLK',
        'SD3_CMD',
        'SD3_DATA1',
        'SD3_DATA2',
        'SD3_DATA3',
        'SD3_DATA4',
        'SD3_DATA6',
        'SYS_STATUS',
        'UART1_RTS',
        'UART1_RXD',
        'UART3_RTS',
        'UART3_TXD',
        'VDDA_1V8',
        'NVCC_SNVS_1V8',
        'WL_WAKE_HOST',
        'XTALI_24M',
        'XTALI_32K',
        'XTALO_24M',
        'XTALO_32K',
    ]
)
LIMITS = [
    "No Altium calls or source-file writes occur.",
    "Track identity uses net, raw endpoints, width, and layer ID; selection and layer display names are ignored.",
    "Exact request compliance does not establish copper preservation, connectivity, DRC, timing, or electrical acceptance.",
    "Components, arcs, polygons, pad stacks, and keepouts are outside the base inventory.",
    "Run compare_routing.py independently; its preserved-copper flags remain unchanged.",
]


def read_request(path, encoding="utf-8-sig"):
    """Parse the exact bounded FullTracks input without accepting blank rows."""
    text, source = compare.read_source(path, encoding)
    lines = text.splitlines()
    if not 2 <= len(lines) <= 65 or any(not line for line in lines):
        raise ValueError("Request needs one header and 1-64 nonempty data rows")
    reader = csv.DictReader(io.StringIO(text), delimiter="\t", quoting=csv.QUOTE_NONE)
    if reader.fieldnames != REQUEST_FIELDS:
        raise ValueError("Unexpected FullTracks request header")
    rows = list(reader)
    for index, row in enumerate(rows, 1):
        if None in row or None in row.values():
            raise ValueError(f"Row {index}: expected exactly 13 fields")
        if row["action"] not in ("edit", "add"):
            raise ValueError(f"Row {index}: action must be edit or add")
        if not row["net"] or row["net"] != row["net"].strip():
            raise ValueError(f"Row {index}: exact nonempty net name required")
        for field in REQUEST_FIELDS[2:]:
            value = row[field]
            if not re.fullmatch(r"[0-9]{1,10}", value) or int(value) > 2147483647:
                raise ValueError(f"Row {index}: invalid unsigned integer {field}")
            row[field] = str(int(value))
        if int(row["expected_track_count"]) > 2147483647 - len(rows):
            raise ValueError(f"Row {index}: track count can overflow")
        allowed_l6_ground_repair = (
            row["layer_id"] == "6"
            and row["net"] == "GND"
            and row["action"] == "add"
            and 50000 <= int(row["width_raw"]) <= 100000
        )
        allowed_l6_trial = (
            row["layer_id"] == "6"
            and row["net"] in L6_NETS
            and row["action"] == "add"
            and (30000 if row["net"] in {"VDDA_1V8", "NVCC_SNVS_1V8"} else 32000)
            <= int(row["width_raw"]) <= 100000
        )
        allowed_l2_escape = (
            row["layer_id"] == "2"
            and row["net"] in L2_ESCAPE_NETS | {"I2C4_SDA", "ENET_TD2", "SAI1_RXD4"}
            and row["action"] == "add"
            and 32000 <= int(row["width_raw"]) <= 100000
        )
        allowed_l6_power = (
            row["layer_id"] == "6"
            and row["net"] in L6_POWER_NETS
            and row["action"] == "add"
            and 30000 <= int(row["width_raw"]) <= 1000000
        )
        allowed_l6_supply_repair = (
            row["layer_id"] == "6"
            and row["net"] == "VDD_3V3"
            and row["action"] == "add"
            and 30000 <= int(row["width_raw"]) <= 200000
        )
        allowed_l2_power = (
            row["layer_id"] == "2"
            and row["net"] in {"NVCC_SNVS_1V8", "NVCC_DRAM_1V1"}
            and row["action"] == "add"
            and 30000 <= int(row["width_raw"]) <= 1000000
        )
        allowed_l6_diff = (
            row["layer_id"] == "6"
            and row["net"] in {
                "DRAMA_SDQS0_C",
                "DSI_D1_P",
                "DRAMA_CK_T",
                "DRAMB_CK_C",
                "DRAMB_SDQS1_C",
                "DRAMB_SDQS1_T",
            }
            and row["action"] == "add"
            and int(row["width_raw"]) == 150000
        )
        allowed_l4_power = (
            row["layer_id"] == "4"
            and row["net"] in L4_POWER_NETS
            and row["action"] == "add"
            and 30000 <= int(row["width_raw"]) <= 1000000
        )
        allowed_l4_supply_repair = (
            row["layer_id"] == "4"
            and row["net"] == "VDD_3V3"
            and row["action"] == "add"
            and int(row["width_raw"]) == 200000
        )
        allowed_l4_clock = (
            row["layer_id"] == "4"
            and row["net"] in {"XTALO_24M", "ENET_TD0", "ENET_TD1", "SAI1_RXD7", "ENET_RD2", "ENET_RD3", "POR_B", "SD2_NRST", "JTAG_TCK", "QSPIA_DATA0", "WL_REG_ON", "QSPIA_DATA2"}
            and row["action"] == "add"
            and int(row["width_raw"]) == 32000
        )
        allowed_bt_access = (
            row["layer_id"] in {"4", "5"}
            and row["net"] == "BT_WAKE_DEV"
            and row["action"] == "add"
            and int(row["width_raw"]) == 32000
        )
        allowed_pcie_clock = (
            ((row["layer_id"] in {"4", "7"} and row["net"] == "PCIE_CLK_P")
             or (row["layer_id"] == "7" and row["net"] == "DSI_D0_P")
             or (row["layer_id"] in {"2", "4"} and row["net"] == "PCIE_CLK_N"))
            and row["action"] == "add"
            and int(row["width_raw"]) == 150000
        )
        allowed_l5_usb = (
            row["layer_id"] == "5"
            and row["net"] in {"USB1_DN", "CSI_CK_P", "PCIE_TX_N"}
            and row["action"] == "add"
            and int(row["width_raw"]) == 150000
        )
        allowed_l5_vdd_repair = (
            row["layer_id"] == "5"
            and row["net"] in {"VDD_1V8", "NVCC_SNVS_1V8", "VDD_ARM_0V9", "VDD_3V3"}
            and row["action"] == "add"
            and 30000 <= int(row["width_raw"]) <= 200000
        )
        allowed_l5_preservation = (
            row["layer_id"] == "5"
            and row["net"] in {"PDM_DATA1", "SAI1_RXD5", "SAI1_RXD0", "SAI1_RXD6", "SD2_DATA2", "XTALO_32K", "GPIO1_IO07", "DRAM_NRESET", "UART3_RTS", "GPIO1_IO08", "QSPIA_DATA3", "CLKOUT2", "PMIC_ON_REQ", "DRAMB_DATA3", "I2C1_SCL", "I2C1_SDA", "I2C2_SCL", "I2C4_SDA", "SAI1_TXD4", "SAI1_TXD2", "SD2_CLK", "ECSPI2_MISO", "DRAMB_DATA4", "DRAMB_nCS1", "SD2_WP", "SD3_DATA1", "SD3_DATA2", "WL_WAKE_HOST", "WL_REG_ON"}
            and row["action"] == "add"
            and 32000 <= int(row["width_raw"]) <= 100000
        )
        allowed_l7_sai = (
            row["layer_id"] == "7"
            and row["net"] in {"SAI2_RXD", "SAI2_TXC", "UART1_RXD", "UART1_RTS", "SAI5_RXFS", "SAI1_TXD1", "PDM_DATA2", "PDM_DATA0", "SD2_DATA2", "SD2_DATA1", "XTALI_32K", "ENET_RXC", "GPIO1_IO11", "DRAMB_DATA1", "CLKOUT1", "DRAMB_DATA11", "UART1_TXD", "SAI1_RXD1", "JTAG_TCK", "UART1_CTS", "ENET_TD3", "SAI1_TXD5", "SAI1_RXFS", "SAI1_RXD4", "GPIO1_IO05"}
            and row["action"] == "add"
            and 32000 <= int(row["width_raw"]) <= 100000
        )
        allowed_l7_por = (
            row["layer_id"] == "7"
            and row["net"] == "POR_B"
            and row["action"] == "add"
            and int(row["width_raw"]) == 32000
        )
        allowed_l2_diff = (
            row["layer_id"] == "2"
            and row["net"] in {"DSI_D3_P", "CSI_D0_P", "CSI_D2_P"}
            and row["action"] == "add"
            and int(row["width_raw"]) == 150000
        )
        allowed_l7_supply_repair = (
            row["layer_id"] == "7"
            and row["net"] == "VDD_3V3"
            and row["action"] == "add"
            and int(row["width_raw"]) == 30000
        )
        allowed_l7_ground_repair = (
            row["layer_id"] == "7"
            and row["net"] == "GND"
            and row["action"] == "add"
            and 30000 <= int(row["width_raw"]) <= 100000
        )
        if (
            row["layer_id"] not in ("1", "3", "32")
            and not allowed_l2_escape
            and not allowed_l2_power
            and not allowed_l2_diff
            and not allowed_l6_trial
            and not allowed_l6_ground_repair
            and not allowed_l6_power
            and not allowed_l6_supply_repair
            and not allowed_l6_diff
            and not allowed_l4_power
            and not allowed_l4_supply_repair
            and not allowed_l4_clock
            and not allowed_l5_preservation
            and not allowed_l5_usb
            and not allowed_l5_vdd_repair
            and not allowed_pcie_clock
            and not allowed_bt_access
            and not allowed_l7_sai
            and not allowed_l7_por
            and not allowed_l7_supply_repair
            and not allowed_l7_ground_repair
        ) or int(row["width_raw"]) <= 0:
            raise ValueError(
                f"Row {index}: allowed layer required for this net, action, and width"
            )
        if row["net"] == "SD3_DATA2" and row["layer_id"] == "1" and int(row["width_raw"]) == 30000:
            old = tuple(int(row[f"old_{key}"]) for key in TRACK_FIELDS[1:5])
            new = tuple(int(row[f"new_{key}"]) for key in TRACK_FIELDS[1:5])
            if row["action"] != "edit" or old not in (
                (127344400, 95080700, 127441500, 95080700),
                (127441500, 95080700, 127344400, 95080700),
            ) or new != (127344400, 95080700, 127518500, 95080700):
                raise ValueError(f"Row {index}: unreviewed DATA2 neck")
        for prefix in ("old", "new"):
            values = [int(row[f"{prefix}_{field}"]) for field in TRACK_FIELDS[1:5]]
            if prefix == "old" and row["action"] == "add":
                if any(values):
                    raise ValueError(
                        f"Row {index}: additions require four zero old coordinates"
                    )
            elif min(values) <= 0 or values[:2] == values[2:]:
                raise ValueError(
                    f"Row {index}: positive nondegenerate {prefix} endpoints required"
                )
        if row["action"] == "edit" and request_track(row, "old") == request_track(
            row, "new"
        ):
            raise ValueError(f"Row {index}: endpoint edit makes no change")
    return rows, source


def track_records(rows):
    """Count exact track geometry with normalized numeric and endpoint notation."""
    normalized = []
    for row in rows:
        normalized.append(
            {
                field: row[field] if field == "net" else str(int(row[field]))
                for field in TRACK_FIELDS
            }
        )
    return compare.records(normalized, track=True)


def request_track(row, prefix):
    """Convert one old or new request geometry to a canonical track key."""
    record = {field: row[field] for field in ("net", "width_raw", "layer_id")}
    record.update({field: row[f"{prefix}_{field}"] for field in TRACK_FIELDS[1:5]})
    return next(iter(track_records([record])))


def segment_shape(key):
    """Identify a layer and endpoint pair independently of net and width."""
    return tuple(
        (field, value) for field, value in key if field not in ("net", "width_raw")
    )


def plan_request(before, rows):
    """Validate all old matches before computing the expected complete multiset."""
    original = track_records(before["tables"]["tracks"])
    expected = original.copy()
    count = before["counts"]["track_segment_count"]
    nets = {row["net"] for row in before["tables"]["nets"]}
    existing_shapes = {segment_shape(key) for key in original}
    old_targets, destinations = set(), set()
    removed, added = Counter(), Counter()
    for index, row in enumerate(rows, 1):
        if int(row["expected_track_count"]) != count:
            raise ValueError(
                f"Row {index}: expected {row['expected_track_count']} tracks, before inventory has {count}"
            )
        if row["net"] not in nets:
            raise ValueError(f"Row {index}: unknown exact net {row['net']}")
        destination = request_track(row, "new")
        shape = segment_shape(destination)
        if shape in destinations or shape in existing_shapes:
            raise ValueError(f"Row {index}: repeated or existing destination segment")
        destinations.add(shape)
        if row["action"] == "edit":
            old = request_track(row, "old")
            if original[old] != 1:
                raise ValueError(
                    f"Row {index}: old geometry resolves to {original[old]} tracks, expected 1"
                )
            if old in old_targets:
                raise ValueError(f"Row {index}: repeated old edit target")
            old_targets.add(old)
            removed[old] += 1
        added[destination] += 1
    expected.subtract(removed)
    expected.update(added)
    return +expected, removed, added


def reconcile(before, after, expected, rows):
    """Report unexpected whole-board changes without suppressing the ordinary comparator."""
    actual = track_records(after["tables"]["tracks"])
    mismatch = compare.delta(expected, actual)
    ordinary = compare.compare_inventories(before, after, {row["net"] for row in rows})
    failures = []
    if mismatch["added_count"] or mismatch["removed_count"]:
        failures.append("Track multiset differs from the explicit request")
    immutable = {
        name: ordinary["changes"][name]
        for name in ("pads", "vias", "rules", "net_assignments")
    }
    for name, change in immutable.items():
        if change["added_count"] or change["removed_count"]:
            failures.append(f"Unrequested {name} records changed")
    if ordinary["immutable_board_changes"]:
        failures.append("Board origin or units changed")
    if any(net["reduction"] < 0 for net in ordinary["changed_nets"]):
        failures.append("Remaining edges increased on at least one net")
    if ordinary["unexpected_nets"]:
        failures.append("Changes outside request nets")
    return {
        "request_compliant": not failures,
        "failures": failures,
        "expected_track_count": expected.total(),
        "actual_track_count": actual.total(),
        "unexpected_track_changes": mismatch,
        "nontrack_changes": immutable,
        "immutable_board_changes": ordinary["immutable_board_changes"],
        "changed_nets": ordinary["changed_nets"],
        "ordinary_comparator_regressions": ordinary["regressions"],
    }


def main():
    """Read complete inputs and emit preflight or post-edit reconciliation evidence."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("before", type=Path)
    parser.add_argument("request", type=Path)
    parser.add_argument("--after", type=Path)
    parser.add_argument("--expected-board", required=True)
    parser.add_argument("--encoding", default="utf-8-sig")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    try:
        if not PureWindowsPath(args.expected_board).is_absolute():
            raise ValueError("--expected-board must be a full Windows path")
        before = compare.read_inventory(args.before, args.encoding)
        after = (
            compare.read_inventory(args.after, args.encoding) if args.after else None
        )
        for inventory in (before, after):
            if inventory is not None and PureWindowsPath(
                inventory["board"]["board_file"]
            ) != PureWindowsPath(args.expected_board):
                raise ValueError("Inventory does not match --expected-board")
        rows, request_source = read_request(args.request, args.encoding)
        expected, removed, added = plan_request(before, rows)
        result = {
            "mode": "after_reconciliation" if after else "preflight_only",
            "created_utc": datetime.now(timezone.utc).isoformat(),
            "board": before["board"],
            "request_rows": len(rows),
            "edit_rows": sum(row["action"] == "edit" for row in rows),
            "add_rows": sum(row["action"] == "add" for row in rows),
            "preflight_passed": True,
            "post_edit_verified": after is not None,
            "expected_track_count": expected.total(),
            "requested_old_tracks": compare.delta(removed, Counter())["removed"],
            "requested_new_tracks": compare.delta(Counter(), added)["added"],
            "sources": {
                "request": request_source,
                "before": before["sources"],
                "after": after["sources"] if after else [],
            },
            "limits": LIMITS,
        }
        if after:
            result.update(reconcile(before, after, expected, rows))
            result["post_edit_verified"] = result["request_compliant"]
        serialized = json.dumps(result, indent=2) + "\n"
        if args.output:
            with args.output.open("x", encoding="utf-8") as handle:
                handle.write(serialized)
        else:
            print(serialized, end="")
        print(
            f"{result['mode']}: {len(rows)} rows; expected {expected.total()} tracks; "
            f"post_edit_verified={result['post_edit_verified']}",
            file=sys.stderr,
        )
        return 0 if not result.get("failures") else 1
    except (OSError, ValueError, KeyError, csv.Error) as error:
        print(f"reconcile_tracks: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())

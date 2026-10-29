"""Compare saved Altium inventories and optional native DRC reports."""

import argparse
import csv
import hashlib
import io
import json
import re
import sys
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path, PureWindowsPath


HEADERS = {
    "board": "field value",
    "nets": (
        "net pin_count via_count routed_length_raw connectivity_invalid"
        " connections_visible"
    ),
    "pads": (
        "refdes pad net x_raw y_raw layer_id layer rotation_degrees top_x_size_raw"
        " top_y_size_raw hole_size_raw selected"
    ),
    "tracks": "net x1_raw y1_raw x2_raw y2_raw width_raw layer_id layer selected",
    "vias": (
        "net x_raw y_raw size_raw hole_size_raw low_layer_id high_layer_id selected"
    ),
    "connections": (
        "net x1_raw y1_raw x2_raw y2_raw layer1_id layer2_id mode redundant selected"
    ),
    "rules": "name kind_id priority drc_enabled scope1 scope2 summary",
}
LIMITS = [
    "Legacy AllLayers inventory omits some mechanical objects.",
    "Pad records are a placement proxy; component objects are not exported.",
    "Polygons, arcs, pad stacks, stackup, and reference continuity are not modeled.",
    "Connection counts need native reconciliation; invalid flags do not prove"
    " topology.",
    "Unchanged exported rules do not prove complete rules or active online DRC.",
    "A completed comparison does not establish routing or electrical acceptance.",
]


def read_source(path, encoding):
    """Read one stable file and return its text and identity."""
    before = path.stat()
    data = path.read_bytes()
    after = path.stat()
    if (before.st_size, before.st_mtime_ns) != (after.st_size, after.st_mtime_ns):
        raise ValueError(f"Source changed while reading: {path}")
    return data.decode(encoding), {
        "path": str(path.resolve()),
        "bytes": len(data),
        "sha256": hashlib.sha256(data).hexdigest(),
        "mtime_ns": after.st_mtime_ns,
    }


def read_inventory(directory, encoding="utf-8-sig"):
    """Load a complete export and reconcile its declared counts."""
    sources = []
    status, identity = read_source(directory / "inventory-status.txt", encoding)
    sources.append(identity)
    if status.strip() != "complete":
        raise ValueError(f"Inventory is incomplete: {directory}: {status.strip()}")
    tables = {}
    for name, header in HEADERS.items():
        text, identity = read_source(directory / f"{name}.tsv", encoding)
        sources.append(identity)
        reader = csv.DictReader(
            io.StringIO(text), delimiter="\t", quoting=csv.QUOTE_NONE
        )
        if reader.fieldnames != header.split():
            raise ValueError(f"Unexpected {name}.tsv header: {directory}")
        rows = list(reader)
        if any(None in row or None in row.values() for row in rows):
            raise ValueError(f"Malformed {name}.tsv row: {directory}")
        tables[name] = rows
    board_rows = tables.pop("board")
    board = {row["field"]: row["value"] for row in board_rows}
    if len(board) != len(board_rows):
        raise ValueError(f"Duplicate board field: {directory}")
    for field in (
        "board_file",
        "coordinate_units",
        "internal_units_per_mil",
        "x_origin_raw",
        "y_origin_raw",
    ):
        if not board.get(field):
            raise ValueError(f"Missing board field {field}: {directory}")
    if not PureWindowsPath(board["board_file"]).is_absolute():
        raise ValueError(f"Board identity is not a full Windows path: {directory}")
    net_names = [row["net"] for row in tables["nets"]]
    if len(net_names) != len(set(net_names)) or "" in net_names:
        raise ValueError(f"Empty or duplicate net name: {directory}")
    counts = {
        "net_count": len(tables["nets"]),
        "pad_count": len(tables["pads"]),
        "track_segment_count": len(tables["tracks"]),
        "via_count": len(tables["vias"]),
        "rule_count": len(tables["rules"]),
        "connection_object_count": len(tables["connections"]),
        "nonredundant_ratsnest_connections": sum(remaining_edges(tables).values()),
        "redundant_connection_objects": sum(
            row["redundant"] == "true" for row in tables["connections"]
        ),
        "connectivity_invalid_nets": sum(
            row["connectivity_invalid"] == "true" for row in tables["nets"]
        ),
    }
    for field, count in counts.items():
        if int(board[field]) != count:
            raise ValueError(
                f"{directory}: {field} declares {board[field]}, found {count}"
            )
    if int(board["internal_units_per_mil"]) <= 0:
        raise ValueError(f"Invalid unit conversion: {directory}")
    for name in ("pads", "tracks", "vias", "connections"):
        if any(row["net"] and row["net"] not in net_names for row in tables[name]):
            raise ValueError(f"Unknown net in {name}.tsv: {directory}")
    for source in sources:
        stat = Path(source["path"]).stat()
        if (stat.st_size, stat.st_mtime_ns) != (source["bytes"], source["mtime_ns"]):
            raise ValueError(
                f"Source changed during export comparison: {source['path']}"
            )
    return {"board": board, "tables": tables, "counts": counts, "sources": sources}


def remaining_edges(tables):
    """Count only nonredundant ratsnest edges by exact net name."""
    return Counter(
        row["net"]
        for row in tables["connections"]
        if row["mode"] == "ratsnest" and row["redundant"] == "false"
    )


def records(rows, track=False, fields=None):
    """Count records without selection, normalizing undirected track endpoints."""
    result = Counter()
    for row in rows:
        record = {key: value for key, value in row.items() if key != "selected"}
        if fields is not None:
            record = {key: record[key] for key in fields}
        if track:
            first, second = sorted(
                (
                    (int(record["x1_raw"]), int(record["y1_raw"])),
                    (int(record["x2_raw"]), int(record["y2_raw"])),
                )
            )
            record.update(
                x1_raw=str(first[0]),
                y1_raw=str(first[1]),
                x2_raw=str(second[0]),
                y2_raw=str(second[1]),
            )
        result[tuple(sorted(record.items()))] += 1
    return result


def delta(before, after):
    """Preserve duplicate occurrences in an exact record comparison."""
    added, removed = after - before, before - after
    return {
        "added_count": added.total(),
        "removed_count": removed.total(),
        "added": [
            {"record": dict(key), "count": count}
            for key, count in sorted(added.items())
        ],
        "removed": [
            {"record": dict(key), "count": count}
            for key, count in sorted(removed.items())
        ],
    }


def compare_inventories(before, after, allowed_nets=None):
    """Report whole-board, per-net, immutable-record, and geometry changes."""
    old, new = before["tables"], after["tables"]
    changes = {
        name: delta(
            records(old[name], track=name == "tracks"),
            records(new[name], track=name == "tracks"),
        )
        for name in ("pads", "rules", "tracks", "vias")
    }
    changes["net_assignments"] = delta(
        records(old["nets"], fields=("net", "pin_count")),
        records(new["nets"], fields=("net", "pin_count")),
    )
    immutable_board = (
        "coordinate_units",
        "internal_units_per_mil",
        "x_origin_raw",
        "y_origin_raw",
    )
    board_changes = {
        field: {"baseline": before["board"][field], "current": after["board"][field]}
        for field in immutable_board
        if before["board"][field] != after["board"][field]
    }
    old_edges, new_edges = remaining_edges(old), remaining_edges(new)
    geometry_nets = {
        entry["record"]["net"]
        for name in ("tracks", "vias")
        for direction in ("added", "removed")
        for entry in changes[name][direction]
    }
    nets = []
    for name in sorted(set(old_edges) | set(new_edges) | geometry_nets):
        if old_edges[name] != new_edges[name] or name in geometry_nets:
            nets.append(
                {
                    "net": name,
                    "baseline_remaining": old_edges[name],
                    "current_remaining": new_edges[name],
                    "reduction": old_edges[name] - new_edges[name],
                    "newly_complete": old_edges[name] > 0 and new_edges[name] == 0,
                    "geometry_changed": name in geometry_nets,
                }
            )
    regressions = []
    for name in ("pads", "rules", "net_assignments"):
        if changes[name]["added_count"] or changes[name]["removed_count"]:
            regressions.append(f"Immutable {name} records changed")
    if board_changes:
        regressions.append("Board origin or units changed")
    for name in ("tracks", "vias"):
        if changes[name]["removed_count"]:
            regressions.append(f"Baseline {name} removed or modified")
    if any(net["reduction"] < 0 for net in nets):
        regressions.append("Remaining edges increased on at least one net")
    unexpected = (
        sorted({net["net"] for net in nets} - allowed_nets)
        if allowed_nets is not None
        else []
    )
    if unexpected:
        regressions.append("Changes outside the allowed net set")
    return {
        "baseline_board": before["board"],
        "current_board": after["board"],
        "baseline_counts": before["counts"],
        "current_counts": after["counts"],
        "remaining_reduction": old_edges.total() - new_edges.total(),
        "newly_complete_nets": sum(net["newly_complete"] for net in nets),
        "changed_nets": nets,
        "unexpected_nets": unexpected,
        "immutable_board_changes": board_changes,
        "changes": changes,
        "regressions": regressions,
    }


def read_drc(path, encoding="utf-8-sig"):
    """Parse complete native DRC findings and validate every reported subtotal."""
    text, source = read_source(path, encoding)
    findings = Counter()
    sections, metadata = [], {}
    rule, rule_count, total, waived = None, 0, None, None
    for line in text.splitlines():
        if line.startswith("Processing Rule : "):
            if rule is not None:
                raise ValueError(f"Missing rule subtotal: {path}: {rule}")
            rule, rule_count = line.removeprefix("Processing Rule : "), 0
        elif line.startswith("   Violation between "):
            if rule is None:
                raise ValueError(f"Finding outside a rule: {path}")
            findings[(("rule", rule), ("finding", line.strip()))] += 1
            rule_count += 1
        elif match := re.match(r"Rule Violations\s*:\s*(\d+)$", line):
            if rule is None or rule_count != int(match[1]):
                raise ValueError(f"Invalid rule subtotal: {path}: {rule}")
            sections.append({"rule": rule, "count": rule_count})
            rule = None
        elif match := re.match(r"Violations Detected\s*:\s*(\d+)$", line):
            total = int(match[1])
        elif match := re.match(r"Waived Violations\s*:\s*(\d+)$", line):
            waived = int(match[1])
        elif match := re.match(r"(PCB File|Date|Time|Time Elapsed)\s*:\s*(.*)$", line):
            metadata[match[1]] = match[2]
    if rule is not None or total is None or waived is None or findings.total() != total:
        raise ValueError(f"Incomplete DRC or footer count mismatch: {path}")
    if "PCB File" not in metadata or not sections:
        raise ValueError(f"Missing DRC board identity or rule sections: {path}")
    return {
        "source": source,
        "metadata": metadata,
        "sections": sections,
        "findings": findings,
        "total": total,
        "waived": waived,
    }


def same_board(first, second):
    """Compare full Windows board paths without case differences."""
    return PureWindowsPath(first) == PureWindowsPath(second)


def main():
    """Write a comparison and return nonzero for invalid input or regressions."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("baseline", type=Path)
    parser.add_argument("current", type=Path)
    parser.add_argument("--baseline-drc", type=Path)
    parser.add_argument("--current-drc", type=Path)
    parser.add_argument(
        "--expected-board", help="Required full path in the current export"
    )
    parser.add_argument(
        "--allowed-nets", type=Path, help="Exact net names, one per line"
    )
    parser.add_argument("--encoding", default="utf-8-sig")
    parser.add_argument(
        "--output", type=Path, help="New JSON file; existing files are refused"
    )
    args = parser.parse_args()
    if bool(args.baseline_drc) != bool(args.current_drc):
        parser.error("--baseline-drc and --current-drc must be supplied together")
    try:
        before = read_inventory(args.baseline, args.encoding)
        after = read_inventory(args.current, args.encoding)
        if args.expected_board and not same_board(
            args.expected_board, after["board"]["board_file"]
        ):
            raise ValueError("Current inventory does not identify --expected-board")
        allowed = None
        if args.allowed_nets:
            names = args.allowed_nets.read_text(encoding=args.encoding).splitlines()
            names = [name for name in names if name and not name.startswith("#")]
            if (
                not names
                or len(names) != len(set(names))
                or any(name != name.strip() for name in names)
            ):
                raise ValueError(
                    "Allowed net list is empty, duplicated, or has surrounding"
                    " whitespace"
                )
            allowed = set(names)
            unknown = allowed - {row["net"] for row in after["tables"]["nets"]}
            if unknown:
                raise ValueError(f"Unknown allowed nets: {sorted(unknown)}")
        result = compare_inventories(before, after, allowed)
        result.update(
            created_utc=datetime.now(timezone.utc).isoformat(),
            sources=before["sources"] + after["sources"],
            limits=LIMITS,
        )
        if args.baseline_drc:
            baseline_drc = read_drc(args.baseline_drc, args.encoding)
            current_drc = read_drc(args.current_drc, args.encoding)
            for inventory, report in ((before, baseline_drc), (after, current_drc)):
                if not same_board(
                    inventory["board"]["board_file"], report["metadata"]["PCB File"]
                ):
                    raise ValueError(
                        "DRC report board differs from its inventory board"
                    )
            drc_delta = delta(baseline_drc["findings"], current_drc["findings"])
            processed_rules = delta(
                records(baseline_drc["sections"], fields=("rule",)),
                records(current_drc["sections"], fields=("rule",)),
            )
            result["drc"] = {
                "baseline": {
                    key: value
                    for key, value in baseline_drc.items()
                    if key != "findings"
                },
                "current": {
                    key: value
                    for key, value in current_drc.items()
                    if key != "findings"
                },
                "changes": drc_delta,
                "processed_rule_changes": processed_rules,
            }
            if processed_rules["added_count"] or processed_rules["removed_count"]:
                result["regressions"].append("Native DRC processed rule set changed")
            if any(
                entry["record"]["rule"].startswith(
                    (
                        "Clearance Constraint",
                        "Short-Circuit Constraint",
                        "Width Constraint",
                        "Hole Size Constraint",
                        "Routing Via",
                    )
                )
                for entry in drc_delta["added"]
            ):
                result["regressions"].append(
                    "New native clearance, short, width, hole, or via finding"
                )
            if current_drc["waived"] != baseline_drc["waived"]:
                result["regressions"].append("Native waived-finding count changed")
        if args.output:
            if args.output.suffix.lower() != ".json":
                raise ValueError("Output must be a new .json file")
            with args.output.open("x", encoding="utf-8") as output:
                json.dump(result, output, indent=2)
                output.write("\n")
            print(
                json.dumps(
                    {
                        "output": str(args.output.resolve()),
                        "remaining_reduction": result["remaining_reduction"],
                        "newly_complete_nets": result["newly_complete_nets"],
                        "changed_nets": len(result["changed_nets"]),
                        "new_drc_findings": result["drc"]["changes"]["added_count"]
                        if "drc" in result
                        else None,
                        "removed_drc_findings": result["drc"]["changes"][
                            "removed_count"
                        ]
                        if "drc" in result
                        else None,
                        "regressions": result["regressions"],
                    },
                    indent=2,
                )
            )
        else:
            print(json.dumps(result, indent=2))
        return 1 if result["regressions"] else 0
    except (OSError, ValueError, KeyError, UnicodeError) as error:
        print(f"Comparison failed: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())

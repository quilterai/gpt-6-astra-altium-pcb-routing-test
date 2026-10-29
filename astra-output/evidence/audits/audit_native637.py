"""Audit RXD3 native Push and moved via contacts against RXD3 keeper636."""

import ast
import json
import math
import sys
from pathlib import Path

RUN = Path(__file__).resolve().parents[1]
sys.path[:0] = [str(RUN.parents[1] / "scripts"), str(RUN / "electrical")]
import compare_routing as compare
import reconcile_tracks as reconcile
from geometry_review import Geometry, point, rectangle, raw_point, segment_segment, point_segment, segment_polygon

source = (RUN / "quality/sweep163-anchors.py").read_text().replace(
    "def anchors(", "def component_objects("
).replace(
    "answer=[];seen=set()", "return [objects[i] for i in connected]\n    answer=[];seen=set()"
)
tree = ast.parse(source)
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n, ast.FunctionDef) and n.name == "component_objects"], type_ignores=[]), "contacts", "exec"))


def terminals(component):
    """Return explicit pads and vias connected to one source pad."""
    result = set()
    for item in component:
        row = item["row"]
        if item.get("pad"):
            result.add(("pad", row["refdes"], row["pad"]))
        if item.get("via"):
            result.add(("via", row["net"], row["x_raw"], row["y_raw"]))
    return result


def groups(model, net):
    """Map each pad to explicit terminals in its connected copper component."""
    global G
    G = model
    result = {}
    for pad in G.pads:
        if pad["net"] != net:
            continue
        seed = point(pad["x_raw"], pad["y_raw"])
        result[(pad["refdes"], pad["pad"])] = terminals(
            component_objects(net, seed, int(pad["layer_id"]))
        )
    return result


old = compare.read_inventory(RUN / "batches/637-rxd3-native-via/before")
new = compare.read_inventory(RUN / "batches/637-rxd3-native-via/after")
original = compare.read_inventory(RUN / "baseline-inventory")
change = compare.compare_inventories(old, new)
old_tracks = reconcile.track_records(old["tables"]["tracks"])
new_tracks = reconcile.track_records(new["tables"]["tracks"])
original_tracks = reconcile.track_records(original["tables"]["tracks"])
track_delta = compare.delta(old_tracks, new_tracks)
lost_original = compare.delta(original_tracks & old_tracks, original_tracks & new_tracks)["removed"]
via_delta = compare.delta(
    compare.records(old["tables"]["vias"]), compare.records(new["tables"]["vias"])
)
changed_nets = sorted({entry["record"]["net"] for direction in ("added", "removed") for entry in track_delta[direction]})
changed_nets = sorted(set(changed_nets) | {entry["record"]["net"] for direction in ("added", "removed") for entry in via_delta[direction]})
before = Geometry(RUN / "batches/637-rxd3-native-via/before")
after = Geometry(RUN / "batches/637-rxd3-native-via/after")
via_moves = {}

terminal_report = []
for net in changed_nets:
    old_groups = groups(before, net)
    new_groups = groups(after, net)
    deficits = []
    assert old_groups.keys() == new_groups.keys(), net
    for pad, old_set in old_groups.items():
        mapped_old = {via_moves.get(item, item) for item in old_set}
        missing = mapped_old - new_groups[pad]
        if missing:
            deficits.append(dict(pad=pad, missing=sorted(missing)))
    terminal_report.append(dict(net=net, pad_count=len(old_groups), deficits=deficits))
    print("TERMINALS", net, len(old_groups), len(deficits), flush=True)

source_raw = (125347700, 91169900)
source_via = [via for via in after.vias if via["net"] == "SAI1_RXD3" and
              (int(via["x_raw"]), int(via["y_raw"])) == source_raw]
result = dict(
    baseline="batches/637-rxd3-native-via/before", after="batches/637-rxd3-native-via/after",
    old_counts=old["counts"], new_counts=new["counts"],
    changed_nets=change["changed_nets"], track_delta=track_delta, via_delta=via_delta,
    changed_geometry_nets=changed_nets, lost_original_tracks=lost_original,
    terminal_report=terminal_report, source_via_count=len(source_via),
    accepted_via_moves=[dict(old=list(key), new=list(value)) for key, value in via_moves.items()],
    immutable_changes={name: change["changes"][name] for name in ("pads", "rules", "net_assignments")},
    board_changes=change["immutable_board_changes"], raw_regressions=change["regressions"],
    no_net_edge_regression=all(item["reduction"] >= 0 for item in change["changed_nets"]),
    pass_terminal_preservation=all(not item["deficits"] for item in terminal_report),
)
(RUN / "quality/native637-source-audit.json").write_text(json.dumps(result, indent=2) + "\n")
print("DELTA", track_delta["removed_count"], track_delta["added_count"], via_delta,
      "ORIGINAL", len(lost_original), "SOURCE VIA", len(source_via),
      "EDGES", old["counts"]["nonredundant_ratsnest_connections"], new["counts"]["nonredundant_ratsnest_connections"], flush=True)

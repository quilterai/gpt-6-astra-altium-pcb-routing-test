# Fixed L5 supply polygon

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

[FullPolygon.PrjScr](../scripts/FullPolygon.PrjScr) contains a read-only
`ExportFullPolygons` entry and a single-object `AddExplicitFullPolygon` entry.
The source accepts only the full-run working PCB path resolved relative to
`astra-run/` from the loaded script project.
Creation is limited to the reviewed `NVCC_DRAM_1V1` rectangle on legacy layer 5
(`L5_PWR_1`), with exactly 10 existing polygons and no existing layer-5 polygon.
The controller alone runs it. It does not save, repour, rebuild, change rules,
change the stack, change existing objects, or run UI/process commands.

The new definition uses solid fill, signal-layer polygon type, pour over
same-net objects, and removal of dead copper. Other new-polygon defaults are
exported for native review. The script does not assign clearance or connection
style overrides; existing rules remain responsible for native pouring.

## Input and evidence

From `astra-run/`, create the directory
`runs/full-routing-2026-09-30/quality/full-polygon/` before running either entry.
Archive its previous outputs before each invocation.
The creation request is `add-polygon.tsv`, with exactly one data row and this
header, separated by literal tabs:

```text
net	layer_id	expected_polygon_count	x1_raw	y1_raw	x2_raw	y2_raw	x3_raw	y3_raw	x4_raw	y4_raw
NVCC_DRAM_1V1	5	10	115883500	89394100	124133500	89394100	124133500	97694100	115883500	97694100
```

These absolute raw vertices correspond to board-relative mil positions
`(25,650), (850,650), (850,1480), (25,1480)`. They are fixed in the source;
different nets, layer IDs, counts, corners, extra rows, extra columns, signed
numbers, fractions, or integer overflow cause a refusal before board addition.
The complete request is preserved in `full-polygon-request.tsv`.

`ExportFullPolygons` writes sorted `polygons.tsv` definitions and a terminal
`export_complete_read_only` status with the native polygon count. Its fields
include net, layer, type, fill, pour settings, and each native boundary segment.
Segments include indices zero through `PointCount`, including the closing entry,
and serialize kind, vertex X/Y, arc center X/Y, radius, and both angles;
these raw values do not subtract the board origin. Selection and cached pour
regions are excluded. Float formatting follows the native locale.

Creation writes `before-polygons.tsv`, constructs one detached object, and
reads every requested field and all four vertices plus the closing entry back
before calling `AddPCBObject`. It also rechecks the old polygon definitions.
After one board addition and Undo registration, it requires a count increase
from 10 to 11 and exact equality of the sorted old definition export.
`after-old-polygons.tsv` and `added-polygon.tsv` preserve those readbacks.
The new rectangle stores four edges and repeats vertex zero in the closing
entry. Native qualification must confirm that representation and the displayed
boundary before pouring.

Only `added_definition_readback_ok_pour_and_drc_not_checked` establishes a
completed addition. Read the fresh `full-polygon-status.txt`, including its
before/after counts. Parse errors can occur before any file write; an old
success file is not evidence of a new run. An error at or after
`add_and_register_polygon_inspect_on_interruption` can leave a board addition.
Inspect the native board and export again before retrying. An interrupted
addition is not automatically removed.

## Qualification and recovery

Native qualification completed on September 30, 2026, using a disposable copy
of checkpoint 013. A changed coordinate and an extra blank input row were
refused. Creation added exactly one definition; one native Undo restored all
10 original definitions and Redo restored the new definition. Repour, DRC,
inventory, and save/reopen checks passed. Production uses the same source,
apart from the two guarded paths and a final blank line in the trial copy.

The production pour reduced remaining connections from 537 to 495, entirely
on `NVCC_DRAM_1V1` (71 to 29). Tracks, vias, pads, rules, and net assignments
were unchanged. DRC at 19:52 UTC reported 3,978 findings: 75 removed (44
airwires and 31 antennas), two added airwires, and no added physical findings.
All 10 old exported polygon definitions remained byte-identical. Checkpoint
014 saved at 19:54:45 UTC and reopened with exact geometry and connectivity.
Original-run evidence was under `quality/full-polygon/` and
`checkpoints/014-nvcc-plane/`, relative to
`astra-run/runs/full-routing-2026-09-30/`; these runtime artifacts are not
included. The `quality/` paths in the API evidence below use the same run root.

Native defaults include 5 mil neck removal and removal of islands below
2,500 square mil. The report has no dedicated thermal or island check
sections. Remaining surface-pad connections, supply capacity, and reference
continuity still require electrical review. Use this sequence for a changed
helper or geometry:

1. Preserve a saved/reopened checkpoint and complete base inventory. Run the
   read-only entry first. Require 10 polygons and compare their boundaries with
   the saved source. The original four-edge Top rectangle provides a useful
   native `PointCount` check against its five stored vertices including closure.
2. Test a changed last raw coordinate and preserve the refusal plus an unchanged
   base inventory and polygon export. Then stage the exact reviewed request.
3. Require the successful addition status and verify the new native L5 rectangle,
   net, fill, all new-polygon defaults, and unchanged old definitions. Compare
   pads, tracks, vias, rules, and component placement independently.
4. Exercise one native Undo and export: all 10 old definitions and base geometry
   must be restored. Redo must restore exactly the one definition. The script
   does not issue Undo or Redo itself.
5. Use native repour and complete DRC. Verify the rail's actual connected copper,
   all intended source/load vias, disconnected islands, necks, clearances, and
   effects on signal references. Save/reopen and repeat the decisive checks.

Definition readback does not establish copper connectivity, current capacity,
thermal performance, impedance, reference continuity, or electrical acceptance.
The base track/via inventory does not include polygon fill regions. Existing
polygon equality covers only the exported fields, not every hidden API value.

## API basis

The [Altium polygon API reference](https://www.altium.com/documentation/altium-dxp-developer/pcb-api-design-objects-interfaces-reference)
documents the polygon boundary and setter interfaces. The
[type reference](https://www.altium.com/documentation/altium-dxp-developer/pcb-api-types-reference)
defines the polygon, solid-fill, and line-segment enum values. Read-only metadata
inspection of the installed AD26 `Altium.SDK.Interfaces.dll` confirms the
corresponding setters and `ePolygonPourOver_SameNet`. Evidence is under
`quality/polygon-legacy-types.json` and `quality/polygon-installed-methods.json`.
The stored original polygons repeat the first vertex after the last edge.
The old scripting documentation and installed metadata do not by themselves
prove that every API is exposed to this DelphiScript runtime.

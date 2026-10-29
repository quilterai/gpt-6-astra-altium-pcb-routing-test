# Explicit full-run vias

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

[FullVia.PrjScr](../scripts/FullVia.PrjScr) exposes `AddExplicitFullVias`.
It adds 1–16 explicitly planned Top–Bottom vias to the active PCB only when
its full path matches this location under `astra-run/`:

```text
work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc
```

The maintained helper resolves that location from its loaded script project;
see [current path setup](../scripts/README.md#paths-in-this-checkout). The `runs/`
paths below use the same `astra-run/` base.

The controller alone runs the helper. It does not search for a route, change
rules or component placement, save the board, repour, redraw, open a dialog,
or run an editor process command. The only geometry operation is the
`TrialVia` sequence: `PreProcess`, via factory, explicit property assignment,
`AddPCBObject`, `PCBM_BoardRegisteration`, and `PostProcess` in `finally`.
Each row uses a separate sequence. Single-via Undo and Redo are qualified;
multi-row Undo behavior remains unqualified.

## Qualified BGA pad centers

The helper permits two exact pad-center requests: SD3_DATA5 at raw
`(132856300, 97029400)` and DRAMB_DATA6 at `(118854200, 91962000)`. Each
request must match Top SMD pad B4 on the same net, with a 160000-unit
diameter and 80000-unit hole. Other pad centers, drilled pads,
wrong nets or dimensions, and existing via centers remain refused. The
full-board path and count guards still apply.

The original batch-075 request stopped before any mutation at this pad
center. Checkpoint `020-ground-and-ddr` preserves the board before the
scoped exception. After closing and reopening the saved script source,
the five-via batch passed all native count, geometry and net readbacks.
Its companion 30-track batch also passed. The immutable request and receipts
are in `runs/full-routing-2026-09-30/batches/075-sd3-data5/`.

Independent geometry checks include every copper layer, holes, global
keepouts and reserved DDR access sites. The minimum joint clearance is
3.3085 mil and the minimum hole gap is 12 mil. Native DRC, BGA via fill or
cap requirements, and fabrication acceptance remain unverified. The shifted
SD3_DATA7 via at U4-B6 also overlaps an SMD pad and shares this fabrication
limitation.

Batch 087 qualifies the DRAMB_DATA6 U2-B4 exception with three successful
via readbacks. Independent checks measured at least 3.37 mil copper clearance
and 12.2485 mil hole separation for the combined twenty-track, three-via
request. Final native inventory reconciliation confirms the exact requested copper. Its BGA
via fill and cap requirements are also unverified.

## Request and result

The existing output directory is
`runs/full-routing-2026-09-30/quality/full-via/`. Preserve previous outputs
before each run. Create `add-vias.tsv` there with this exact six-column header,
using literal tabs and one data row per via:

```text
net	x_raw	y_raw	size_raw	hole_size_raw	expected_via_count
```

Use raw coordinates from the current native inventory. The board reports
10,000 internal units per mil; these are absolute raw coordinates, without
subtracting the user origin. `size_raw` is the via diameter. Every row must
use the same whole-board via count from before the batch. A batch of N rows
expects that count to increase by exactly N; do not increment the request's
count between rows.

All rows are validated before the first geometry write:

- Exactly 1–16 rows and six fields, with no blank or comment rows.
- Exact, nonempty, case-sensitive existing net names without surrounding space.
  Each name must resolve to one net. Several vias may use the same net.
- Decimal integers only, from 0 through 2,147,483,647. Coordinates, diameter,
  and hole must be positive; the hole must be smaller than the diameter.
  The expected final via count must not overflow.
- No repeated requested center, even on different nets.
- No existing via at any requested center, on any layer returned by the
  same legacy iterator as `TrialVia`. Pad centers are also refused, except
  the qualified SD3_DATA5 location described below.
- The actual whole-board via count equals the common requested pre-batch count.

Before each row, the helper checks the active board path and expected current
via count again. After adding a via, it reads back the count, exact coordinates,
diameter, hole, Top/Bottom span, and net. It stops at the first mismatch.

| File | Meaning |
|---|---|
| `full-via-request.tsv` | A snapshot of the loaded request, including rejected row content |
| `full-via-status.txt` | Last stage, expected board path, current row, completed readbacks |
| `full-via-audit.tsv` | One row per planned via after preflight; measured fields replace requested fields after each addition |

Audit rows marked `pending_not_started` contain requested geometry and an
expected before-count. `creating_inspect_on_interruption` means the row may
have been added. Rows with `added_readback_ok_drc_not_checked` contain actual
readbacks. The terminal success stage is
`added_batch_readback_ok_drc_not_checked`; require a fresh file and exactly N
completed readbacks. A preflight refusal leaves an empty audit table and no
geometry changes. Parse errors can precede every file write, so an old success
file is not evidence of a new run. The directory must exist and be writable;
a file error stops the script and can occur after earlier rows were added.

This helper checks exact center conflicts only. It does not check different
center overlaps, track/polygon clearance, pad annuli, board edges, rule-compliant
dimensions, stack compatibility, plane antipads, connectivity, or timing.
Readback success does not establish DRC safety or a completed connection.

## Qualification and recovery

The underlying single-via API was live-qualified in `TrialVia` on AD26.10.1.5:
one via increased the count by one, native Undo restored the geometry, and
Redo restored the via. The full-run source also passed the native checks below,
including a rejected final row, exact single-via Undo/Redo, and multi-row
additions. Those results do not establish multi-row Undo behavior or qualify
refusal branches that were not exercised.

1. Back up the saved full-run work board and preserve its completed inventory.
   Select the exact active PCB, then use File > Open for `FullVia.PrjScr` and
   File > Run Script for `AddExplicitFullVias`.
2. Qualify refusal with a deliberately invalid final request row after a valid
   planned first row. Check the reported row and compare a fresh inventory to
   prove no prefix of the batch was added. Also check a stale count and an
   occupied or duplicate center. Do not change the path guard for these checks.
3. Qualify one independently checked via first. Compare before/after inventories:
   exactly the requested via is added; existing copper, pads, rules, net pin
   counts, and component placement remain unchanged. Check native geometry and
   DRC. Use the established native repour workflow where applicable.
4. Check native Undo and Redo with exact inventory comparisons. Before relying
   on Undo to recover a multi-row batch, record how many steps restore that
   batch. Do not assume one Undo removes the entire batch.
5. Archive the request, status, audit, source hashes, native inventory, and DRC
   evidence in the batch directory before reusing the output directory.

On an exception, interruption, or nonterminal stage, stop and inspect the
board. `completed_readbacks` counts verified rows, not all possible edits: the
current row may also exist. Do not blindly rerun with a changed expected count.
Recover with qualified native Undo or the saved checkpoint, then compare the
exact geometry. There is no automatic rollback or deletion in this helper.

For the saved inventory comparison, use [compare_routing.py](../scripts/compare_routing.py)
with that batch's immutable before and after directories, `--expected-board` set
to the exact full Windows PCB path recorded in the inventories (the absolute
form of the work-board path above), and `--allowed-nets` set to the preserved
request's exact net names, one per line. New vias can leave ratsnest counts
unchanged. Exit zero
does not replace native DRC and group acceptance.

## Native full-run evidence

The audited runs used `FullVia.pas` SHA256
`6bc2363248a6898b044a3a2a18b0859ae361aa21222e3bfd5399317c0b018295`.
Evidence is under `runs/full-routing-2026-09-30/`:

| Check | Exact saved result |
|---|---|
| Invalid second-row net | Refused with zero completed readbacks; all exported copper, pads, rules, and net membership unchanged |
| One requested via | 372 to 373 vias; only the requested `DRAMA_SDQS1_T` via added |
| Single-via Undo and Redo | Undo restores the 372-via geometry; Redo restores the same requested 373-via geometry |
| Remaining five strobe-access vias | 373 to 378 vias; all five request rows and the cumulative six-via result match |
| Batch 009 | 16 requested vias added, 378 to 394; separate track additions also reconciled |
| Batch 011 | 16 requested GND vias added, 394 to 410; separate track edits and additions also reconciled |
| Batch 012 | Three chunks of 16, 16, and eight vias added, 410 to 450; all 40 via audit rows match |

The initial evidence is in `quality/full-via/qualification-*` and the
`quality/full-via-guard-review.json`, `full-via-single-review.json`,
`full-via-single-undo-review.json`, `full-via-single-redo-review.json`, and
`full-via-six-review.json` files. Later exact checks are
`quality/batch009-exact-review.json`, `batch011-exact-review.json`, and
`batch012-exact-review.json`; their source records identify the preserved
requests, native audits, and inventories.

These comparisons qualify the measured geometry changes. Native repour, DRC,
connectivity, and electrical acceptance remain separate. The single-via
Undo/Redo evidence does not prove whole-batch rollback or the number of Undo
steps needed after several additions.

## Exact inherited-track selector

[FullViaSelect.PrjScr](../scripts/FullViaSelect.PrjScr) is separate from the
geometry helper. It exposes three selection-only entry points:

| Entry point | Exact no-net Top track, raw coordinates and width |
|---|---|
| `SelectFullInheritedU1M2Track` | (122421750,94885250)–(122520200,94786800), width 30000 |
| `SelectFullInheritedU1N2Track` | (122421750,94688350)–(122520200,94589900), width 30000 |
| `SelectFullInheritedU4K5Track` | (133053200,95454600)–(133230700,95277100), width 100000 |

The coordinates come from the immutable native baseline and
`quality/inherited-short-endpoints.json`. Each procedure requires the exact
active work PCB and exactly one track with unordered matching endpoints,
matching width, Top layer, and a nil or empty net. No match or multiple matches
leaves selection unchanged. Success selects that one candidate and verifies
its `Selected` flag. It does not remove geometry, assign a net, or select the
U4-K5 endpoint via.

The selector preserves other selections. Use native Deselect All before the
script and inspect the resulting selection before any later edit. The legacy
`AllLayers` iterator cannot prove exclusive selection across newer mechanical
layers, so the status explicitly says `exclusive_selection_checked=false`.
It writes `full-track-selection-status.txt` and `full-track-selection-audit.tsv`
in the same output directory. Terminal success is `selected_candidate_only`.
No redraw, native delete, or save is called. Electrical intent must be resolved
before a repair; the recorded touching pads also have empty net fields.

The selector reuses the qualified TrialVia exact-track matching and selection
pattern. Its three fixed candidates and live readback remain unqualified.

# Full-run quality review

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

Read-only handoff audit: 2026-09-30 04:38 UTC. The main controller owns live
Altium, project edits, checkpoint creation, and publication. This review uses
saved evidence; it does not establish current online DRC settings or inspect
the live PCB.

## Prepared-trial integrity audit

The historical prepared-trial package passed the saved-file and evidence-count
checks below. That intermediate package is not included in this repository.
Its file counts describe the original trial audit, not the public release's
current manifest. The full-board run started from unchanged original input,
not the trial result.

| Independent check | Result |
|---|---|
| Checkpoint file sizes and SHA-256 | All 50 manifest entries match |
| Original input integrity | All 27 original manifest entries match |
| Published project source identity | All 24 source files match the saved trial |
| Project document resolution | All 19 paths exist inside the checkpoint project: 18 source documents and one generated report |
| PCB | 9,552,384 bytes; SHA-256 `cf8253b370543494b4f429fb7b368ae060b40e27bc1054c65916a7e33f0bd655` |
| Native Board Information | Total 1,109; routed 252 to 272; remaining 857 to 837 |
| Inventory | 321 nets, 1,593 pads, 78 rules; remaining connections 857 to 837 |
| Ledger | All 20 rows agree with exact exported pad sets and remaining-edge counts; 18 newly complete nets; net reduction 20 |
| Connection changes outside ledger | None |
| Tracks | 84 added; zero removed baseline segments; 53 Top and 31 Bottom additions |
| Vias | One added; zero removed baseline vias; NetD1_C at raw `(131936400, 99451500)`, diameter 160000, hole 80000, layer IDs 1–32 |
| Pads and rules | Baseline/final files are byte-identical |
| DRC | 4,320 to 4,300; 3 added and 23 removed exact rule/finding occurrences; zero waived |
| New clearance, short, width findings | Zero in the exact multiset comparison |

Track comparison ignores selection and treats reversed endpoint order as the
same segment. Duplicate occurrences remain distinct. DRC comparison uses each
full rule and finding string with duplicate counts; category subtraction alone
does not establish this result. Every native rule subtotal and final total
agrees with the parsed finding count.

The native reports contain 32 processed rule sections. This count is different
from the 78 exported rule objects; routing rules need not produce DRC report
sections. Neither quantity proves that online checks are active. The prior
controller documented a 100,000 finding limit; the report files alone do not
preserve the whole batch/online settings dialog.

The three exact new findings are the changed `PMIC_NINT` airwire description,
an antenna on its retained partial Top track, and a Top Overlay
`.ProjectNameShort` board-edge collision. The 12 unassigned-copper unrouted
findings and three short findings are unchanged. Shorts involve U1-M2, U1-N2,
and U4-K5 with unassigned tracks. These remain electrical blockers.

The fresh full-run export also shows empty net assignments on those three pads.
U1-M2 and U1-N2 each touch one unassigned 3 mil Top diagonal. U4-K5 touches an
unassigned 10 mil Top diagonal ending at an unassigned 16/8 mil through via.
`quality/inherited-short-endpoints.json` under the full run records exact rows.
This evidence does not establish intended net assignments or whether the pins
should be unconnected; schematic and part-pin review must precede a repair.

The report records 849 unrouted findings: 837 connection edges plus the 12
unassigned-copper findings. `USB2_VBUS` accounts for two completed edges;
`USB1_VBUS` accounts for one edge but remains incomplete. `PMIC_NINT` has no
net reduction. No count supports a 50-net trial or fabrication acceptance.

The checkpoint records save/close/reopen on the source trial and a 04:16:56
reopened export. The result files match that source. This offline audit verifies
the saved records and copied-file identity; it is not a second live reopen.
The inventory marks all 321 nets connectivity-invalid after reopen, so those
flags do not establish completed endpoint topology. Native counts and the
endpoint ledger provide the reconciled measurements.

Local detailed audit: `runs/full-routing-2026-09-30/quality/trial-audit.json`.
The corresponding `trial-added-tracks.tsv` records per-net added length,
layer, width, and segment count. All additions use 4.1 mil width. These lengths
exclude unchanged fanout and do not measure delay, return continuity, or path
quality. `PMIC_NINT` retains 35.249 mm of new partial copper with no accepted
connection reduction; it is evidence of rework cost, not throughput.

## Fresh full-run inventory

The independent comparison of `runs/full-routing-2026-09-30/baseline-inventory/`
with the preserved trial baseline passed. The helper required the full active
working path under `work/full-routing-2026-09-30/QCMI_SOM8MM/`.
It found 321 nets, 1,593 pads, 2,825 legacy track objects, 372 vias, 857 remaining
connection objects, and 78 rules. There are zero changed pad/rule/net-assignment
records, zero changed track/via records, zero changed connection counts by net,
and unchanged origin and units. The output is local at
`runs/full-routing-2026-09-30/quality/full-baseline-comparison.json`.

This confirms the exported initial geometry matches the historical baseline.
Fresh native reports, online-check evidence, full component placement, stackup,
and polygon/reference evidence remain separate checks. No full-run copper is
credited by this comparison.

## Independent acceptance checks

1. Before new copper, preserve fresh native Board Information, batch DRC,
   inventory, settings evidence, and original-equivalent copy hashes. Confirm
   online clearance, short, width, and via checks through current Altium state.
2. For each useful batch, compare pad attributes, net names/pin counts, rule
   records, origin/units, and existing tracks/vias. A component move, rule
   change, deleted inherited copper, or change outside the intended net set
   needs explicit investigation. Pad positions are only a proxy for component
   placement because the existing export lacks component objects.
3. Reconcile intended endpoint groups and whole-board remaining counts. Record
   newly completed nets separately from completed edges and partial geometry.
   Verify all new segment nets, widths, layers, endpoints, and via spans.
4. Inspect whole paths, pad entries, neighbor clearances, reference copper,
   layer transitions, and applicable electrical requirements. TSV inventory
   omits polygon geometry, arcs, pad stacks, and actual reference continuity;
   it cannot establish clearance or electrical acceptance alone.
5. At meaningful group/save milestones, compare native DRC as an exact multiset.
   Show all new/resolved findings even when the total decreases. Keep inherited
   shorts and unresolved timing requirements as blockers.
6. Verify File > Save completion with the intended PCB active, then preserve
   the complete project, file hashes, report time, and ledger. Reopen the best
   checkpoint and reconcile fresh native/inventory evidence before publication.

## Comparison tools

The existing exact export is `TrialInventory.PrjScr > ExportTrialInventory`.
The controller must adapt and qualify its full-path/output guards for the new
working project; the trial guard cannot identify full-run evidence. Require
fresh `inventory-status.txt` containing `complete` and all expected tables.
`ExportAndSelectAllowlistedNets` also selects and zooms; its inventory describes
the state before that selection and needs a separate selection inspection.

The offline [comparison helper](../scripts/compare_routing.py) compares saved
exports without calling Altium, preserves exact finding multiplicity and track
endpoint normalization, and checks immutable records and complete count data.
The [scripts README](../scripts/README.md#compare-saved-inventories-and-native-drc-reports)
provides invocation, exit codes, tests, and limits. The initial preserved-trial
comparison took 0.28 seconds including the `uv` launcher and independently
reproduced this audit. Its complete output is local at
`runs/full-routing-2026-09-30/quality/trial-comparison.json`; the final helper
recheck is `trial-recheck.json` in the same directory. All six focused tests
passed after the final code edits.

Fresh full-run validation must not reuse the trial's evidence merely because
the initial copper has the same hash. The controller reported a complete new
copy containing all 27 verified original manifest entries plus a generated
`QCMI_SOM8MM.PrjPcbStructure` file whose additional hash was preserved. The new
baseline reports and path-qualified inventory remain separate evidence.

## Verified full-run batches through 011

The saved batch011 inventory contains 3,113 tracks, 410 vias, and 798 remaining
connection edges. Its 1,593 pad records, 78 rule records, net assignments, and
origin remain unchanged from its before inventory. The component export at
05:23 UTC separately matched all 228 original component positions, rotations,
layers, footprints, and designators. Later pad comparisons remain a placement
proxy; they do not replace a fresh component export.

| Batch | Exact new copper and edits | Connection evidence |
|---|---|---|
| 009 ordinary access | 16 requested vias and 21 requested Top tracks; no removed copper | 818 inventory edges; later native DRC required |
| 010 ordinary Bottom | 14 new 4.1 mil Bottom tracks; no removed copper | 818 to 814 edges; JTAG_MOD, NetD1_C, SYS_NRST, and TEST_MODE completed |
| 011 ground and connector repairs | 16 GND vias, 16 GND Bottom leads, four connector endpoint edits, and two connector track additions | 814 to 798 total edges; GND 213 to 197; other net edge counts unchanged |

Batch011's four edited tracks were created during this run. None was an
original baseline track. The exact combined request accounts for every changed
track and via; all 38 native audit rows agree. The ordinary comparison retains
its track-modification warning, while the explicit request comparison proves
that only those four targets changed. The detours preserve each local path's
external endpoints, net, layer, and 4.1 mil width.

The 07:12:01 native DRC after repour reports 4,317 findings, versus 4,336 before
batch011. Exact comparison finds seven added GND airwire descriptions and 23
removed GND airwire descriptions, a net reduction of 16. The targeted two J4
connector clearance findings and SD2_NRST short are removed. No other finding
multiset changed, including width, via, differential-pair, and antenna findings.

These reports process 41 rule sections. This coverage is wider than the original
32 sections: Routing Layers, Routing Via Style, six Differential Pairs Routing
rules, and Component Clearance were enabled later. The earlier context-menu
attempt did not establish that all batch checks were enabled. Reported coverage
must follow the actual processed rule sections; neither 41 sections nor 78
exported rules proves every native check is enabled.

Global acceptance remains pending. Inherited shorts, the two TESTMODE CPU
clearance findings, extended undersized fanout copper, differential-pair
uncoupled findings, routing through reserved DDR areas, and timing/reference
requirements are not resolved by the successful local ground batch. A lower
total finding count does not waive these constraints.

Detailed evidence is under `runs/full-routing-2026-09-30/quality/`:

- `batch009-exact-review.json`: complete requested additions and audit agreement.
- `batch010-drc-review.json`: 11 new access-via antennas, 12 replacement unrouted
  descriptions, and four completed connections explain the earlier net increase
  of seven findings.
- `batch011-exact-review.json`: exact copper, immutable records, per-net edges,
  and native DRC after repour.
- `batch012-combined-geometry-review.json`: offline preflight of the queued
  40-via, 47-track combination. It is not execution evidence.

The queued `local-ground-02`, `local-ground-03`, and `local-ground-04` proposals
contain 16, 14, and three access sites. Their geometry reserves ordinary signal
access02 through access04 and the earlier ground groups. Request counts reflect
the documented proposed execution order and must be refreshed from the actual
saved inventory if that order changes. Each group still needs native repour,
DRC, and connection verification.


## October 1, 2026: CSI local repairs 409 and 410

**1,020 / 1,109 required connections routed (91.97%), 89 remaining.** Native inventory confirms 233 of 321 named nets complete, 6,800 tracks, and 843 vias.

Batches 409 and 410 complete CSI_D0_P and CSI_D2_P. Exact native readback and repour confirm the requested copper and preserve all neighboring connections, pads, rules, and net assignments. The two repairs add 94 tracks, replace nine run-added tracks, and add four vias. No original copper changes in these batches.

Both CSI signals use their existing fixed 15 mil L2 differential width. Their L2 legs are 537.162 and 640.630 mil, beyond earlier short-escape planning limits. The repairs preserve DSI_D3_P, VDD_SOC_0V8, VDD_PHY_0V9, UART2_RXD, UART1_CTS, and UART4_TXD. Supply current capacity, return paths, coupling, length, and impedance remain pending. The exact retained UART2 terminal keeps its prior 2.999983 mil gap; all other new geometry meets the native 3 mil threshold. The CSI_D2_P 16/8 mil via at U1-B17 requires fill and cap acceptance.

The earlier native SD2_CMD push repair in batch 402 moves two inherited vias by 1.937248 and 0.234596 mil. Three Top SD2_DATA1 segments retain their inherited 3 mil width; the minimum gap is 2.99993849 mil. These known findings remain for final width and DRC review.

Batch 408's C21 interactive attempt produced no connection gain and was undone. Exact inventory proves full restoration before batch 409. Do not repeat the unchanged C21 attempt.

Checkpoint 055 was saved at 2026-10-01T14:39:07.579000+00:00; PCB SHA-256 `21410e97211d6952e39bcd0731e64a0716cbd6971f92873d34c0465405b39ed1`. All 103 project files were copied and hash-verified. Error markers were reset before saving. The saved PCB has not been reopened. Included DRC reports predate this PCB; final DRC is deferred until routing ends. Electrical and fabrication acceptance remain pending.

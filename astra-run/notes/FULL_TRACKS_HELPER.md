# Explicit track edits and additions

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

[FullTracks.PrjScr](../scripts/FullTracks.PrjScr) exposes
`ApplyExplicitFullTracks`. It reads at most 64 explicitly supplied track rows
and operates only when the active PCB matches this location under `astra-run/`:

```text
work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc
```

The maintained helper resolves that location from its loaded script project;
see [current path setup](../scripts/README.md#paths-in-this-checkout). The `runs/`
paths below use the same `astra-run/` base.

An `edit` changes the four endpoint coordinates of one exact existing track.
It preserves that track's net, width, and layer. An `add` creates one explicit
segment on an existing named net. The helper does not find a route, choose
geometry, change rules or component placement, delete objects, save, repour,
change selection, redraw, show dialogs, or invoke editor process commands.
No DRC or connection-completion claim follows from successful readback.

## Count checks

The controller must be the only board writer. Preflight measures the initial
native count and caches each existing track's properties for request checks.
Each write has an exact native geometry readback. After all rows, one native
scan verifies the final count and every changed track is read again. A fresh
whole-board inventory must still match the complete request before acceptance.

Batch 206 qualifies the final-count scan with ten additions in 14.261 seconds
and cached preflight with thirteen additions in 17.497 seconds. The preceding
57-row request took 132.378 seconds with a count scan after every row. Exact
whole-board comparison confirms all 80 additions and twelve vias. These are
observed batch times, including preflight; they are not a fixed throughput.

## Request

Create `track-changes.tsv` under the existing directory
`runs/full-routing-2026-09-30/quality/full-tracks/`. The header contains these
13 fields in this order, separated by literal tabs:

```text
action	net	old_x1_raw	old_y1_raw	old_x2_raw	old_y2_raw	new_x1_raw	new_y1_raw	new_x2_raw	new_y2_raw	width_raw	layer_id	expected_track_count
```

- `action` is exactly `edit` or `add`.
- `net` is an exact, nonempty, case-sensitive existing net name without
  surrounding space. No-net tracks are outside this helper's scope.
- For `edit`, the old unordered endpoints, net, width, and layer must match
  exactly one existing track. New endpoints must differ from the old geometry.
- For `add`, all four old coordinates must be `0`.
- All new coordinates and widths must be positive decimal integers. An edit's
  old coordinates must also be positive. Zero-length segments are rejected.
  Integers must be at most 2,147,483,647; count arithmetic must not overflow.
- `layer_id` is `1` for Top, `3` for the guarded board's L3_IN1 (legacy
  MidLayer2), or `32` for Bottom. L6 (`6`, legacy MidLayer5) additions are
  restricted to the 103 exact net names in `FullTracksL6Net`, with
  widths from 32,000 through 100,000 raw units. Native `ExportWidth229` reads
  those unchanged dominant-rule limits. L4 (`4`, legacy MidLayer3) additions
  permit only `VDD_ARM_0V9`, `VDD_SOC_0V8`, `VDD_DRAM&PU_0V9`, and `VDD_1V8`,
  within the unchanged POWER width rule: 30,000 through 1,000,000 raw units.
  Batch 243 reads back sixteen 20 mil L4 additions. Other layers and L4/L6 edits
  are rejected.
  A permitted layer does not establish impedance or reference continuity.
- Every row uses the same whole-board **legacy inventory** track count from
  before the batch. Native Board Information has a different object scope.
  Edits leave this count unchanged; each addition increases it by one.

Coordinates are absolute Altium raw units, not coordinates relative to the
user origin. The work board reports 10,000 units per mil. There are no comment
rows or optional columns. Several rows may use one net. A track can be edited
only one time per request.

Before any mutation, the helper parses every row, resolves every net and old
track, checks the initial track count, and rejects duplicate destination
segments on the same layer. It also rejects destinations whose complete
unordered endpoint pair already exists on that layer, even if the existing
segment has another width or net or will be edited later in the request.
It does not check crossings, partial overlaps, clearance, pads, vias, polygons,
keepouts, board edges, angle constraints, routing rules, or timing.

Each row rechecks the active board; an edit rechecks its exact old track
attributes before writing. A successful batch requires the expected final
count and exact unordered destination endpoints, width, layer, and net for
every changed track. Request order is execution order; choose an order with
a recoverable intermediate state.

## Audit and recovery

`full-tracks-request.tsv` snapshots the loaded input. `full-tracks-status.txt`
records the last stage, row, expected board path, and number of completed
readbacks. `full-tracks-audit.tsv` records one row per planned operation after
preflight, then replaces each row with actual readbacks as it completes.
Pending rows contain requested destination geometry, not measured changes.
`batch_before_track_count` records the measured initial total for every row.
`batch_after_track_count` stays empty until the final native count succeeds;
then every row records that measured final total. Per-row counts are not
measured. A property-readback status with a pending batch count is incomplete.

Require a fresh `applied_batch_readback_ok_drc_not_checked` terminal status and
the full expected completed-row count. Rows marked
`applying_inspect_on_interruption` can have changed even if the completed count
has not increased. Refusals occur before any track change and leave an empty
audit table. An exception after the first write can leave a partially applied
batch. Parse errors can occur before new files exist. Preserve previous
outputs before every invocation and check timestamps; an old success is not
a new result. The output directory must exist and be writable.

Every row has a separate `PreProcess`/`PostProcess` pair. Existing-track edits
send `PCBM_BeginModify`, set the four endpoints, and send `PCBM_EndModify` in
`finally`; the outer `finally` calls `PostProcess`. These notification calls
follow Altium's documented object-edit/Undo pattern:
[PCB API system interfaces](https://www.altium.com/documentation/altium-dxp-developer/pcb-api-system-interfaces-reference)
and [message constants](https://www.altium.com/documentation/altium-dxp-developer/pcb-api-constants-reference?version=4).
The native qualification evidence below covers this edit path in AD26.

Additions reuse `TrialVia.ConnectTrialLedViaToPad`'s qualified track factory,
property assignments, `AddPCBObject`, and `PCBM_BoardRegisteration` sequence.
Only explicit input values differ. Native qualification confirms that one Undo
reverts the latest row rather than every row. No automatic rollback
or removal occurs. On failure, stop and inspect the current row as well as all
completed rows. Restore with qualified native Undo or the saved checkpoint,
then compare exact geometry before another attempt.

## Controller qualification

1. Preserve the saved board and a completed current inventory. Use the exact
   active work PCB, open `FullTracks.PrjScr`, and select
   `ApplyExplicitFullTracks` through File > Run Script.
2. Check refusal with a valid planned first row and a deliberately invalid last
   row. Verify no prefix changed. Check stale count, duplicate old target,
   duplicate destination, and a nonexistent exact old geometry separately.
3. Qualify one bounded endpoint edit. Verify exact before/after inventory,
   native display and DRC, then native Undo back to the exact before state and
   Redo back to the intended edit. Qualify additions separately if needed.
4. Qualify a small multi-row batch and record actual Undo behavior before using
   a larger request. Compare unchanged pad/via/rule/net-pin-count tables and
   the component placement baseline. Check native connectivity and DRC.
5. Archive request, status, audit, source hashes, inventory, and native evidence
   with the routing batch before the next run overwrites the helper outputs.

The inventory comparator reports endpoint edits as one removed old record and
one added new record. Its preserved-copper check intentionally flags these
removals. Reconcile every removed track against the explicit old request and
every added track against the new request; all unrequested geometry must
remain unchanged. Do not weaken the comparator or suppress inherited findings
to make an intentional edit appear to pass without review.

## DDR byte 1 repair context

The abbreviated `batches/` and `quality/` paths in the qualification record below
are within historical `astra-run/runs/full-routing-2026-09-30/`. Those intermediate
snapshots are not included in this package.

`batches/002-ddra-byte1/attempt1-drc-comparison.json` has ten new clearance
findings across five new 4.1 mil CPU-end segments, at the original 3 mil fanout
transitions. The gaps are 2.574–2.795 mil against the unchanged 3 mil rule.
The affected nets are `DRAMA_DATA15`, `DRAMA_DATA8`, `DRAMA_DATA9`,
`DRAMA_DATA11`, and `DRAMA_DATA12`. The other ten added findings are changed
DDR matched-delay findings. The saved attempt has 2,916 legacy track objects.

The controller supplies independently checked coordinates to extend the five
3 mil fanouts and truncate the five 4.1 mil segments to the chosen transition.
No repair geometry is embedded in this helper and no executable request was
created during implementation. After repair, compare the exact ten edits and
rerun native DRC. Moving a transition does not resolve the separate matched
delay work. An inherited width finding can change its exact geometry identity
when its original 3 mil segment changes; inspect that delta explicitly.

## Native qualification evidence

The layer 3 allowance uses the same endpoint edit and track-addition paths.
`batches/018-boot-uart3-l3-repair/` qualifies this bounded path with source
SHA256 `cacfececf06dd2b0e04196cc61775fc87bf83b20233d4fe44e2009a2bdd45a79`.
An invalid seventh row on layer 4 caused no changes. One BOOT_MODE1 edit,
native Undo, and Redo each matched their exact expected inventories. The
complete seven-row request made two edits and five additions, ending at
3,450 tracks and 719 remaining connections with unchanged pads, vias, rules,
and net assignments. The temporary BOOT_MODE1 disconnection was restored.
Native DRC removed the three targeted clearance findings and three shorts
without adding a non-airwire finding. Independent evidence is in
`quality/batch018-final-reconciliation.json`,
`quality/batch018-terminal-audit-review.json`, and
`quality/batch018-drc-review.json`. This does not establish layer impedance,
reference continuity, timing, arbitrary geometry, or whole-batch Undo.

The full-run tests used `FullTracks.pas` SHA256
`e0cc577aa64cd4bd4de79d5bc0bf0c7771f3dc94c1982e2eabb946db2948e5d3`.
Saved evidence under `runs/full-routing-2026-09-30/quality/full-tracks/`
and `batches/004-ddr-cpu-approaches/` establishes these results:

| Check | Exact inventory result |
|---|---|
| Invalid final request row | No track, pad, via, rule, or net-membership change |
| One DATA8 endpoint edit | One authorized replacement; 2,939 tracks; Undo restores the before geometry and Redo restores the edit |
| Two edits and one addition | Exactly the three requested changes; 2,940 tracks |
| Small-batch Undo/Redo | One Undo removes only the last 12.98 mil addition; Redo restores the exact three-row result |
| Remaining 25-row request | Exactly 21 edits and four additions; 2,944 tracks; other exported primitive and rule tables unchanged |

Independent full-multiset reconciliation is recorded in
`quality/cpu-approaches-review.json`. One Undo per row is the observed behavior;
there is no whole-batch rollback. This evidence does not qualify untested
refusal branches or arbitrary geometry.

The small-batch Undo left exported DATA8 remaining connections at zero despite
the removed connecting segment. Treat exported connection counts as cached
after scripted edits or Undo until native connectivity and Board Information
are reconciled. The CPU repair's native DRC removed 16 clearance findings and
one short, while seven longer 3 mil stubs replaced seven old width findings.
Those 42 mil of added undersized centerline remain pending width acceptance;
the unchanged total of 413 width findings is not acceptance.

The separate `FullVia` guard evidence in
`quality/full-via/qualification-invalid-last/` refuses an unknown net in row 2
with zero completed readbacks. A fresh inventory shows no changes to the
2,944 tracks, 372 vias, pads, rules, or net membership. This qualifies that
preflight refusal only. Via creation and Undo/Redo require their own evidence;
the FullTracks results do not qualify the FullVia mutation path.

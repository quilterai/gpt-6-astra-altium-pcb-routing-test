# Explicit track width edits

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

[FullTrackWidths.PrjScr](../scripts/FullTrackWidths.PrjScr) exposes
`ApplyExplicitFullTrackWidths`. It changes only the `Width` property of up to
16 exact existing tracks on the full-routing work PCB. The project has no
automatic entry point. Its full path
guard rejects any other active PCB.

This helper reuses the qualified FullTracks numeric parser, iterator scope,
modify notifications, and per-row `PreProcess`/`PostProcess` sequence. This
companion itself has not been run in Altium. It creates no tracks, changes no
endpoints, layers, nets, components, or rules, and invokes no UI, process, or
board save command. It does not evaluate DRC, impedance, connectivity, or
whether a narrower or wider width is appropriate.

## Request and output

From `astra-run/`, create the runtime output directory
`runs/full-routing-2026-09-30/quality/full-track-widths/` before running the
entry point. Save `track-widths.tsv` there with this exact nine-column header
and one to 16 data rows, separated by literal tabs:

```text
net	x1_raw	y1_raw	x2_raw	y2_raw	old_width_raw	new_width_raw	layer_id	expected_track_count
```

Use exact existing net names and positive raw integer coordinates and widths.
There are 10,000 raw units per mil. `layer_id` is 1 for Top or 32 for Bottom.
The endpoints may be in either direction. The old and new widths must differ.
All rows must declare the same current legacy-inventory track count. No rows
are skipped, and all rows are validated before the first board mutation.

Validation rejects malformed numbers, duplicate requested endpoint geometry
on the same layer, unknown or duplicate net definitions, stale counts, an old
track that does not resolve uniquely, and an existing track of the requested
new width at the same endpoints/layer. The last check ignores net names to
avoid producing an exact overlapping segment on a different net. It is not
a general clearance or overlap test.

The helper saves `full-track-widths-request.tsv`,
`full-track-widths-audit.tsv`, and `full-track-widths-status.txt` in the same
directory. Preserve those files with the before/after inventories before a
later invocation overwrites them. Audit rows record requested old/new widths,
actual readback width, endpoint geometry, net, layer, and before/after track
counts. A terminal success status is
`applied_batch_readback_ok_drc_not_checked` with every row counted as completed.
Wait for that terminal status before other native commands.

## Qualification and recovery

The controller should qualify a wrong-board or invalid-final-row refusal,
then one explicit width edit on a backed-up candidate. Preserve and compare
complete native inventories. Every requested old track occurrence must be
replaced by exactly its new-width occurrence; all other tracks, pads, vias,
rules, net membership, and component placement must remain unchanged. The
ordinary comparator will report the edited old track as modified; inspect the
exact authorized replacement rather than suppressing its warning.

Exercise native Undo and Redo and compare exact geometry each time. The
qualified FullTracks pattern created one Undo operation per row, so expect
one Undo to revert only the most recent width edit. Verify this companion's
behavior rather than assuming whole-batch rollback. If a runtime error,
interruption, or readback failure occurs, earlier rows may remain applied and
the current row may have changed. Inspect the saved audit and fresh native
inventory before deciding how many Undo steps to use. Never automatically
re-run the same request after a partial result.

Native DRC and saved/reopened evidence remain separate acceptance steps.
Scripted edits and Undo can leave the exported connection counts stale. An
unchanged finding count does not make new below-minimum copper acceptable.

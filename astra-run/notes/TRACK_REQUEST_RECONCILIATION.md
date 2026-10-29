# Explicit track request reconciliation

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

[reconcile_tracks.py](../scripts/reconcile_tracks.py) independently checks a
`FullTracks` request against complete saved native inventories. It does not call Altium or change
any input. It leaves `compare_routing.py` and its preserved-copper checks intact.

From `astra-run/`, load the isolated tools with `. .\quickstart\enter.ps1`. Use the
immutable inventory immediately before the request, the exact archived
`track-changes.tsv`, and the completed inventory immediately after the request:

```powershell
uv run --locked --project .\quickstart python .\scripts\reconcile_tracks.py `
    $AstraBefore $AstraRequest --after $AstraAfter `
    --expected-board $AstraExpectedBoard `
    --output $AstraNewResult
```

The three input variables identify existing saved inputs. Set `AstraExpectedBoard`
to the exact full Windows PCB path recorded in both inventories; a relative
`work\...` path is rejected. `AstraNewResult` must be a new JSON file.
Existing outputs are never overwritten. Omit `--after` for preflight only.
That mode explicitly records `post_edit_verified: false` and
cannot establish an applied result.

The helper parses the exact 13-column `FullTracks` schema and its 1–64 row
limit, validates integer syntax, positive nondegenerate geometry, Top (`1`),
L3_IN1 (`3`), or Bottom (`32`) layers, unchanged widths/layers/nets for edits,
and the common pre-batch count. Other layers are rejected. Layer 3 request
acceptance does not establish impedance, reference continuity, or timing;
native helper qualification is recorded in
[FULL_TRACKS_HELPER.md](FULL_TRACKS_HELPER.md).
It requires each old target to occur exactly one time, rejects repeated old
targets, and rejects repeated or already occupied complete destination segments.
All net names are exact and case-sensitive. The existing inventory reader
checks completion, board identity, required fields, declared counts, and stable
source file metadata.

The expected after-state is the **entire** before track multiset, minus each
edited old record, plus every requested new record. The actual after-state must
match it exactly, including duplicate counts. Endpoint direction and selection
are ignored. Track identity uses net, integer raw coordinates, width, and layer
ID; layer display labels do not define geometry. A count-preserving unintended
edit, unrelated deletion, or duplicate addition fails this comparison.

Pads, vias, rules, net pin counts, coordinate units, and board origin must also
remain unchanged. Increased remaining edges or changes outside request nets
fail the result. The base export still does not contain component objects,
arcs, polygons, keepouts, or full pad stacks; compare the separate placement
baseline and use native checks for those surfaces.

- Exit 0: preflight passed, or the complete after-state matches the request and
  the checked invariants. Read `mode` and `post_edit_verified` to distinguish them.
- Exit 1: completed after comparison found unrequested changes or a checked
  invariant failure. The JSON details the differences.
- Exit 2: malformed/stale request, missing/invalid inventory, wrong board,
  changing input, or output error. The diagnostic appears on stderr.

JSON includes exact input SHA256 values, requested old/new records, and all
unexpected records. `ordinary_comparator_regressions` retains the ordinary
comparator's output. An intended endpoint edit can therefore be request-compliant
while still reporting a removed/modified baseline track. This is an explanation
of a deliberate change, not suppression of the original flag.

Request compliance does not prove physical copper preservation, clearance,
connectivity, return paths, timing, or electrical acceptance. Preserve and run
the ordinary inventory/DRC comparison independently. For a single qualification
edit, supply its one-row request and the matching before/after exports; do not
use the larger planned batch request.

Run the focused checks with:

```powershell
uv run --locked --project .\quickstart python -m unittest discover `
    -s .\scripts -p 'test_reconcile_tracks.py' -v
```

The tests cover reversed endpoints, duplicates, count-preserving unintended
changes, ambiguous original targets, stale counts, repeated edits, net-name
case, unchanged-count placement changes, and invalid final request rows.

Read-only validation on 2026-09-30 passed all six tests and reconciled the
controller's saved single `DRAMA_DATA8` endpoint edit against the 2,939-track
batch 003 inventory. The entire after multiset matched the one-row request,
with no other checked changes; the ordinary baseline-track-modified flag
remained visible. Evidence is the omitted historical file
`astra-run/runs/full-routing-2026-09-30/quality/single-edit-reconciliation.json`.
The 20-row electrical candidate also passed preflight against its original
2,916-track inventory, with 15 edits and five additions. That candidate's
pre-count must be refreshed before use against a later board state.

# Altium control reference

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

Research date: 2026-09-30. Installed version recorded by the workstation:
Altium Designer 26.10.1.

| Need | Read |
|---|---|
| Find a pad, net, layer, or useful view | [Views and selection](VIEWS.md) |
| Choose and operate a routing tool | [Routing](ROUTING.md) |
| Validate connectivity or invoke native reports from scripts | [Scripting and native reports](SCRIPTING.md) |
| Reproduce the successful first connection | [Routing control trial](../ROUTING_TRIAL.md) |
| Resume this workstation safely | [Runbook](../../RUNBOOK.md), [current status](../STATUS.md) |

## Evidence levels

- **VM verified:** observations recorded in the local routing trial. The first
  saved connection is D1-A to R125-2 on `NetD1_A`; it survived reopening. This
  establishes one connection, not a larger routing qualification.
- **Documented:** behavior in current official Altium documentation. Menu
  availability, installed extensions, shortcuts, and settings still require
  checks in this VM. The documentation is no longer versioned, so a current
  article does not establish behavior in this exact installation.
  [Altium documentation policy](https://www.altium.com/documentation/altium-designer/pcb/object-layer-transparency)
- **Trial guidance:** proposed experiments and measurement methods. These are
  not completed work or measured results.

## Working method

1. Use a disposable project for the larger trial. Preserve the original input
   and the untouched work copy for the full run.
2. Learn navigation and selection before running a batch operation. Verify the
   active layer, net identity, and selected connection count.
3. Try a few single connections, then a small multi-route group and ActiveRoute
   on suitable signal connections. Situs and all Auto Route scopes are prohibited
   through both the UI and scripts; see [routing tool limits](ROUTING.md#routing-tool-limits).
4. Record completed endpoint connections, including several across the board.
   Fifty track segments do not establish fifty completed connections.
5. Save, reopen, inspect, and check connectivity and design-rule results before
   accepting a checkpoint. Record failed attempts as well as successful ones.

Only the main controller operates the desktop. Add dated VM observations under
the relevant verified section after examining evidence; keep documented
procedures and trial results separate.

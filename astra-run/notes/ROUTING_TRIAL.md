# Routing control trial

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

Verified on 2026-09-29 and 2026-09-30 in Altium Designer 26.10.1.
Runtime paths below are relative to `astra-run/`; this trial project and its
screenshots are not included in this package.

## Project and result

The disposable project is
`trials/routing-smoke-2026-09-29/QCMI_SOM8MM/QCMI_SOM8MM.PrjPcb`.
It contains a complete copy of the input directory. The original input and
`work/QCMI_SOM8MM/` still match all 27 initial file hashes. Only the
trial PCB differs among the 27 copied files; Altium also created local history.

Routed `NetD1_A` from LED D1 pad A to R125 pad 2 in the STATUS area on `L1_PS`.
The width shown by Altium is 4.1 mil. The selected horizontal segment is
59.01 mil, from (1630.82, 1766.27) to (1689.83, 1766.27) mil. The Properties
panel reports total net length 59.547 mil; the routing HUD reports 59.760 mil.
These are observed Altium values, not an independently computed measurement.

Saved the PCB, closed its document tab, reopened it from the project, and
selected the persisted trace. The Properties panel confirmed `NetD1_A`,
`L1_PS`, the width, and segment endpoints. The PCB document's Explore command
opened the trial directory. The saved PCB SHA-256 is:

```text
1da260dc2c314f2f5448367ace49b5a8495887c70f95c054064dc4482a131d3b
```

The original image evidence was stored in `runs/routing-smoke-2026-09-29/`:

- `before-route.png`: initial routing view.
- `input-lag-no-net.png`: incorrect first attempt, undone before the saved result.
- `reopened-trace.png`: persisted trace and Properties panel.

This trial establishes basic interactive routing, undo, save, and reopen. It
does not establish full-board DRC, electrical correctness, timing closure,
high-density routing throughput, or completion criteria. The tested width came
from the active router setting; it is not a new design requirement. Start the
full run from a fresh copy of the preserved input after the routing plan is set.

## Control findings

1. Use the installed computer-use plugin. The PCB canvas had weak accessibility
   output; screenshots provided the geometry and net labels.
2. Separate pointer movement from clicking. In the initial trial, a separate
   pointer-move operation followed by a screenshot let Altium update its internal
   canvas cursor. Then click
   and inspect the selected net or preview. The first attempt combined movement
   and clicking and produced `No Net` geometry at the previous cursor location.
   Edit > Undo removed that geometry before the successful attempt.
3. Start Interactive Routing with `Ctrl+W` from the PCB canvas. Check the
   Properties panel's net and layer after choosing the start pad. Move to the
   endpoint, inspect the preview, then click. Cancel the routing command after
   completion and save only the trial project.
4. A single click on a track selected it and showed Properties. A double-click
   at an overlapping object opened a selection popup, so it added unnecessary
   UI state for this check.
5. `Page_Up` and `Page_Down` zoom about the cursor. Normal wheel input pans.
   Restoring a minimized window sometimes produced a small window; maximize
   the observed window and refresh before acting.

Altium's [interactive routing documentation](https://www.altium.com/documentation/altium-designer/pcb/routing/interactive)
provides background. The observations above describe this installed instance.

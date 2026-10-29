# Routing tools and trial measurements

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

## Routing tool limits

Use **Interactive Routing**, **Interactive Multi-Routing**, and **ActiveRoute**.
Situs and every built-in **Route > Auto Route** command are prohibited in trials
and the full run, through either the UI or scripts. This includes connection,
net, net-class, component, area, and whole-board scopes. Do not invoke
`PCB:Autoroute` or another process call to run these prohibited commands.

Aim for human-quality routes with deliberate paths, clean pad entries, and rule
compliance. Completed connection counts alone do not establish acceptable quality.

## VM verified

`Ctrl+W` starts Interactive Routing from the idle PCB canvas. A saved connection
from D1-A to R125-2 on `NetD1_A`, layer `L1_PS`, survived reopening. The observed
width was 4.1 mil; this is evidence of the active setting, not an approved
width for other nets. Follow the current pointer/crosshair cautions in
[VIEWS.md](VIEWS.md); the earlier move-then-click recipe later failed during
active routing. See [initial trial evidence](../ROUTING_TRIAL.md).

At the **2026-09-30 04:16:56 UTC** checkpoint, ActiveRoute is installed and has
completed selected `L1_PS` PMIC groups, short Bottom connections, and long
Bottom `USB1_ID`/`USB2_ID` routes. After removing a bad PMIC_NINT segment,
18 distinct nets remain newly complete, plus partial USB1_VBUS and PMIC_NINT
routes. Final native DRC has 4,300 findings and no added clearance, short-circuit,
or width findings. Native Board Information and reopened inventory agree on
837 remaining connections versus baseline 857; 272 of 1,109 total connections
are routed. The reopened export has 2,909 legacy-scope tracks and 373 vias.
The first PMIC group used Gloss Results with pin swapping and tuning disabled. The
approximately 50-connection target was not achieved.
See [the trial record](../ROUTING_50_TRIAL.md).

A UART Bottom attempt produced poor detours and was undone with exact exported
geometry restoration. Top-only I2C1 and the isolated LED via with Top/Bottom
enabled produced no new tracks. ActiveRoute does not create the layer access
that those groups need. Deselecting a group is not evidence of completed routes.

Main-window **File > Save** wrote the PCB when `Ctrl+S` did nothing with a
floating panel focused. Verify the intended document and its disk timestamp
and hash; a successful input call is not save evidence.

Source-pad selection passed on D1-C, and the export/net-selection/selected-zoom
wrapper passed on a UART2/4 group. Neither establishes a completed multi-route.
Interactive Multi-Routing remains unqualified. One explicit `NetD1_C` through-via
add passed readback and Undo restored exact exported geometry before Redo.
The 50 mil Top via-to-pad stub was added, but its first readback guard rejected
Altium's reversed endpoint order; the corrected guard is not rerun. Neither
operation alone establishes a rule-clean layer transition. Subsequent Bottom
ActiveRoute completed `NetD1_C` in the 04:04:39 export. Final DRC confirms the
via's added shorts resolved after polygon repour; the saved PCB passed
close/reopen and complete export at 04:16:56 UTC. The corrected helper guard
itself remains untried; independent export and native reports established the
retained geometry.
The following sections describe documented procedures beyond these measured
results. Read [the scripts' qualification limits](../../scripts/README.md).

## Documented: interactive routing

Use **Route > Interactive Routing**, start on the intended net object, and guide
the preview. `Ctrl+click` attempts completion toward the target. Existing width,
clearance, layer, and via constraints govern the route.
[Interactive routing](https://www.altium.com/documentation/altium-designer/pcb/routing/interactive)

| While routing | Function |
|---|---|
| Click or `Enter` | Commit the preview |
| `Esc` | End the route; committed copper remains |
| `Backspace` | Remove the last committed portion |
| `Tab` | Pause for Properties |
| `Shift+R` | Cycle enabled obstacle-handling modes |
| Space / `Shift+Space` | Corner direction / corner style |
| `Shift+W` / `Shift+V` | Favorite width / via size |
| `Ctrl+W` | Toggle clearance boundaries |
| `Shift+F1` | Show commands available in the current mode |

`Ctrl+W` starts routing only when idle. The current interactive article lists a
different launch key; the shortcut table and VM trial agree on `Ctrl+W`.
[PCB shortcut reference](https://www.altium.com/documentation/altium-designer/shortcut-keys/pcb-editors)

## Documented: interactive multi-routing

1. Select source pads before **Route > Interactive Multi-Routing**:
   `Shift+click` individual pads, or `Ctrl+drag` a pad region.
2. Click where the first group of segments should finish, then guide the group
   toward its destinations.
3. `B` reduces bus spacing; `Shift+B` increases it. `C` applies rule spacing.
   `Tab` opens the multi-routing properties.
4. Changing **Layer** in those properties adds vias. Check the applicable via
   settings before committing a layer change.

This is a guided group operation. Inspect each endpoint; a completed-looking
group of segments does not establish completed connections.
[Multi-routing section](https://www.altium.com/documentation/altium-designer/pcb/routing/interactive)

## Documented: ActiveRoute

Requires the **ActiveRoute** extension. Open **View > Panels > PCB ActiveRoute**.
Select connection lines with `Alt+click` or `Alt+drag`; dragging left includes
touched lines, while dragging right requires enclosure. Selecting pads can
include additional connections in their nets, so inspect the selection count.

Enable the intended signal layers, then **Route > ActiveRoute** or `Shift+A`.
The Messages panel reports completion. ActiveRoute distributes connections
among enabled layers but adds no vias. Existing fanouts must provide access to
those layers. It ignores power-plane nets and nets containing more than 20 pins.

An optional **Route Guide** constrains the path: select connections, choose
**Route Guide**, click its path, right-click to finish, then run ActiveRoute.
Up/Down adjusts guide width during placement. Keep its ends away from pads.
Connections use the preferred rule width; starting from existing tracks can
use their width. Glossing runs afterward when enabled. Existing fanouts can be
locked to preserve them.
[ActiveRoute](https://www.altium.com/documentation/altium-designer/pcb/routing/activeroute)

Trial guidance: start with a small signal group and known fanout access. Keep
pin swapping disabled unless the design plan explicitly allows it. Do not treat
automatic length tuning as proof that timing requirements are satisfied.

## Trial guidance: reach about 50 completed connections

Use successive batches on a disposable project. First qualify a few single
connections, then a group of adjacent signals, then several longer connections
between separated board regions. Compare the tools above on suitable remaining
connections. Save a checkpoint before each routing batch so a poor result can
be restored without depending on a long undo history.

Assess routing speed and quality early. The setup trial's pace is inadequate
for the full-board run. When ActiveRoute produces poor paths or no useful
progress, switch to guided Interactive Routing or Interactive Multi-Routing
to find a deliberate path. Qualify a small multi-route before expanding it.
Use live DRC during routing; run native batch DRC at meaningful checkpoints,
final acceptance, or for a diagnosed issue, not after every small edit.
Improve controls, scripts, and notes when a measured obstacle requires it.
Keep the experiment small, record what actually passed, and return to routing.

For every batch, record:

| Field | Evidence |
|---|---|
| Scope | Exact nets and endpoint pad pairs, tool, layers, settings |
| Before | Remaining connection count, source checkpoint, existing violations |
| After | Remaining connection count, new completed endpoint pairs, unresolved endpoints |
| Quality | New shorts, clearance/width/via issues, topology and timing limits |
| Persistence | Saved path, reopen result, report and screenshot paths |

Count unique newly completed connections. A segment count, a selected-object
count, and a completed-net count are different quantities. With unchanged net
membership and preserved existing routing, compare remaining connection counts
before and after; retain endpoint evidence for the intended subset. If only a
net-level count is available, report that limitation instead of relabeling it.

## Documented: connectivity checks

Use **Reports > Board Information**, enable **Routing Information**, and generate
the report. **PCB Filter > IsConnection** exposes remaining airwires. In **Tools
> Design Rule Check > Rules To Check**, enable **Batch** for **Un-Routed Net**,
then run the check; this rule is not an online check. Record exact report labels
and numbers, together with relevant clearance and short-circuit results.
[Altium connectivity-check guidance](https://www.altium.com/documentation/knowledge-base/altium-designer/drc-not-catching-unconnected-nets)

**Reports > Netlist Status** adds per-net routing layers and length. These
lengths support inspection but are not completion counts; the PCB panel's
**Signal Length** and **Unrouted (Manhattan)** fields have distinct meanings.
[Net reports](https://www.altium.com/documentation/altium-designer/pcb/understanding-connectivity)

Accept a trial checkpoint after save/reopen and connectivity inspection. Keep
unverified high-speed topology, impedance, length matching, and fabrication
requirements explicit; completing 50 connections is a control qualification,
not whole-board sign-off.

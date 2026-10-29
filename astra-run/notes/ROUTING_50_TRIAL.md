# Routing tool trial

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

Checkpoint recorded: **2026-09-30, 04:16:56 UTC**. The saved and reopened trial
retains 18 newly complete nets and partial `USB1_VBUS` and `PMIC_NINT` routes.
Native DRC has no added clearance, short-circuit, or width findings. Native
Board Information and reopened inventory agree on **837 remaining connections**,
20 fewer than baseline. The approximately 50-connection target was **not**
achieved, and the full-board run has not started. Historical counts below name
their specific checkpoints; the final result has the residual defects recorded
under repair and final DRC.

## Allowed routing tools

Situs and every built-in **Route > Auto Route** command are prohibited,
including subset, connection, net, net-class, component, area, and whole-board
routing. The prohibition applies to both UI and script invocations. No Situs
routing has been performed.

Use **Interactive Routing**, **Interactive Multi-Routing**, and **ActiveRoute**
to aim for human-quality routes: deliberate paths, clean pad entries, and rule
compliance. Exact selection and inspection scripts may support these tools.
Completion counts alone are not a quality check. These limits also apply to
the later full run; see [the runbook](../RUNBOOK.md#routing-tool-limits).

## Project and baseline

Runtime paths below are relative to `astra-run/` and identify the original
trial workspace.

- Project: `trials/routing-50-2026-09-30/QCMI_SOM8MM/`.
- Input and initial trial PCB SHA-256:
  `2669fca73471169e5c4cf80b3dcd25790dd246219bd2cbc23c6c1044637d6f2b`.
- All 27 original manifest entries matched before opening the fresh copy.
  A later generated `.PrjPcbStructure` file is outside the original manifest.
- The live `TrialProbe` script confirmed the full trial PCB path.
- The complete inventory is preserved locally under
  `runs/routing-50-2026-09-30/baseline/`. Later exports replace
  `runs/current-inspection/`, not this baseline.

| Live API inventory | Count |
|---|---:|
| Nets | 321 |
| Pads | 1,593 |
| Track segments in legacy iterator layer scope | 2,825 |
| Vias | 372 |
| Nonredundant ratsnest connection objects | 857 |
| Rules | 78 |
| Nets with `ConnectivelyInvalid = true` | 321 |

Native Board Information at 01:53 UTC confirmed 1,109 total connections,
252 routed, and **857 remaining**. Batch DRC at 02:03 UTC reported 869 unrouted
findings, including exactly 12 pieces of unassigned dead copper. The remaining
857 findings agree with the connection count. A track segment is not a completed
connection; the inventory does not rebuild connectivity.

Native Board Information counted 8,315 tracks across all layers, including
1,109 copper tracks. The script's 2,825-track total omits extended mechanical
layers through its legacy `AllLayers` filter; its copper count agrees.

### Native baseline DRC

The check completed in four seconds with 0 warnings and 4,320 rule violations.
The report limit was 100,000; default batch checks included Clearance,
Short-Circuit, Un-Routed Net, and Width. Existing findings include:

| Category | Count |
|---|---:|
| Clearance | 911 |
| Short-Circuit | 3 |
| Un-Routed Net, including unassigned copper | 869 |
| Width | 413 |
| Minimum Solder Mask Sliver | 1,363 |
| Silk To Solder Mask | 475 |
| Silk To Silk | 34 |
| Net Antennae | 165 |

Other findings concern hole size, board clearance, length matching, and rooms.
The three shorts involve U1-M2, U1-N2, and U4-K5 with existing unassigned tracks.
These are baseline defects, not trial additions. The `.drc` and `.html` reports
are preserved under the baseline directory as `design-rule-check.*`; Board
Information is `board-information.*`. DRC marked the live PCB/project modified;
the saved PCB still matched the original hash afterward.

The export confirms routing-layer rules enable all eight copper layers. It also
contains impedance, differential-pair, and matched-delay rules. This does not
resolve the discrepancy between the supplied stackup CSV and the PCB's layer
names, or prove that the constraints are complete.

## Script qualification

`TrialProbe` completed. The first inventory stopped at `StringReplace` in
`InventoryField`; replacing it with an indexed-character loop completed the
export. `GetCurrentPCBBoard` returned nil with the script editor active.
`GetPCBBoardByPath` found the exact open trial and allowed F9 to complete from
the script editor. Successful export writes `complete` without a modal dialog.

At 02:09 UTC, `SelectAllowlistedNets` selected `NetD1_A` and `NetD1_C` in the
live trial: exactly six primitives, comprising four pads and two connections.
This verifies selection for those nets; it adds no copper and completes no
connections. At 02:58:49 UTC, `SelectAllowlistedSourcePads` selected and audited
exactly D1-C on `NetD1_C`, with no geometry change. Multi-routing and the source
selector's rejection paths are not qualified by that one-pad success.

After the 03:24:12 UTC inventory, `ExportAndSelectAllowlistedNets` passed its live
sequence:
complete export, strict allowlisted net selection, then selected-object zoom.
The UART2/4 group appeared in the selected view. Its final call is
`Client.SendMessage('PCB:Zoom', 'Action=Selected', 255, Client.CurrentView)`.
The installed `C:\Program Files\Altium\AD26\System\AdvPcb.rcs:189` defines
`PCB:Zoom`, `Action= Selected`, as **Fit Selected Objects**. The wrapper changes
selection and view, not geometry, rules, or the saved PCB. Its exported selection
state precedes the new selection; require fresh complete output and inspect
the subsequent selection separately. See [scripts](../scripts/README.md).

## Batch 1: short manual connection

Interactive Routing completed `NetD1_A` from D1-A to R125-2 on `L1_PS`.
The two added segments use 4.1 mil width and total about 59.76 mil (1.52 mm).
No vias were added. Save completed at the exact trial path. The complete
inventory then reported 856 remaining connections, no `NetD1_A` connection
object, 2,827 tracks in its layer scope, and 372 vias. `NetD1_C` was still open.

The saved PCB SHA-256 is
`2d6a59886ae9eba52729c9816d5fcf36fb9b1e72e153f2186fc148644c518ac7`.
The PCB-only snapshot and inventory are under
`runs/routing-50-2026-09-30/batch-01-manual/`. At that checkpoint, native
post-route DRC and reopen verification were pending. The inventory established
one added connection; the final checks are recorded below.

At that earlier point, `Shift+A` produced no visible result and the optional
ActiveRoute extension was absent. It was installed and Altium restarted before
the later batches below. That earlier observation does not describe current
extension availability.

## Batches 2–4: selected ActiveRoute groups

ActiveRoute completed small selected groups on one enabled surface layer at a
time. For the first PMIC group, **Gloss Results** was enabled and pin swapping
and tuning were disabled. No new vias were reported in these batches. The
aggregate count was 372 vias at batch 4; later experiments added one via.

| Batch | Layer | Exact newly completed nets | Export UTC | Saved PCB UTC |
|---|---|---|---|---|
| 2: PMIC controls | `L1_PS` only | `NetR51_2`, `NetR52_2`, `NetR48_2`, `NetR54_2` | 03:10; controller verification at 03:11 | 03:11:34 |
| 3: PMIC reset/control | `L1_PS` only | `NetR127_2`, `NetR114_1`, `NetR111_1`, `NetR146_2` | 03:20:51 | 03:23:23 |
| 4: short resistor/fanout | Bottom (L8) only | `NetR109_1`, `NetR108_1`, `TS_RES_EXT` | 03:24:12 | 03:23:23 |

Batch 2 evidence is under `runs/routing-50-2026-09-30/batch-02-activeroute-pmic/`.
The saved PCB containing all 12 new connections, including batch 1, and its
latest inventory are under
`runs/routing-50-2026-09-30/batch-04-short-bottom/after/`. Its SHA-256 is
`182670b9ba4250188d54ed8716e15939b3c3bc2d6bce88e8914b23848d7c59dd`.
The controller observed the export complete before preserving this snapshot.

The 03:24:12 inventory reports 845 nonredundant ratsnest connections, 2,864 track
segments in the legacy iterator scope, and 372 vias. All 12 named completed
nets have zero connection objects. Some earlier completed nets still carry
connectivity-invalid flags in this later export; those flags alone are not a
completion metric. Native post-route reports and reopen checks were pending
at that checkpoint; the final checks are recorded below.

With a floating panel focused, `Ctrl+S` did not update the PCB file. Main-window
**File > Save**, with the intended PCB document active, wrote the file; the
controller verified its disk modification time. Use the actual saved PCB path,
timestamp, and hash as persistence evidence. A visual route or selection/export
success does not establish a save.

These batches qualify selected ActiveRoute operations on Top and Bottom with
the existing layer access. They do not qualify Interactive Multi-Routing,
critical high-speed constraints, or final route quality.

## Batches 5–7 and rejected attempts

| Batch | Newly complete nets | Inventory UTC | Remaining | Vias |
|---|---|---|---:|---:|
| 5: long Bottom routes | `USB1_ID`, `USB2_ID` | 03:33:17 | 843 | 372 |
| 6: PMIC controls | `SD2_VSEL`, `WDOG_B`, `PMIC_NINT` | 03:42:17 | 840 | 372 |
| 7: USB VBUS | `USB2_VBUS`; one branch of `USB1_VBUS` remains | 03:53:24 | 838 | 373 |

Batch 5 was saved at 03:32:09 UTC. Its PCB and inventory are under
`runs/routing-50-2026-09-30/batch-05-usb-id/after/`. `USB1_ID` and `USB2_ID`
have zero connection objects and false connectivity-invalid flags, with routed
lengths of 15.87 mm and 17.80 mm including existing fanout. Batch 6 and batch 7
directories preserve complete inventories; those directories do not contain
separate saved PCB snapshots. `PMIC_STBY_REQ` still has one connection object.

The UART2/4 Bottom attempt produced partial completion, large detours, and
visible violations. Undo restored the exact batch 4 exported tracks and vias,
including 845 remaining connections and 372 vias. The rejected inventory is
under `rejected-uart-bottom/`. Top-only I2C1 produced zero track changes and
left four connection objects. GPIO10–12 were skipped without a routing attempt.
Neither selection changes nor a completed tool invocation establish progress.

Connector outer-row pitch is 15.75 mil and pad width is 8 mil, leaving 7.75 mil
between pads. A 4.1 mil trace with 3 mil clearance on each side requires 10.1 mil.
Those dimensions do not permit passage between pads on that surface; deliberate
layer access is needed before retrying those groups.

## Explicit via and stub qualification

`AddExplicitTrialVia` added one through-via on `NetD1_C`, taking 372 vias to 373,
at raw coordinates `(131936400, 99451500)`, with 16 mil diameter and 8 mil hole,
span 1–32. Readback passed. Edit Undo followed by export restored the exact
prior track and via geometry; Redo restored the added via. These checks qualify
the explicit add/Undo operation, not clearance or a completed layer transition.

The isolated via increased `NetD1_C` from one to two connection objects.
ActiveRoute with Top and Bottom enabled added no tracks and left both objects.
The explicit 50 mil, 4.1 mil Top via-to-pad stub then added one track
(2,905 to 2,906 in the legacy export scope), reduced the board inventory from
838 to 837, and left `NetD1_C` incomplete. Altium reversed the track endpoints
on readback, so the first helper reported failure despite adding geometry.
The corrected endpoint-order guard has not been rerun. See
[script qualification](../scripts/README.md) before invoking either helper.

## Final inspection before repair

The saved PCB at 03:57:52 UTC and native reports are preserved under
`runs/routing-50-2026-09-30/final-before-repair/`. The native DRC started at
03:58:46 UTC and completed in four seconds. This checkpoint is **unaccepted**:

| Native DRC category | Baseline | Before repair | Difference |
|---|---:|---:|---:|
| Total | 4,320 | 4,303 | -17 |
| Clearance | 911 | 915 | +4 |
| Short-Circuit | 3 | 5 | +2 |
| Un-Routed Net | 869 | 848 | -21 |
| Net Antennae | 165 | 162 | -3 |
| Board clearance | 4 | 5 | +1 |

Width, hole-size, mask, silk, matching, and room category counts were unchanged.
The lower total does not offset the added shorts or clearance defects. All 12
unassigned dead-copper report lines exactly match baseline. The 848 native
unrouted findings reconcile with the later complete export's 836 connection
objects plus those 12 findings; the earlier 837 export preceded LED completion.

The frozen batch 7 inventory confirms these 18 newly complete nets:
`NetD1_A`, `NetR108_1`, `NetR109_1`, `NetR111_1`, `NetR114_1`, `NetR127_2`,
`NetR146_2`, `NetR48_2`, `NetR51_2`, `NetR52_2`, `NetR54_2`, `PMIC_NINT`,
`SD2_VSEL`, `TS_RES_EXT`, `USB1_ID`, `USB2_ID`, `USB2_VBUS`, and `WDOG_B`.
Seventeen had one baseline connection object; `USB2_VBUS` had two. One of
`USB1_VBUS`'s two baseline objects also disappeared. Those are 20 original-net
edge reductions. The isolated LED via temporarily added an edge, later removed
by its stub; the stub does not constitute completion of `NetD1_C`.

After the stub, Bottom ActiveRoute completed the LED connection. The 04:04:39
export confirms 19 newly complete nets including `NetD1_C`, 836 remaining,
2,910 tracks in the legacy iterator scope, and 373 vias. This supersedes the
earlier 837 count as a live connectivity measurement, but not as final
acceptance. All polygons were repoured at 04:01 UTC. The controller then
started removing the specific PMIC_NINT segment that caused added clearance
errors; the repaired count must come from a later export.

The two new shorts and two clearance collisions in the before-repair report
involve the LED via and polygons on `L7_GND_3` and `L2_GND_1`. The other two
added clearances involve U1-AG13 and U1-AG14 versus one Top track. The added
board-clearance finding involves Top Overlay text `.ProjectNameShort`, not
copper. Report these categories independently; neither repour nor track removal
establishes a corrected DRC result until the native check finishes again.

This pre-repair state is not the accepted result.

## Repair and final DRC

The controller repoured all polygons and removed the exact PMIC_NINT segment
that caused the two new Top clearances. Removing that segment reopened
PMIC_NINT; the retained long track remains partial. The final native DRC started
at 04:12:08 UTC and wrote its report at 04:12:12 UTC.

| Native DRC category | Baseline | After repair | Difference |
|---|---:|---:|---:|
| Total | 4,320 | 4,300 | -20 |
| Clearance | 911 | 911 | 0 |
| Short-Circuit | 3 | 3 | 0 |
| Width | 413 | 413 | 0 |
| Un-Routed Net | 869 | 849 | -20 |
| Net Antennae | 165 | 164 | -1 |
| Board clearance | 4 | 5 | +1 |

There are no new clearance, short-circuit, or width findings compared with
baseline. The 12 unassigned dead-copper findings are unchanged, so the native
unrouted total reconciles as 837 remaining connections. Native Board Information
and reopened inventory both confirm that count. Residual added findings include the
incomplete PMIC_NINT connection, an antenna on its retained long track, and the
Top Overlay `.ProjectNameShort` board-edge collision. A smaller antenna total
does not erase that added antenna. Read [the exact DRC comparison](FINAL_DRC.md).

The retained complete-net list is the batch 7 list above with `PMIC_NINT`
removed and `NetD1_C` added: 18 newly complete nets. `USB2_VBUS` completed two
baseline edges and `USB1_VBUS` completed one of two; the net reduction is 20
endpoint connections, not 50. Do not label the result clean or
manufacturing-ready.

## Saved and reopened result

Native Board Information at **04:14:28 UTC** confirms 1,109 total connections,
272 routed, and 837 remaining. Baseline was 252 routed and 857 remaining. The
controller saved, closed, and reopened the trial PCB at 04:15–04:16 UTC.
`ExportTrialInventory` completed at **04:16:56 UTC** with 2,909 track segments
in the legacy iterator scope, 373 vias, and 837 nonredundant connection objects.
The reopened export's connectivity-invalid flags are not completion counts;
the native report and connection objects provide the measured comparison.

Final PCB SHA-256:
`cf8253b370543494b4f429fb7b368ae060b40e27bc1054c65916a7e33f0bd655`.
The original PCB SHA-256 remains unchanged:
`2669fca73471169e5c4cf80b3dcd25790dd246219bd2cbc23c6c1044637d6f2b`.
The selected result destination is
`results/setup-trial-2026-09-30/QCMI_SOM8MM/`, with sibling evidence.
The trial qualifies a limited set of controls and preserved connections, not
whole-board timing, signal integrity, fabrication readiness, or 50 connections.

## Routing pace and tool choice

The setup and trial did not meet the approximately 50-connection target. This
pace is inadequate for a full-board run. Evaluate routing speed and visual
quality in the first few useful batches, then change the method when progress
is poor. A poor ActiveRoute result should lead to guided Interactive Routing
or Interactive Multi-Routing pathfinding, not repeated failed batch attempts.
Interactive Multi-Routing remains a qualification gap in this trial.

Use live DRC while routing. Run native batch DRC at meaningful saved
checkpoints, final acceptance, or to diagnose a specific issue; do not run it
constantly or after every small edit. Keep exact net/endpoint and saved-file
evidence between checks. Preserve the baseline and compare added defects rather
than treating a lower total as a quality guarantee.

Continue improving tools and notes during routing. Each tool change should
answer a specific routing need, receive a bounded trial, and record measured
behavior and remaining limits in the nearest guide. Reuse qualified tools and
return to routing after the check; do not repeat this setup phase.

## Desktop interruption

Modal input repeatedly restored the main window to 129 by 77 logical pixels.
The tool sometimes showed an old large bitmap despite those small dimensions.
`Alt+Space`, then `x` in a separate call, restored a maximized view after the
modal closed. The recorder rejected small captures at 00:39, 00:44, and 00:51.
Restarting the monitors preserved the recording and produced a valid frame at
00:46:07 UTC.

At 00:51:21 UTC, the remote desktop session disconnected and Windows started
`LogonUI` in that session. Native control then failed to activate Altium, and
capture returned `IGraphicsCaptureItemInterop.CreateForMonitor failed`
(`0x80070057`). Altium remained running; an attempted close was not confirmed.
No board edits or layout changes occurred. Persistent console display and
automatic recovery subsequently passed the user's RDP scaling/disconnect test
at 01:34 UTC. The same Altium session retained a 3364 x 1924 display; a fresh
full-board WGC frame and native input passed. See
[desktop qualification](../quickstart/DESKTOP.md).

A process restart restored modal input at DPI 96. A clean shutdown then wrote
the live `UserTools.TLT`; its normal bounds and maximized state were repaired
with a backup at 01:55 UTC. Relaunch, configuration dialogs, Board Information,
DRC, and file-dialog input passed at 3364 x 1876 on the 3364 x 1924 monitor.
The restart changed both process and DPI state, so the old failure's exact
cause is not established. Capture and modal input after a future DPI transition
of this restarted process remain unqualified. See the
[qualified layout repair](altium/VIEWS.md).

## Remaining qualification

1. Use the qualified export/selection/zoom wrapper and inspect exact selected
   objects before each new routing operation.
2. Carry the residual PMIC_NINT and overlay findings into the handoff. Extend
   the demonstrated single-via method deliberately, and qualify a small
   Interactive Multi-Routing group before using it broadly.
3. Report the achieved subset honestly. The 50-connection target is incomplete.
   Preserve endpoint evidence and compare geometry and native reports against
   baseline; do not count segments or temporary via edges as completed routes.
4. Preserve a selected LFS checkpoint with its exact acceptance limits. Start
   the later full run from preserved input after a written routing plan that
   classifies every net, reviews DDR first, and resolves stackup/timing evidence.
   Use the existing setup rather than repeating it; the fresh prompt limits
   initial tool requalification to about 30 minutes.
5. After any future DPI transition, requalify this restarted Altium process's
   full window capture, native input, and modal behavior before continuing.

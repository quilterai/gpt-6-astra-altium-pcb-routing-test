# Decisions and experiments

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

## 2026-09-29: Native Windows workspace

Run the agent and Altium in one dedicated Windows VM. Local file and process
access simplify building and debugging control tools. Start with GPT-6 Astra at
Max effort; adjust only with evidence and record the change. A separate Linux
controller is not required for the initial experiment.

## 2026-09-29: Artifact storage

Keep working notes, tools, and selected saved checkpoints separate from raw
recordings, installed software, credentials, and disposable runtime files.
Preserve file hashes and original inputs. Current repository guidance governs
storage and publication; historical operating permissions do not transfer to a
new reproduction run.

## 2026-09-29: Bootstrap boundary

Install a pinned, workspace-local toolchain with an independent Python/Node
environment. Stop on failed downloads, checksums, native commands, and
dependency checks. Bootstrap prepares tools; desktop control, timelapse, messages,
and restart recovery are verified against the real instance before unattended use.

## 2026-09-29: Desktop control and setup layout

Use the installed computer-use plugin for Altium observation and input. It
captures the rendered board and operates project menus. Accessibility text is not consistently available for the PCB canvas;
use current screenshots where needed. A separate Python desktop controller is
not required. Add Altium scripts only for specific gaps established by use.

Keep setup scripts, dependency manifests, and installation references under
`astra-run/quickstart/`. The hidden tool and Python environment directories
remain local to the run workspace. Python
dependencies cover media processing; Node dependencies provide the optional CLI
and SDK used during the historical experiment.

## 2026-09-29: Complete project copy

Preserve `speedrun-input/` at the repository root and work in
`astra-run/work/QCMI_SOM8MM/`. Copy the whole directory: the project includes ten
schematic sheets, local libraries, variants, and output jobs; the directory also
contains timing and stackup references. All 27 copied files matched their source
SHA-256 hashes. All 18 project `DocumentPath` entries resolved inside the source
directory. The historical `input-manifest.json` recorded the initial contents.

The current phase covers exploration and setup. Placement permissions, routing
scope, authoritative constraints, validation criteria, and unattended recovery
belong to the routing plan. The file name alone does not establish design intent.

## 2026-09-30: Trial and monitoring

Keep the first routing experiment in a disposable project. Its saved LED
connection survived closing and reopening; [ROUTING_TRIAL.md](ROUTING_TRIAL.md)
records the geometry, control timing issue, evidence, and validation limits.
The full run starts from preserved input, without trial edits.

Run Altium-only capture independently with Pillow and FFmpeg. Keep monitoring
read-only and separate from desktop input. Track recorder liveness, capture
freshness, and agent status separately. Covered capture works; minimization
produces a reported gap and capture recovers after restoration. Qualify remote
session changes, agent continuation, and reboot recovery separately.

## 2026-09-30: Routing pace and layer access

The 06:28 review measured 23/321 whole nets connected and 272/1,109 routed
connections, only 20 more than the full-run baseline. Increase ordinary-net
batch size outside the reserved DDR area. Agents prepare exact via access and
local GND connections while the controller uses qualified native ActiveRoute.
Batches 006 and 007 then reduced remaining connections from 837 to 818. The
six northern controls in batch 008 produced no geometry change; investigate
their endpoint access rather than repeating the same pass.

FullVia passed invalid-final-row rejection and single-via native Undo/Redo with
exact inventories. FullTracks passed rejection, edit/add, and native Undo/Redo
checks. Reuse these helpers for explicit reviewed geometry. Their readback
does not replace native DRC, connectivity, or electrical acceptance.

Native Repour All removed eight signal-via contacts with cached L2/L7 GND
copper after batch 005. Repour after new through vias before judging shorts.
The first DRC reports processed 32 rule sections; enabling previously omitted
batch categories increased coverage to 41 without changing rule constraints.
Compare shared coverage separately from newly reported categories. The native
report, rather than an attempted checkbox menu action, establishes coverage.

## September 30, 21:39 UTC: completion and throughput

The primary dashboard metric counts routed connections out of the native
1,109 total. The 321 named nets are a different inventory measure. Batch 042
added 26 exact segments and completed 13 connections, reaching 677 routed and
432 remaining. Intermediate batch DRC is deferred until routing ends; exact
primitive readbacks, connection counts, preserved rules/placement, saves, and
bounded offline clearance checks remain in use. DDR timing tuning is deferred.

Five power/ground polygons in batches 036 and 039 gained 42 connections.
The geometry screen missed global Keep-Out layer 56 on the batch 033
ENET_RX_CTL access. Batch 041 moved that via and edited two leads; exact
comparison and native DRC confirmed both added physical findings removed.
The screen includes layer 56. The saved 21:27:30 board preserves that repair.

ActiveRoute failed on the 17-net access group and on one selected PDM_DATA0
airwire with only L3 enabled. Both attempts changed no primitives. The
connection-only selector removes mixed selection as a demonstrated cause;
no identical pass is planned. Explicit paths and dedicated power regions
provide the current connection gains.


## September 30, 23:03 UTC: VSYS region and partial-batch recovery

The exact L5 VSYS rectangle spans (25,205)–(995,645) mil. The qualified
FullPolygon whitelist accepts only this four-corner outline with a 17-polygon
insertion guard. Native readback preserves the previous seventeen definitions.
Sixteen access vias, nineteen leads and repour gained thirteen VSYS connections;
three later local attachments completed the rail's remaining connections.
Capacity remains unverified; a connected polygon is not a power sign-off.

Batch 057 exposed a Windows sharing conflict while rewriting a status file.
Native inventory established that only the first five requested vias existed.
The remaining four were submitted separately with a 609-via count guard.
All eleven vias in 057/060 and their twenty-eight combined tracks reconcile
exactly, including one provisional DDR address path. Read mutable logs using
file sharing that permits writes, or after native execution has finished.


## October 1, 00:40 UTC: insertion throughput and BGA access

FullTracks removes a duplicate whole-board count scan before each row, using
the previous row's native result under the single-controller contract. Every
write retains its native count and exact property readback. Batch 087 added
twenty tracks in 39.409 seconds (1.97 seconds each), compared with thirty in
99 seconds (3.3 each) for batch 075. Exact whole-board reconciliation confirmed
the requested tracks and three vias, with unchanged pads and rules.

FullVia permits two reviewed Top SMD pad centers at exact coordinates and
16/8 mil dimensions: SD3_DATA5 U4-B4 and DRAMB_DATA6 U2-B4. These scoped
exceptions preserve other occupied-coordinate refusals. Native readbacks and
independent geometry qualify their insertion; via fill/cap and fabrication
acceptance remain pending. The broader DDR corridor completed DRAMB_DATA6
without adding more than two signal vias. Matching remains deferred.

## 2026-10-01 02:20 UTC: component and layer transitions

Batch 113 plus expanded batch 114 completed seven routing connections, raising
native completion from 882 to 889 of 1,109. Exact native comparison confirms
125 added tracks and eleven vias, no changes to existing copper, pads, rules,
or net assignments, and no connectivity regressions after repouring.

The bounded planner labels free copper-space components on Top, L3, and Bottom
and tests legal vias between them. Circular pad masks and track endcaps avoid
false barriers from rectangular pad bounds. This found QSPI, SD2, SAI, and an
I2C branch where earlier single-layer attempts found no path. Root joint review
rejected two conflicting SAI proposals before revised paths were applied.

The paths have substantial detours. Native DRC, timing, return continuity, and
electrical acceptance remain pending. Checkpoint 025 preserves the measured
result; planning sources and exact comparisons remain under
`astra-run/runs/full-routing-2026-09-30/batches/114-multilayer-signals/`.

## 2026-10-01 02:25 UTC: wider fanout connection start

The nominal endpoint of the existing three-mil GPIO1_IO01 fanout left too
little room for the required 4.1-mil new trace. Starting three mils north of
that endpoint preserves 0.55 mil of positive copper overlap through the round
track caps, with 3.218 mil of exact clearance to the closest neighboring pad.
The existing track remains unchanged. Native inventory after repouring confirms
GPIO1_IO01 complete and no connectivity regressions. Batch 118 adds thirteen
tracks and two vias; whole-board completion is 890 of 1,109 connections.

The bounded search uses an exact-checked seed into the adjacent free raster
component. This is a qualified way to continue these inherited fanouts without
changing their copper or the current width rules. Each new application still
requires an exact overlap check and native connectivity measurement. Native
DRC and electrical acceptance remain deferred.


## 2026-10-01 03:34 UTC: compiled path search and checkpoint 027

Compiled four-connected component labels on a 0.5-mil grid and a queue search found routes that the bounded Python search did not finish. DDR CA0 visited 1,416,994 cells in 40 milliseconds; exact geometric simplification retained 13 L3 segments. Fine-grid searches also completed SAI1_TXD6, SD2_VSEL, PMIC_NINT, BOOT_MODE0, SD3_STROBE, and one SD3_DATA0 branch. Artificial raster padding decreased to 0.05 mil; the final 3.1-mil exact clearance screen and all existing board rules remained unchanged.

The POR_B connector access uses a reviewed 16/8-mil via at the exact J4-50 Bottom pad center. FullVia permits only that net, pad, coordinate, layer, and size in addition to its two earlier scoped pad-center exceptions. Native readback passed. Via-in-pad fabrication acceptance remains pending. The redundant R20-side via and two fully overlapped POR_B source segments were omitted. A USB power path conflicting with planned POR_B vias was replaced before application. Its repour opened two ground branches, repaired with five tracks and one via; the combined 139-146 native comparison confirms 11 connection gains with no residual regressions.

## 2026-10-01 04:00 UTC: DDR access detour and checkpoint 028

A three-segment L3 detour replaces one run-added DRAMB_CA2 segment, permitting the DRAMB_DATA3 memory via while preserving both CA2 terminals. Exact reconciliation proves the old segment was absent from original copper and all live changes match the request. Native inventory confirms both nets complete. This adds no more than two DATA3 signal vias; length matching remains deferred.

PDM_DATA2 uses the full legal via-component graph and compiled queue search. SD3_DATA0 CPU access uses an exact U1-M26 pad-center via. Two GND pad-center vias at J8-19 and J8-9 close two ground branches. These three scoped FullVia cases passed native readbacks; fabrication acceptance remains pending. The mixed track-edit and via reconciliation includes all explicitly requested nets, preserves the ordinary comparator warning, and accepts only exact edits to run-added copper. Checkpoint 028 verifies 912 of 1,109 connections with no native connectivity regressions.


## 2026-10-01 05:04 UTC: ground completion and narrow source corridors

Checkpoint 030 preserves 934 of 1,109 routed connections. Batches 172-202 add 22 connections since checkpoint 028 without changing original copper, placement, or rules. C91 required an explicit connection between two ground via groups; a nearby same-net via alone did not establish connectivity. Native inventory confirms all ground branches complete.

Two run-added SNVS segments use a local detour to permit the C391 ground connection. Exact reconciliation verifies their old geometry was absent from original copper and preserves the ordinary comparator warning. Narrow north CPU source corridors complete SAI and SPDIF paths while reserving neighboring DDR access; four RXFS segments were adjusted before application to retain the adjacent SPDIF exit.

Four new DDR data paths extend existing fanout without adding vias. DATA8 and the two mask paths use physically connected ground returns within 50 mil and retain at most two signal vias. FullVia's three new pad-center cases remain limited to exact native pads, nets, layers, coordinates, and 16/8-mil dimensions. Native readbacks passed. Final DRC, timing, return continuity, current capacity, and fabrication acceptance remain pending.

## 2026-10-01 05:30 UTC: native batch counts and planning reservations

FullTracks retains one board writer, initial native count and destination checks, exact per-row readbacks, a final native count scan, and final readbacks of all changed tracks. The audit distinguishes batch totals from per-row measurements. Caching preflight properties and removing per-row count scans qualified with exact whole-board comparisons. Ten additions took 14.261 seconds, thirteen took 17.497 seconds, and a later 23 took 26.950 seconds, compared with 132.378 seconds for the preceding 57-row request. Each part retains the helper source and readbacks used for that measurement.

An unbuilt signal-via reservation blocked using its own site in candidate searches. Explicitly consuming that logical reservation allowed DATA13 to use a nearby legal site with a physically connected ground return. Actual copper remains in every check. Future candidate reviews omit unused signal-via reservations only for native-complete nets or explicitly named consumed sites. Ground reservations remain unless consumed explicitly. This changes planning state, not PCB rules.

Checkpoint 031 preserves 943 of 1,109 connections and 166 complete named nets. The two new DDR clock legs count as individual connections; complementary legs and pair coupling remain open. Final DRC, timing, return continuity, current capacity, and fabrication acceptance remain pending.

## 2026-10-01 06:17 UTC: local I2C replacements and DDR control completion

Batches 216 and 224 complete SD1_CLK, SD2_DATA0, DRAMA_nCS1, DRAMA_CA0, DRAMA_CA1, DRAMB_CA1, and DRAMB_nCS1. SD2_DATA0 includes two completed branches. Thirteen run-added I2C segments are replaced, preserving both complete I2C nets and their connector branches. Original copper, placement, and rules remain unchanged. Ground remains fully connected.

FullTrackRemove passed stale-count refusal, exact single-track removal, Undo, and Redo. Whole-board track multisets and immutable tables match each expected state. The final batch reuses seven native SD2 segments and starts from the verified Redo state and removes the remaining twelve tracks. A status-file sharing error interrupted the first track request after 26 additions. Native export proved that exact prefix and the complete thirteen-track removal; only the missing 23 rows were resumed. Five DDR control paths use their two existing signal vias and connected ground returns within 50 mil. SD2_DATA0 adds seven vias, including an exact guarded J4-84 pad-center case; its detour and fabrication acceptance remain pending.

The via planning mask excludes noncopper drawing tracks. Exact geometry checks already ignored those layers; 1,716 native noncopper tracks had unnecessarily blocked candidate sites. Native keepouts and all actual copper remain enforced. The SD2_DATA0 search tests exact legal transition samples instead of rejecting a whole region from three invalid samples.

## 2026-10-01 07:21 UTC: L6 controls and supply repair

RTC_RESET_B gains one connected branch. PMIC_STBY_REQ, DRAMA_CKE0, and I2C3_SDA become complete. PMIC routing initially split four supply groups; eleven experimental RTC tracks were removed and local Top/L4 power connections restore every affected group. Original copper, placement, and design rules remain unchanged. Ground stays complete.

Native inventory and aggregate 246 compare the exact final track/via multiset and immutable tables to accepted checkpoint 034. The final delta is 67 added tracks and one via, with three fewer remaining connections. Checkpoint 033 to 035 adds four completed connections. The ARM connection uses sixteen L4 segments, all 20 mil wide, and one 16/8 mil source via; the proposed narrow version was never applied. Its 898.17 mil detour and supply current capacity remain provisional.

FullTracks permits only four named POWER nets on L4 within the unchanged 3–100 mil rule. Sixteen 20 mil additions passed native readback and whole-board reconciliation. The expanded 103-net L6 allowlist derives from native dominant widths. Differential query 242 matched 288 native rule UID/layer rows to unchanged original width fields; L6 differential widths are 15 mil and are not eligible for 3.2 mil single-ended paths.

## 2026-10-01 08:00 UTC: ECSPI, SAI, and guarded polygon refresh

ECSPI2_SCLK, ECSPI2_SS0, SAI2_TXFS, and SAI3_TXFS become complete. A 20 mil L4 SOC feed and a 10-20 mil L4 VDD1V8 connection preserve the supply groups affected by L6 signal routing. Native aggregate 255 verifies 113 added tracks and six vias, with four fewer remaining connections and no per-net regressions from checkpoint 035. Original copper, placement, and design rules remain unchanged. Supply capacity, impedance, timing, and final DRC remain pending.

The guarded RepourAndExportFullInventory procedure combines native polygon repour and inventory export. The qualified command is synchronous: the stable-board comparison was unchanged, and later exports reflected actual supply splits and repairs. It preserves the active-board path check and does not run DRC.

## 2026-10-01 08:32 UTC: larger signal groups and supply repair

Signal groups use exact primitive clearance and unchanged native width rules before application. Predicted polygon fragmentation is recorded as a provisional risk; it no longer causes an otherwise legal path to be discarded. Native connectivity after the group identifies actual supply gaps for repair. The prior accepted checkpoint remains preserved, and every temporary per-net regression remains in the unmodified comparison output. Final DRC and timing work remain deferred.

The SD2 group completed both clock and data paths. Native inventory showed one additional VDD1V8 edge and one ARM edge, while the planning model had also predicted a DRAMPU split that did not occur. Polygon identities must use net and layer because serialization can reorder their indices.


## October 1, 09:20 UTC: restore supply regions after signal groups

Checkpoint 038 preserves 973 connections, 13 more than 037. A short 10 mil Top ARM jumper replaces one exact run-added L4 segment, allowing a new DRAMPU L4 pour to join its source and CPU groups. VDD1V8 L4 additions reconnect two regions; an L6 VDDA feed connects one more group. Native aggregate 292 reports no connectivity regression, exact explicit copper changes, and unchanged original copper, pads, and rules. Existing polygon definitions remain unchanged.

FullTrackRemove accepts only that exact additional L4 ARM identity. FullTracks and its comparator include VDDA_1V8 in the native width229 allowlist; the initial unlisted request refused before mutation. Nine comparator tests pass, followed by exact native aggregate reconciliation. Final DRC and current-capacity, thermal, impedance, coupling, and timing review remain pending.

C21 remains isolated by dense Bottom copper. Bounded corner detours, complete PDM_DATA2 L3/L6 relocation, and a one-transition relocation did not produce a joint C21/PDM solution. The final one-transition model has 38 sites before reserving the C21 feed and zero afterward. Preserve these failures under quality/power281 through power286 and change the boundary method before retrying.

## 2026-10-01 09:48 UTC: completion batch and bounded routing space

Native ActiveRoute 297 selected 12 connections on ten ordinary nets and added no copper. Exact inventory preserved all explicit geometry and connectivity. Do not repeat this scope.

SNVS polygon 298 joins the source and lower supply bank; its CPU branch remains open. Native 298 improves 973 to 974 complete connections with all 22 older polygon definitions preserved. Saved checkpoint 039 hashes all 84 project files. SWOUT batch 302 adds one more native connection, with no regressions.

DDR proposal 296 and the first 299 revision crossed logical companion or ground reservations. Neither was applied. `ddr299-all-reservations-subset-01.json` includes all applicable reservations in its search, then passes the same joint preparation screen as other requests. It uses 29 tracks and three new vias, with 3.208 mil minimum native-copper clearance and 6.38 mil companion-track gap. Return access, coupling, and timing remain provisional.

The ordinary search previously excluded a large CPU/DDR rectangle. Search 303 uses actual DDR copper plus every applicable logical access reservation and 2 mil of extra track spacing. This is a search-model change; PCB rules and placement do not change. Batch 306 combines compatible proposals for five connections. VDDA uses its existing 3 mil POWER minimum on L6 for about 265 mil, with current/noise/reference review pending. The helper only extends that exact net's accepted input range; other L6 signal minima remain 3.2 mil.

## 2026-10-01 10:34 UTC - SNVS completion and local DDR access

Native313 and317 completed seven connections, reaching987/1109 with no exact-copper or connectivity regressions. Checkpoint041 preserves that result. SNVS uses the unchanged POWER minimum of3mil on L6 for the short CPU-to-existing-L4-strip connection; its final branch is native complete. Native325 then completed SAI5_MCLK and QSPIA_NSS0, reaching989; checkpoint042 preserves it before local repairs.

DDR316 moves four run-added segments: one GND Top segment, one DRAMA_DMI0 Bottom segment, and two VDD_SOC_0V8 L4 segments. The ground segment was incorrectly labeled inherited by the initial reviewer. Exact native baseline comparison and batch172 request row23 prove it was added during this run. The original-copper guard remains unchanged. Batch330 contains the corrected proposal plus SAI1_RXC, SD1_STROBE, and PDM_DATA3; native completion is still pending. DRAMA_SDQS0_C uses the existing layer6 fixed15mil85OHM_PHY rule. The helper scope accepts that exact net and width; it does not change the PCB rule.

The remaining failures need local endpoint access rather than repeated identical whole-board searches. Fine0.1mil sampling has exposed actual enclosed CPU pockets and specific run-added barriers. The ordinary four-layer sweep corrected a time limit that previously expired during graph construction, then produced seven complete signal paths across bulk315, 318, and 326. Actual native validation governs each accepted result.


## 2026-10-01 11:17 UTC: clock, reset, supply, and interface completion

Native334 and339 add seven completed connections, reaching 1,000 of 1,109 with no connectivity regressions. They complete DRAMB_CK_C, CLK_32K_OUT, RTC_RESET_B, DRAMA_CK_T, UART3_TXD, and DSI_D2_N, plus one NVCC_SD2 branch. Two replaced DATA4/DATA13 Top segments are proven run-added. Both data nets remain complete. Checkpoint045 preserves the exact 6,167 tracks and 801 vias.

The shared read-only width exporter preserves ExportWidth229's L6 output and adds ExportWidth337 for L4. Native337 returns 148 rows and confirms NVCC_SD2's existing 3 to 100 mil POWER range. Its 15-track L4 branch preserves DRAMPU connectivity after repour. No PCB rules change.

UART3_TXD exposed an incorrect search exclusion: every historical attempt was treated as done, including failures. A retry produced one full surface path. Sweeps341 and346 retry previously failed ordinary nets against the current model within four-minute bounds. Unsuccessful geometry still needs a different access method, not an identical repeated search.

DDR340/342 propose the remaining DDRB strobe pair with 59 tracks and four vias under the fixed 15 mil L6 rule. Both centerlines have ground reference; 567 quarter-mil samples on the C trace edge remain flagged for final reference review. The T trace edge passes. Matching, return transitions, and final electrical acceptance remain pending while connectivity work proceeds.


## Bounded L2 escapes and remaining supplies

Checkpoint050 records 12 additional native connections. Short L2 escapes use the existing per-layer width rules and preserve GND connectivity after repour. CA5 uses a 261.645 mil L2 escape within the unchanged native width rule and the 180 mil endpoint radius. Four supply paths include wider sections where exact joint clearance permits. Batch367 disconnected one VDD_1V8 pour connection; batch378 repairs it with explicit L4 copper. Batch383 did not repair NVCC_SNVS_1V8 because both endpoints were on the same current island. Batch388 adds a source-island via and a 52.414 mil L2 connection based on the saved Regions6 contours. Aggregate391 preserves the failed comparisons and verifies the combined result against checkpoint049. Long narrow supply sections, impedance, return paths, timing, and final DRC remain pending. All original copper, rules, and placement remain unchanged.


## DSI_D1_P local replacement

Batch396 replaces two run-added tracks while retaining both nets' endpoints and widths. The resulting DSI_D1_P route uses native 3 mil surface and 15 mil L6 widths. Candidate clearance uses the unchanged native 3 mil limit without the optional 0.1 mil planning margin. Native repour verifies one added connection and no per-net regressions. Original copper and rules remain unchanged. Pair coupling, return paths, timing, and final DRC remain pending.


## Local SD2, USB, and DSI repairs

Native402 pushes two inherited vias and their incident fanout to complete SD2_CMD. Saved051 precedes the bounded local repair; all other net connectivity remains unchanged. Minimum gap is 0.615 internal unit below 3 mil; inherited SD2_DATA1 Top width remains 3 mil, with final review pending. USB404 moves a slow identification net onto L2 to complete VBUS. DSI407 replaces local run-added SOC and UART traces under existing width limits and completes DSI_D3_P. Native repour verifies three added connections and no net regressions. Candidate review permits exact retained subsegments only when clearance is unchanged from the baseline; new geometry still uses the native 3 mil minimum. Rules and placement remain unchanged. Reference, current capacity, timing, coupling, and final DRC remain pending.


## October 1, 2026: CSI local repairs 409 and 410

**1,020 / 1,109 required connections routed (91.97%), 89 remaining.** Native inventory confirms 233 of 321 named nets complete, 6,800 tracks, and 843 vias.

Batches 409 and 410 complete CSI_D0_P and CSI_D2_P. Exact native readback and repour confirm the requested copper and preserve all neighboring connections, pads, rules, and net assignments. The two repairs add 94 tracks, replace nine run-added tracks, and add four vias. No original copper changes in these batches.

Both CSI signals use their existing fixed 15 mil L2 differential width. Their L2 legs are 537.162 and 640.630 mil, beyond earlier short-escape planning limits. The repairs preserve DSI_D3_P, VDD_SOC_0V8, VDD_PHY_0V9, UART2_RXD, UART1_CTS, and UART4_TXD. Supply current capacity, return paths, coupling, length, and impedance remain pending. The exact retained UART2 terminal keeps its prior 2.999983 mil gap; all other new geometry meets the native 3 mil threshold. The CSI_D2_P 16/8 mil via at U1-B17 requires fill and cap acceptance.

The earlier native SD2_CMD push repair in batch 402 moves two inherited vias by 1.937248 and 0.234596 mil. Three Top SD2_DATA1 segments retain their inherited 3 mil width; the minimum gap is 2.99993849 mil. These known findings remain for final width and DRC review.

Batch 408's C21 interactive attempt produced no connection gain and was undone. Exact inventory proves full restoration before batch 409. Do not repeat the unchanged C21 attempt.

Checkpoint 055 was saved at 2026-10-01T14:39:07.579000+00:00; PCB SHA-256 `21410e97211d6952e39bcd0731e64a0716cbd6971f92873d34c0465405b39ed1`. All 103 project files were copied and hash-verified. Error markers were reset before saving. The saved PCB has not been reopened. Included DRC reports predate this PCB; final DRC is deferred until routing ends. Electrical and fabrication acceptance remain pending.

2026-10-01 native416: CtrlW used the previous cursor position and created an unassigned stroke. The exact export showed zero connection gain; one Undo restored all tracks, vias, pads, rules, and net assignments to actual410. Position the cursor on the intended pad before CtrlW and confirm the native net name before committing a segment.


## 2026-10-01 15:40 UTC: native SAI access and three-net completion

Native Push in batch 421 creates SAI1_TXD0 Top access where the static RXD2 repair failed. Six replaced tracks were all run-added; original copper, pads, and rules remain unchanged. Repour exposes one VDD_DRAM&PU_0V9 edge. Batch 424 completes SAI1_TXD0 and XTALO_24M and restores that supply connection; batch 427 completes DRAMB_CA5 between existing vias. The aggregate from checkpoint 055 is 89 to 86 remaining, with no net regression. Evidence: `astra-run/runs/full-routing-2026-09-30/batches/427-ddrb-ca5-completion/aggregate-from055.json`.

FullTracks and the request validator allow native-width SAI1_TXD0 and DRAMB_CA5 additions on L2; XTALO_24M additions on L4 require exactly 3.2 mil. FullVia adds the exact own-pad Y1-1 center exception under its existing 16/8 and net guards. Loaded source was closed and reloaded before use; exact readback and all 11 reconciliation tests pass. No board rule changed. The crystal pad vias, long L2 paths, and narrow supply repair remain provisional for final electrical review.

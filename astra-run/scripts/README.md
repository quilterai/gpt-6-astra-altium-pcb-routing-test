# Routing scripts

These scripts keep the original experiment's exact board and request checks.
The published projects in [`speedrun-input/`](../../speedrun-input/) and
[`astra-output/`](../../astra-output/) are reference artifacts; run editing
helpers only on disposable working copies.

## Paths in this checkout

Open the matching `.PrjScr` file from this directory in Altium before invoking
its entrypoint. Each project includes `AstraPaths.pas`, which finds that named
loaded script project and derives its parent `astra-run/` directory. The helper
refuses missing or duplicate project names. It does not use the current working
directory or the active PCB's directory to choose a workspace.

Full-run helpers require the copied PCB at
`astra-run/work/full-routing-2026-09-30/QCMI_SOM8MM/IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc`.
`TrialProbe` and `TrialVia` require it at
`astra-run/trials/routing-50-2026-09-30/QCMI_SOM8MM/IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc`.
Despite its retained name, `TrialInventory` targets the full-run working PCB.
Copy the complete repository-root `speedrun-input/` project into the relevant
working directory before opening it. Create the output directory used by each
helper before running it; the scripts do not create these directories:

| Script project | Output directory relative to `astra-run/` |
|---|---|
| `TrialProbe.PrjScr`, `TrialVia.PrjScr` | `runs/current-inspection/` |
| `TrialInventory.PrjScr` | `runs/full-routing-2026-09-30/current-inspection/` |
| `FullTracks.PrjScr` | `runs/full-routing-2026-09-30/quality/full-tracks/` |
| `FullVia.PrjScr`, `FullViaSelect.PrjScr` | `runs/full-routing-2026-09-30/quality/full-via/` |
| `FullPolygon.PrjScr` | `runs/full-routing-2026-09-30/quality/full-polygon/` |
| `FullTrackWidths.PrjScr` | `runs/full-routing-2026-09-30/quality/full-track-widths/` |
| `FullTrackRemove.PrjScr` | `runs/full-routing-2026-09-30/quality/full-track-remove/` |
| `FullDetails.PrjScr` | `runs/full-routing-2026-09-30/quality/details/`; width/rule queries also use `runs/full-routing-2026-09-30/electrical/` and `runs/full-routing-2026-09-30/quality/` |
| `FullDetailsDelay.PrjScr` | `runs/full-routing-2026-09-30/quality/delay-details/` |
| `BTGroundAccess.PrjScr` | `runs/full-routing-2026-09-30/electrical/` |

These directories and `astra-run/results/` hold ignored local runtime files;
the historical snapshots are not bundled. For another authorized working-copy
location, change and requalify the helper's workspace-relative board and output
paths explicitly. Preserve the full-path guard and the original input bytes.
Shell examples below run from `astra-run/` unless the repository root is named.

Python inventory tools accept explicit input and output paths. Run the existing
unit tests from the repository root:

```sh
uv run --locked --project astra-run/quickstart python -m unittest discover -s astra-run/scripts -p 'test_*.py' -v
```

The named-project lookup uses the documented Altium Workspace Manager methods
[`DM_ProjectCount`, `DM_Projects`, and `DM_ProjectFullPath`](https://www.altium.com/documentation/altium-dxp-developer/workspace-manager-api).
Its path wiring can be checked without Altium; native script execution still
requires qualification on Windows with Altium.

## Experiment qualification record

The following notes describe the original run and retain its dated working-copy
and report names. The `runs/`, `work/`, `trials/`, and `results/` paths below are
relative to `astra-run/`; those runtime snapshots are not bundled in this repo.
Bare receipt names, `electrical/...`, and `quality/...` in that historical
record refer to `runs/full-routing-2026-09-30/`, unless a section gives a more
specific location. They are not checked-in files beside this README. The
[published evidence index](../../astra-output/evidence/README.md) identifies the
selected exports that are included. Historical qualifications describe the
earlier tool revisions; the maintained path adaptations require current
Windows/Altium qualification.

RXD3 connector access permits the exact J5-86 Bottom pad center with a
16/8 mil via. Batch639 replaces four exact run-added tracks while retaining
all affected terminals. Via fill and cap and final electrical review remain pending.

GPIO1_IO05 L7 replacements use the existing 3.2 to 10 mil native limits
recorded by receipt366. Batch636 preserves all four affected terminal sets
while opening space for the RXD3 source via. Final layer review remains pending.

PCIE_TX_N L5 additions use 15 mil under the existing 85OHM_PHY pair rule.
POR_B L7 replacements use 3.2 mil, confirmed by native receipt634.
Six exact run-added removal identities preserve all affected terminals.
The offset PCIE_TX_N via requires the exact J4-69 pad and a 16/8 mil size.
Final layer reassignment remains required for these provisional paths.

NetR7 access replaces two exact run-added inner tracks on DRAMA_nCS0 L6
and DRAMA_CA5 L2. Its 13.2226 mil Top source neck uses 3 mil copper under
the fixed 4.1 mil rule and requires final repair. The remaining NetR7
Top and Bottom tracks use 4.1 mil. The UART1_TXD trim removes only a
run-added spur without pads or vias; both device terminals remain connected.

SAI1_RXFS and SAI1_RXD4 L7 additions use the existing 3.2 to 10 mil
limits in `width366-L7-native.tsv`. RXFS and GPIO1_IO01 L3 additions use
the fixed 3.2 mil width recorded by receipt609. Native source escapes
617 and619 preserve every affected pad and via connection. Final GND
layer reassignment remains required.

SAI1_RXD4 L2 additions use the existing 3.2 to 10 mil width limits
recorded in `width623-SAI1_RXD4-L2-native.tsv`. The GND layer section
requires reassignment during the final layer review.

SD3_DATA2 L5 additions use the native 3.2 to 10 mil limits. Its exact Top
fanout edit extends one inherited 3 mil segment by 7.7 mil; the helper
rejects other 3 mil DATA2 edits. That extension retains width debt under
the existing 4.1 mil rule. Batch593's guarded entrypoint moves two exact
run-added vias, preserves their sizes and layers, and checks their readback.
Thirteen exact inner-layer removal identities admit the reviewed connected
replacements. The offset U4-A5 via requires its own pad and 16/8 mil size.
See [DATA2 access](../notes/SD3_DATA2_ACCESS_608.md).

SAI1_RXD6 L5 additions use the existing 3.2 to 10 mil limits in
`width366-L5-native.tsv`. The native source escape preserves neighboring
signal connections; its VDDA supply repair restores the moved via contact.
Final PWR layer reassignment remains required.

GND L6 additions use 5 to 10 mil within the native 3 to 100 mil width
rule in `width524-GND-L6-native.tsv`. The explicit repair joins existing vias.

SAI1_TXD5 L7 additions use the existing 3.2 to 10 mil limits recorded in
`width366-L7-native.tsv`. Its native source escape and through-via preserve
all affected pad and via connections. Final GND layer reassignment remains
required.

VDD_3V3 L6 additions use 3 to 20 mil for the explicit supply repair.
Native receipt594 confirms the unchanged 3 to 100 mil width rule.
The 332.5 mil section at 3 mil still requires current-capacity review.

GND L7 additions use 3 to 10 mil for the explicit C9 return connection.
Native receipt592 confirms the unchanged 3 to 100 mil width rule. Batch592
retains every modeled Ground terminal; final Ground layer cleanup remains
required. RXD0 L5 additions use the existing 3.2 to 10 mil width rule.
Its inherited RXD1 antenna trim is bounded by exact identities and the
terminal proof in [SAI1_RXD0_ACCESS_589.md](../notes/SAI1_RXD0_ACCESS_589.md).

VDD_3V3 L5 additions use 3 to 20 mil within the unchanged native 3 to
100 mil width rule recorded by receipt583. The supply repair connects
existing vias; current capacity and final DRC remain pending.

ENET_TD1 L4 additions use the fixed 3.2 mil width, and SD2_DATA1 L7
uses 3.2 to 10 mil. Native width receipts571/573 confirm the 3 to 100 mil
limits for VDD_ARM_0V9 L5 and VDD_3V3 L7. Exact removal targets identify
the eighteen run-added tracks replaced for TD1 access. ARM and VDD_3V3
current capacity remains unresolved; final layer assignment is pending.

ENET_RD2 L4 and ENET_MDC L6 additions use their existing width limits.
The DSI_D0_P access batch uses the fixed 15 mil L7 differential width,
with I2C replacements on L2/L5 at 3.2 to 10 mil. `ExportWidth544` records
the native width receipts. The via helper scopes the exact U1-B9 Top pad
center; fill and cap acceptance remains pending. Removal scopes identify
only the exact run-added tracks replaced by these batches.

CLKIN2 L2 additions use the existing 3.2–10 mil width range; QSPIA_DATA2 L4
additions use 3.2 mil. `ExportWidth544` reads the latter rule into the batch562
receipt without changing rules. Four exact run-added removal targets identify
the QSPIA_DATA3, QSPIA_DATA2, UART1_RTS, and NVCC_SNVS_1V8 segments replaced
by the CLKIN2 batch. Final layer assignment remains pending.

## Full-run insertion throughput

`FullTracks.pas` keeps one controller as the only board writer. It measures
the native count before and after the batch, reads each changed track after
its write, and reads all changed tracks again before reporting success.
Preflight caches existing track properties. Batch 206 qualifies thirteen
additions in 17.497 seconds after an initial ten-addition trial in 14.261
seconds. The preceding 57-row request took 132.378 seconds with per-row count
scans. Whole-board reconciliation confirms the exact requested copper.
Requests and invocation are documented in
[FULL_TRACKS_HELPER.md](../notes/FULL_TRACKS_HELPER.md).

## Reviewed power repair scope

`ExportWidth544` reads DRAMB_DATA4, DRAMB_nCS1, and SD2_WP on L5. Their
native receipts confirm the existing 3.2 to 10 mil limits. WL_WAKE_HOST uses
the same limits from `width366-L5-native.tsv`. These provisional PWR-layer
paths require reassignment during the final layer review. The via helper
permits only the reviewed DRAMB_DATA4 U1-V2 pad center with a 16/8 mil via;
fill and cap acceptance remains pending.

The same read-only entrypoint exports QSPIA_DATA0 on L2/L4, UART1_CTS
on L7, and WL_REG_ON on L4/L5 for the SD1_DATA3 access replacements.
Their native limits are 3.2 to 10 mil. VDD_ARM_0V9 on L4 permits 3 to
100 mil, with a preferred width of 10 mil; current capacity is a separate
requirement. These helper scopes leave the board rules unchanged.

Do not poll per-row helper reports during native insertion. A concurrent
reader can prevent Altium from writing a report. After an interruption,
export the actual copper, reconcile the applied prefix, and stage only
the verified remainder.

SAI1_TXD7 accepts L2 additions at the existing 3.2 to 10 mil limits in
`width351-native.tsv`. Batch557 replaces two exact run-added Top segments
on SAI1_TXD6 and SD2_DATA2 and reconnects both nets. Its two 16/8 mil vias
do not coincide with native pad centers.

`ExportWidth514` confirms the existing fixed 3.2 mil PMIC_ON_REQ and
QSPIA_DATA3 L3 widths, and the fixed 4.1 mil USB2_ID Bottom width. USB1_DN
accepts only 15 mil L5 additions under the unchanged 90OHM_USB differential
rule. Its access repair removes two exact run-added inner tracks on NetR30_1
and JTAG_TDO. SAI1_TXD4 accepts 3.2 to 10 mil additions on L2 and L5;
its guarded removals identify four exact run-added inner tracks. These helper
scopes do not change board rules. Pair coupling and supply capacity remain
subject to final review.

`ExportWidth493` reads GPIO1_IO10 on L2, GPIO1_IO11 on L7, and DRAM_NRESET
on L5. Each native receipt confirms 3.2 to 10 mil limits. GPIO1_IO07 uses
the same L5 limits from `width366-L5-native.tsv`. Batch493 completes GPIO1_IO07
and preserves four neighboring nets through 22 exact run-added removals,
24 track additions, and two 16/8 mil vias. Its exact native comparison passes.
The via helper permits only the recorded GPIO1_IO07 U1-AF11 and J5-56 pad
centers and dimensions. Fill and cap acceptance remains pending.

The DRAM_NRESET access request permits the exact U1-R1 pad center and two
specific run-added inner tracks: DRAMB_CA4 on L6 and VDD_SOC_0V8 on L4.
The supply replacement retains 20 mil width except for a short 10 mil neck,
within the existing POWER width rule; current capacity remains unresolved.

XTALI_32K and ENET_RXC accept L7 additions at their existing 3.2 to 10 mil
width limits. XTALO_32K accepts the same limits on L5. `ExportWidth485`
confirms the fixed 3.2 mil JTAG_TDI L3 width used by the clock access repair.
Batch485 preserves every connection while moving one run-added XTALO_32K
via and replacing its local tracks. The combined native entrypoint guards
the old via identity and board counts before writing and verifies its new
position before applying the explicit track and via requests.

Batch489 scopes eleven exact inner-layer removal targets: two ARM L4
segments and nine SAI2_TXC L7 segments. Its connected replacements preserve
ARM, SAI2_TXC, and SD2_DATA1 while adding ENET_RXC. These targets are absent
from the original board. General inner-layer removal remains disallowed.

`ExportWidth465` confirms the native 3.2 to 10 mil limits for PDM_DATA1 and
SAI1_RXD5 on L5 and PDM_DATA2 on L7. Batch466 uses those scopes with
SAI1_RXD1 and SAI5_RXFS on L2, preserving each affected connection.

ENET_TD0 uses the native 3.2 mil L4 minimum. Its path split the
NVCC_SNVS_1V8 polygon; batch468 restores connectivity with two 16/8 mil
vias and a 75 mil, 10 mil wide Top jumper between the measured islands.
Aggregate471 verifies the combined copper and all-net connectivity against
checkpoint066. No board rules changed; final DRC remains deferred.

SAI1_TXD1 accepts L7 additions at the native 3.2 to 10 mil limits in
`width366-L7-native.tsv`. SAI1_RXD5 accepts the same L2 limits in
`width351-native.tsv`. `ExportWidth455` confirms those limits for SAI1_TXC
on L2 in `width455-SAI1_TXC-L2-native.tsv`. These scopes support connected
replacements between existing SAI1_TXC vias and the new SAI connections.

SD3_CLK accepts 3.2 to 10 mil L2 additions under its unchanged width rule,
verified in `width351-native.tsv`. Batch 452 uses a 16/8 mil via at U4-M6;
the helper requires the exact net, Top pad, center, and size. Its two
run-added WL_REG_ON Bottom segments have a connected replacement. Via fill
and cap, timing, and return paths remain pending.

JTAG_TDO accepts L2 additions at the native 3.2 to 10 mil width limits in
`width351-native.tsv`. Batch 453 preserves RTC_RESET_B with a connected L6
replacement and connects J4-52 through a 4.1 mil Bottom lead, consistent with
`width442-Bottom-native.tsv`. Its offset CPU via overlaps its own surface pad;
fabrication acceptance, timing, and return paths remain pending.

`FullTrackRemove` accepts the exact run-added L4 ARM segment in batch 289 in
addition to its earlier scopes. Its replacement uses two vias and a short Top
jumper. `FullPolygon` accepts the reviewed DRAMPU and VDD1V8 L4 outlines at their
exact polygon counts. Native definition readbacks preserve every earlier polygon.
`FullTracks` and `reconcile_tracks.py` accept VDDA_1V8 and NVCC_SNVS_1V8 on L6
at their existing 3 mil POWER minimum. Ordinary L6 signal inputs remain at
least 3.2 mil. NVCC_SD2 uses its unchanged 3 to 100 mil Width rule on L4.
DRAMA_SDQS0_C, DRAMA_CK_T, DRAMB_CK_C, and DRAMB_SDQS1_C/T accept only
15 mil additions on L6 under the existing per-layer 85OHM_PHY rule.
`FullTrackRemove` also accepts the two exact
run-added L4 SOC segments identified by the DDR316 access repair; this scope
does not allow general L4 removal. Original-copper guards remain unchanged.
Aggregate 292 verifies the resulting copper and
supply connectivity; final DRC and electrical acceptance remain pending.

`FullDetails.ExportWidth337` exports effective L4 widths to
`electrical/width337-native.tsv` in the current run. `ExportWidth351` exports
L2 widths to `electrical/width351-native.tsv`. Both native read-only queries
returned 148 rows. The shared exporter queries the requested layer;
`ExportWidth229` retains its L6 output path and column names.

`ExportWidth366` reads L5 and L7 into `width366-L5-native.tsv` and
`width366-L7-native.tsv`. Each output contains 148 rows. These queries change
neither geometry nor rules.

`ExportWidth442` reads Top and Bottom into `width442-Top-native.tsv` and
`width442-Bottom-native.tsv`. Each output contains 148 rows and confirms
the unchanged 4.1 mil surface width for UART1_RTS.

SAI2_RXD, SAI2_TXC, UART1_RXD, UART1_RTS, and SAI5_RXFS accept L7 additions at
their native 3.2 to 10 mil width limits. SAI2_TXD and DRAMA_DATA1 accept the same
limits on L2.
SAI2_TXC's access repair replaces the exact run-added NVCC_SD2 L6
segment at x1905.5 mil, preserving its endpoints and 5 mil width. The bounded
removal helper accepts that exact segment and the four reviewed run-added
VDD_SOC_0V8 L4 segments in batch 435. Return paths, timing, and supply current
capacity need final review.

UART1_RTS uses the off-pad via and connected replacements in batch 443.
The removal helper accepts its two exact run-added NVCC_SD2 L6 segments;
the replacement preserves the endpoints with 3.2 and 5 mil widths.

SAI5_RXFS uses a 3.2 mil L7 connection and a 16/8 mil via inside J5-70 in
batch 444. Its access repair replaces two exact run-added SAI1_RXC L6 segments
and one QSPIA_DATA0 Top segment. The SAI1_RXC replacement starts 0.5 mil from
the retained 3.2 mil segment endpoint; their copper overlaps. Via fill and cap
remain unverified.

Bounded L2 additions accept only SD2_CMD, QSPIA_SCLK, DRAMA_CA4, DRAMA_CA5,
DRAMB_CKE1, and SAI2_RXC at 3.2 to 10 mil under their existing width rules. Native
batches354, 360, and361 verify their exact requested copper and improved
connectivity after repour. CA5 in batch378 includes a 261.645 mil escape,
an exception to the earlier 250 mil planning limit. SAI2_RXC in batch387 uses
a 268.603 mil L2 escape. All these escapes remain
within 180 mil of a native endpoint. Local return paths and impedance remain
subject to final review.

DSI_D3_P accepts only 15 mil additions on L2 under its existing
DiffPairsRouting rule (UID JWYMXBFP). The local repair replaces one exact
run-added L4 SOC segment and one Bottom UART1_CTS segment. SOC retains its
endpoints and uses a 10 mil middle section within its native POWER width
limits. The UART replacement preserves the exact terminal geometry whose
measured gap is 2.999988 mil. The planner records that unchanged gap separately
from new geometry. Current capacity, differential coupling, and reference
continuity remain pending.

CSI_D0_P also accepts only 15 mil L2 additions under its existing
DiffPairsRouting rule. Its local repair replaces exact run-added segments on
DSI_D3_P, VDD_SOC_0V8, UART2_RXD, and VDD_PHY_0V9. The 537.162 mil L2 leg
exceeds the earlier short-escape planning limit. Reference continuity,
differential coupling, and supply current capacity remain pending.

CSI_D2_P uses the same native 15 mil L2 width. Its repair replaces four exact
run-added records on VDD_SOC_0V8, UART1_CTS, and UART4_TXD. The L2 leg is
640.630 mil; its reference continuity and coupling remain pending. SOC uses
67.302 mil of 10 mil track plus 10.75 mil of 20 mil track, with current capacity
pending. All new geometry meets the native 3 mil clearance threshold.
The 16/8 mil CPU via is at U1-B17's exact Top pad center. Its helper exception
requires the net, pad name, layer, center, and size to match; fill and cap
acceptance remain pending.

SAI2_MCLK uses a 16/8 mil via at J5-66's exact Bottom pad center. Its helper
exception requires that net, pad, layer, center, and size. The L2 path uses the
native 3.2 mil minimum from `width351-native.tsv`. FullTracks accepts this net
on L2 at 3.2 to 10 mil. Fill and cap acceptance remain pending.

SYS_STATUS accepts L2 additions at its unchanged 3.2 to 10 mil limits from
`width351-native.tsv`. Its off-pad CPU via contacts the original Top fanout.
Its connected neighbor repairs replace one run-added QSPIA_DATA3 L3 segment
and one run-added SD1_STROBE L6 segment. The L6 removal guard requires that
segment's exact endpoints, net, layer, and width.

DRAMA_DATA5 accepts L2 additions at the existing 3.2 to 10 mil limits in
`width351-native.tsv`. Its access repair replaces two exact run-added
DRAMA_SDQS0_C L6 segments and one DRAMA_DATA1 L2 segment. Removal guards
require their endpoints, nets, layers, and widths. The connected strobe
replacement retains L6 and 15 mil width; pair coupling and timing remain
pending. Ground replacements use 5 mil Top tracks.

VDD_SNVS_0V8, NVCC_ENET, NVCC_SD2, and VDD_PHY_0V9 accept L6 additions at their
unchanged 3 to 100 mil POWER width limits. Request guards reject other nets,
edits, and widths outside this range. Supply current capacity and voltage drop
need separate review even when geometry and connectivity pass.

NVCC_SNVS_1V8 accepts L2 additions at its existing 3 to 100 mil POWER width
limits. Batch383 adds four segments between existing vias; both are on the
same island, so native connectivity did not improve. Batch388 connects a new
source-island via to the CPU island using two 20 mil L2 segments. Its source
contact comes from the actual saved Regions6 contours. The native width query
is in `width351-native.tsv`.
Other L2 supply nets and all L2 edits remain rejected.

`ExportUsbIdWidth403` reads USB1_ID's existing L2 width rule into
`electrical/width403-USB1_ID-L2-native.tsv`. Its native limits are 3.2 to 10 mil.
The insertion helper accepts USB1_ID additions within those limits. The local
USB repair uses a 556.267 mil L2 trace to free the Bottom VBUS path; it exceeds
the earlier short-escape planning limit. Return paths and impedance remain
subject to final review.

DSI_D1_P accepts only 15 mil additions on L6, matching its native DiffPairsRouting
per-layer width in `quality/diff242-joined.json`. Batch396 replaces two run-added
tracks while preserving their endpoints and completes DSI_D1_P after repour.
The local candidate review uses the existing 3 mil clearance without the optional
0.1 mil planning margin. Rules remain unchanged. Exact geometry and all other
net connection counts match the requests. Pair coupling, length, return paths,
and final DRC remain pending.

## Native repour and inventory

`RepourAndExportFullInventory` requires the exact active full-run PCB. It invokes
the installed Repour All process, then exports the inventory. It does not change
rules, components, or explicit tracks and vias. Qualification 247 repeats this
on saved checkpoint 035 and preserves all geometry and 154 remaining connections.
Use it after copper changes to replace separate repour and export menu actions.
This procedure changes polygon fills; `ExportTrialInventory` remains read-only.

## Active full-run inventory target

`TrialInventory.pas` keeps the existing inspection and selection implementation,
with its full-path guard set to the fresh working project at
`work/full-routing-2026-09-30/QCMI_SOM8MM/IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc`.
Its output directory is `runs/full-routing-2026-09-30/current-inspection/`.
Create selection request files there for the full run. The two constants and
missing-board message changed; inventory/selection behavior is unchanged.
The live export completed at 04:48:18 UTC and matched the original geometry;
native Board Information confirmed its 857 remaining connections. The selector
then selected all eight PMIC nets, and the post-route export measured eight
completed connections. Preserve each accepted export in an immutable batch
directory. `TrialProbe` and `TrialVia` still target the trial
and must not be used unchanged for the full run.

The measured procedures below describe the setup trial. `TrialInventory` was
later retargeted to the full run, as listed above. Its historical trial exports
and selection qualifications do not mean the current file targets the trial.
To repeat an inventory or selection procedure on a different copy, explicitly
configure and requalify both its board and output paths first.

`TrialProbe` and the inventory/selection entrypoints in `TrialInventory` inspect
one disposable PCB and select explicitly listed nets or source pads. Those
entrypoints contain no geometry edits, routing commands, saves, timers, or
background controller. The separate `RepourAndExportFullInventory` entrypoint
changes polygon fills. Their finite iterator passes only traverse the current
board's objects. `TrialVia` provides bounded explicit via
and LED-stub edits plus an exact DRC-segment selector. Its live qualifications
and remaining limits are recorded below.

The current `TrialProbe` and `TrialVia` require this exact active PCB:

```text
<repo>\astra-run\trials\routing-50-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc
```

The path functions at the top of each `.pas` file resolve the expected board
and output directory through `AstraPaths.pas`. Change their workspace-relative
paths explicitly for a different authorized trial. Matching only
the filename would also accept the preserved input and work copies, so the
guard compares the full path.

## Run in Altium

1. From `astra-run/`, create `runs/current-inspection/` for the probe and
   `runs/full-routing-2026-09-30/current-inspection/` for the inventory with
   PowerShell. The scripts refuse a missing output directory.
2. Activate the routing-50 trial PCB. Finish or cancel any interactive command.
3. Use **File > Open** to load `scripts/TrialProbe.PrjScr`. Choose
   **File > Run Script**, then `TrialProbe.pas > ProbeTrialBoard`.
4. Confirm the success dialog and inspect `runs/current-inspection/probe.tsv`.
   It must name the exact trial PCB and contain `read_only_ok`.
5. Activate the copied **full-run** PCB at the guarded `work/` path listed above.
   Use File > Open to load `scripts/TrialInventory.PrjScr`, then File > Run
   Script to run `TrialInventory.pas > ExportTrialInventory`. It refuses the
   routing-50 trial unless explicitly retargeted and requalified.
6. Inspect `runs/full-routing-2026-09-30/current-inspection/` and require
   `inventory-status.txt` containing `complete` before using the
   exported tables. A successful inventory opens no dialog. A failed export
   leaves its last stage, such as `read_pads` or `write_connections`.
   If Altium reports an error, note the source line, dismiss the dialog, and
   use **Run > Stop** (`Ctrl+F3`) before fixing and rerunning.

The script editor also offers **Run > Run** (`F9`). The first invocation asks
for a startup procedure; choose `ExportTrialInventory`. Later F9 invocations
reuse it. `GetCurrentPCBBoard` returned nil with the script editor active;
the inventory uses `GetPCBBoardByPath` instead. Altium reloaded the externally
edited source in the trial; inspect the new source before rerunning it.

In this VM, opening `.PrjScr` through the normal **File > Open** dialog worked.
The script runner's Browse dropdown encountered the window-size failure
described in [Views](../notes/altium/VIEWS.md). Load the project with File > Open,
then use File > Run Script or F9 as appropriate.

## Inventory

The current `TrialInventory` export replaces these files under
`runs/full-routing-2026-09-30/current-inspection/`. The original trial used
`runs/current-inspection/`; the current probe and via trial still use that
directory. Preserve a baseline copy in a separate run directory before routing
or exporting again.

| File | Content |
|---|---|
| `board.tsv` | Exact filename, origin, unit conversion, object counts, connectivity validity |
| `nets.tsv` | Net names, pin/via counts, routed length, connectivity and visibility flags |
| `pads.tsv` | Reference designator, pad name, net, center coordinates, layer, rotation, basic size, hole |
| `tracks.tsv` | Net, both endpoints, width, layer, selection |
| `vias.tsv` | Net, center, size, hole, layer span, selection |
| `connections.tsv` | Net, endpoints/layers, ratsnest or broken-marker mode, redundant flag, selection |
| `rules.tsv` | Rule name/kind, priority, enabled state, scopes, API summary text |

Coordinates and lengths with `_raw` suffix use Altium internal units.
`board.tsv` exports the value returned by `MilsToCoord(1)`; divide raw values by
it to get mils, then multiply mils by 0.0254 for millimeters. Coordinates use the
absolute database origin; the user origin is exported separately. Layer labels
come from `Layer2String` and can differ from customized board layer names.

`nonredundant_ratsnest_connections` counts connection objects whose mode is
`eRatsNestConnection` and whose `IsRedundant` result is false. Treat it as a
candidate unrouted-connection metric until it agrees with Altium's displayed
unrouted count on the loaded board. The script does not rebuild connectivity.
An invalid-connectivity flag or a disagreement needs investigation before using
the count to claim completed routing. Track segments and completed connections
are separate measures; one connection can require several segments.

The legacy `AllLayers` iterator excludes some extended mechanical layers:
the script reported 2,825 tracks while native Board Information reported 8,315.
Both reported 1,109 copper tracks. Do not use the exported track count as a
whole-document primitive count.

The export covers pads, straight tracks, vias, and connection objects. It does
not reconstruct polygons, arcs, pad stacks, or the full stackup. Rule summary
text helps inspection; it does not evaluate which rule wins at each location.
These files are an inspection aid, not a DRC report or a router input model.

## Select allowlisted nets

Create `runs/full-routing-2026-09-30/current-inspection/select-nets.txt` with
1-50 exact, case-sensitive net names, one per line. Blank lines and lines
starting with `#` are ignored.
Then run `SelectAllowlistedNets` from `TrialInventory.PrjScr`.

The routine first validates every name. An empty, oversized, missing, or unknown
list leaves selection unchanged. For a valid list, it deselects board primitives
and selects pads, straight tracks, vias, arcs, and connections belonging to those
nets. It redraws and reports the selected primitive count. It does not change
coordinates, layers, widths, connectivity, rules, or save the board. Inspect the
result before invoking any Altium routing command.

## Export, select, and zoom the next group

With the exact guarded working PCB active and no interactive command running, use
`ExportAndSelectAllowlistedNets` from `TrialInventory.PrjScr`. It calls
`ExportTrialInventory`, then `SelectAllowlistedNets`, then fits the selected
objects through:

```pascal
Client.SendMessage('PCB:Zoom', 'Action=Selected', 255, Client.CurrentView);
```

The installed `C:\Program Files\Altium\AD26\System\AdvPcb.rcs:189` defines
`PCB:Zoom`, parameter `Action= Selected`, as **Fit Selected Objects**. This
process changes the view only. The combined wrapper changes selection and view;
it does not route, change geometry/rules, or save the PCB.

On 2026-09-30, the live wrapper completed export, exact allowlisted selection,
and zoom to the UART2/4 group after the 03:24:12 inventory checkpoint. Its inventory
describes the board before the next selection. Require fresh expected tables
and `inventory-status.txt` containing `complete`, then independently inspect
the selected group and view. These are sequential calls, not a transaction;
a selection dialog alone does not prove export success. If an inner routine
refuses or errors, do not continue to routing.

Choose this exact startup procedure when using F9; an earlier startup choice
can otherwise remain active. The existing full-path guard and net-list
validation still apply. Rejection paths are not qualified by the successful
UART2/4 operation.

## Select source pads for interactive multi-routing

Create `runs/full-routing-2026-09-30/current-inspection/select-pads.tsv` with the
exact, tab-separated header `refdes`, `pad`, `net`, followed by 1-50 rows. Each row identifies one
source pad by its component designator, pad name, and expected net name. Use
one source pad per net. All fields are case-sensitive; blank rows, comments,
extra columns, duplicate pads or nets, and surrounding whitespace are rejected.
Use the exported `pads.tsv` to choose exact names and inspect the intended ends.

Activate the guarded working PCB and run `SelectAllowlistedSourcePads` from
`TrialInventory.PrjScr`. It resolves every requested pad before changing
selection. Missing pads, multiple pads with the same designator/name, pads
without nets, and net mismatches leave selection unchanged. It then uses the
existing deselection pass and selects only the validated source pads; it does
not select their connection lines or destination pads.

`selected-source-pads.tsv` records the resulting pads, nets, physical layers,
raw coordinates, and each pad's selected flag. A success dialog reports the
count. A rejected request does not replace a previous audit; check the current
dialog and file modification time. After validation, the script writes a header
before selection so a later failure cannot leave an old successful audit.

The deselection pass uses the existing `AllLayers` filter, which omits some
extended mechanical layers. Use native **Edit > DeSelect > All** first, then
inspect the whole-canvas selection manually before
starting **Route > Interactive Multi-Routing**; the reported pad count does not
prove that omitted mechanical objects are deselected. Select the intended copper
layer and confirm the source pads in a fresh view. The helper changes selection
only and does not start routing, edit geometry or rules, create classes, or save.

At 2026-09-30 02:58:49 UTC, the procedure passed a live one-pad test: it selected
and audited exactly D1-C on `NetD1_C`, without geometry changes. Its rejection
paths and a completed Interactive Multi-Routing operation remain unqualified.
The one-pad success does not prove a larger group has the intended layer,
selection, or route result.

## Explicit single-via trial

`TrialVia.PrjScr` exposes `TrialVia.pas > AddExplicitTrialVia`. The bounded live
trial added the explicit `NetD1_C` via at
raw `(131936400, 99451500)`, diameter 160000, hole 80000, spanning IDs 1-32;
the total increased from 372 to 373 vias. Native Undo and a fresh inventory
restored 372 vias with zero geometry difference from the starting checkpoint;
native Redo restored the via. The final saved/reopened inventory also contains
that via. This qualifies the measured add/Undo/Redo sequence for this exact
trial, not every input or rejection path.

It adds one via at supplied coordinates; it does not search for a route
or valid location, connect tracks, invoke a routing engine, or save the PCB.

Input is `runs/current-inspection/add-via.tsv`: exactly one header and one data
row, with these six tab-separated columns:

```text
net	x_raw	y_raw	size_raw	hole_size_raw	expected_via_count
```

The net must exactly match one existing net on the full-path-guarded active
trial PCB. Coordinates and dimensions use raw Altium internal units, not user
origin coordinates or mils. Numeric fields accept decimal digits only within
the nonnegative signed 32-bit range; coordinates and dimensions must be positive,
the hole smaller than the diameter, and the expected count must permit adding
one. The expected count is the total board via count in the same legacy iterator
scope as the inventory. Verify it immediately before constructing the request.

The helper validates the request before mutation and rejects a center already
occupied by a pad or via. That exact-center test does not check copper clearance,
overlap, board bounds, mechanical constraints, or electrical suitability.
The specified position and dimensions need independent inspection. The new via
is fixed to Top–Bottom, layer IDs 1–32, and the requested existing net.

The implementation uses `PreProcess`/`PostProcess` and object registration,
then checks the via count and readback properties. The live Undo qualification
above depends on native Undo plus the independent inventory comparison.
`trial-via-audit.tsv` records the request and result;
`trial-via-status.txt` records the last stage. Even
`added_readback_ok_drc_not_checked` does not establish DRC or route completion.
A failure after the add may leave a via on the board: inspect and recover from
the checkpoint rather than assume rollback or repeat the request blindly.

The first native DRC reported two shorts and two clearances between this via
and existing internal polygons. Native **Repour All** removed those four
findings; the final 04:12:08 DRC has no new clearance, short, or width findings
relative to baseline. Include native polygon updates in the via workflow and
verify the actual copper. The TSV geometry screen omits polygons and cannot
qualify clearance. These results do not turn the helper into a clearance
checker or pathfinder. See [final DRC evidence](../notes/FINAL_DRC.md).

## Fixed LED pad-to-via stub

`TrialVia.pas > ConnectTrialLedViaToPad` adds one explicit vertical Top track
from D1-C at raw `(131936400, 99951500)` to the chosen `NetD1_C` via at
`(131936400, 99451500)`. It is 50 mil long and 4.1 mil wide. Guards require
the exact active trial, unique pad/net/via, 373 total vias, the expected pad and
via attributes, and no existing `NetD1_C` track. It runs no routing or save
command.

The live invocation added exactly that segment: inventory track count increased
from 2905 to 2906, via count stayed 373, and remaining connection objects
decreased to 837. Altium normalized endpoint order to
`(131936400, 99451500)` then `(131936400, 99951500)`. The original readback
guard rejected that reversed order even though the independent export confirmed
the intended geometry. Do not repeat the add after this readback error.

The revised guard accepts either order of those identical endpoints and writes
the actual endpoint order, width, layer, net, and counts to `led-stub-audit.tsv`.
That code correction has **not been rerun**. The initial pending audit row
describes the request; after adding the object it is replaced with actual
readback values and `added_pending_validation`, then the successful result is
`added_readback_ok_drc_not_checked`. Neither status establishes native DRC,
Undo, full-net completion, or persistence after reopening.

The actual added stub was independently verified by export and retained through
the final save/close/reopen. A free same-net via alone produced zero ActiveRoute
geometry. After the stub connected D1-C to the via, Bottom ActiveRoute completed
`NetD1_C`. Its connectivity survived reopening, and the repaired native DRC
contains no new clearance/short/width findings. These measured board results
do not qualify the revised readback branch, which was not rerun because the
existing-track guard correctly prevents adding another stub.

## Select the exact trial DRC-failure segment

`TrialVia.pas > SelectTrialDrcFailureTracks` requires the exact active trial and
exactly one `PMIC_NINT` Top track, width 41000, with raw endpoints
`(124701782, 91731029)` and `(124785100, 91834000)` in either order. It leaves
selection unchanged if the full-path or exact-match guard fails. After a match,
it uses the known legacy deselection pass and selects that one track. It does
not delete, change geometry, or save.

Run native **Edit > DeSelect > All** before the selector because `AllLayers`
omits some extended mechanical objects. **Ctrl+D opens View Configuration in
this session; it is not Deselect All.** Inspect selection before any native
edit.

The live sequence used native Deselect All, received `Selected 1` from the
guarded selector, then used native Delete. The deletion removed only the
offending new segment; both baseline `PMIC_NINT` CPU escape segments remain.
The repaired DRC removed its two clearances and exposed the retained partial
track's incomplete connection and antenna. The final saved/reopened export has
2,909 legacy track objects, 373 vias, and 837 remaining connection objects.
The deleted segment no longer matches, so repeating the selector should refuse;
that rejection path was not live-tested.

## API sources and qualification

The APIs come from Altium's [PCB design-object reference](https://www.altium.com/documentation/altium-dxp-developer/pcb-api-design-objects-interfaces-reference)
(`IPCB_Primitive`, `IPCB_Pad`, `IPCB_Track`, `IPCB_Via`, `IPCB_Connection`,
`IPCB_Net`, and `IPCB_Rule`), [system interfaces](https://www.altium.com/documentation/altium-dxp-developer/pcb-api-system-interfaces-reference)
(`GetCurrentPCBBoard`, `GetPCBBoardByPath`, `FileName`, and board iterators), [types](https://www.altium.com/documentation/altium-dxp-developer/pcb-api-types-reference),
and [constants and conversions](https://www.altium.com/documentation/altium-nexus/pcb-api-constants-and-functions?version=3.0).
Selection uses the documented `Selected` property. UI steps follow
[Running Scripts](https://www.altium.com/documentation/altium-designer/scripting/running-scripts).

Altium's legacy references describe these APIs, but their availability and
behavior must be tested in the installed Altium Designer 26.10.1 session.
The probe and complete inventory ran successfully in Altium 26.10.1 on
2026-09-30. The first formatter failed at `StringReplace`; the indexed-character
formatter passed. The export reported 321 nets, 1,593 pads, 2,825 track segments,
372 vias, 857 nonredundant connection objects, and 78 rules. All 321 net
connectivity-invalid flags were true. Native Board Information subsequently
confirmed 857 remaining connections. Baseline batch DRC reported 869 unrouted
findings: 857 net connections and 12 pieces of unassigned dead copper. Keep
these two measures separate. See the
[larger trial record](../notes/ROUTING_50_TRIAL.md).

The net-selection routine ran from the active trial PCB at 02:09 UTC with
`NetD1_A` and `NetD1_C`. It selected exactly six primitives: four pads and two
connections. Empty, unknown-name, and wrong-active-board rejection paths have
not been exercised in the live session.

## Compare saved inventories and native DRC reports

`TrialInventory.SelectConnectionsAndExport` selects only nonredundant airwires
from the existing net allowlist, exports their exact selection, and zooms the
selection. Copper and pad selection remain off. The PDM_DATA0 qualification
selected one airwire and changed no geometry; ActiveRoute still produced no
path on L3, so this selector is not a routing workaround.

`FullPolygon` accepts exact reviewed power and ground outlines through a fixed
whitelist with insertion-count guards. It preserves earlier definitions and
factory neck and island settings. The full-run additions use L5 VDD_3V3,
NVCC_DRAM_1V1 and VSYS_5V, L6 SOC/DRAM/ARM/VDD_1V8, and Bottom GND;
native repour remains separate. The VSYS_5V rectangle adds the eighteenth
polygon and preserves all seventeen earlier definitions.

`FullVia.RepairEthernetAccessVia` moves only the reviewed ENET_RX_CTL via from
raw `(135168400, 91511100)` to `(135088400, 91451100)`, requiring 583 vias and
the exact old 16/8 mil Top–Bottom identity. It uses the qualified track helper's
modification notifications and changes only X/Y. Batch 041 verifies the exact
move plus two lead edits. Native DRC removed both added keepout findings.
The move has not independently qualified Undo. Global native Keep-Out layer
56 must be included in offline geometry screens.

For bounded full-board copper edits, see [FullTracks qualification](../notes/FULL_TRACKS_HELPER.md)
and [FullVia qualification](../notes/FULL_VIA_HELPER.md). They validate exact
requests against the active working PCB and write per-row audit files. Native
DRC, timing, saved-state checks, and electrical review remain separate. Wait
for a fresh terminal helper status before issuing another native command.
[Track reconciliation](../notes/TRACK_REQUEST_RECONCILIATION.md) checks the
whole exported track multiset against an explicit request.

`compare_routing.py` reads complete saved exports without calling Altium. Use
immutable baseline and batch directories, not an output directory while the
controller is exporting into it. It requires `inventory-status.txt` to contain
`complete`, exact table headers, and counts consistent with `board.tsv`. The
JSON records source paths, byte lengths, SHA-256 hashes, and modification times.
This identifies the files read; it does not establish when Altium saved the PCB.

From `astra-run/`, load the environment with `. .\quickstart\enter.ps1`.
For a new run, first preserve complete local before/after exports with their
corresponding native DRC files. Set the paths below to those actual directories;
`before/` and `after/` are operator-created snapshot names, not supplied files.
Each inventory must retain its original absolute Windows board identity and
match its own DRC report. Create the output parent directory before comparing:

```powershell
$AstraRun = '<local-run-id>'
$Before = ".\runs\$AstraRun\before"
$After = ".\runs\$AstraRun\after"
$Quality = ".\runs\$AstraRun\quality"
New-Item -ItemType Directory -Path $Quality -Force | Out-Null
uv run --locked --project .\quickstart python .\scripts\compare_routing.py $Before $After `
    --baseline-drc "$Before\design-rule-check.drc" `
    --current-drc "$After\design-rule-check.drc" `
    --output "$Quality\comparison-001.json"
```

The original `results/setup-trial-2026-09-30/` package is omitted. Published
inventory copies under `../astra-output/evidence/` have redacted
`recorded-workspace` board paths and do not pass this tool's absolute-board-path
validation unchanged. Preserve those evidence copies; do not rewrite their
identities to make this example pass. Their historical comparison results are
records of the original exports, not a current rerun of the public copies.

Choose a new output filename for each comparison; existing files are refused.
Omit both DRC options for fast inventory-only checks between native DRC
milestones. Without `--output`, the full JSON goes to standard output. Source
text defaults to UTF-8 with optional BOM; `--encoding` accepts an explicit
encoding when a different native export requires it. Decode errors are not
ignored.

For full-run batches, supply the exact saved export directories and add
`--expected-board` with the full working PCB path. `--allowed-nets` accepts a
file of exact names, one per line, with blank lines and `#` comments allowed.
It rejects unknown names, duplicates, and surrounding whitespace. Changes to
any other net produce a regression flag. Without this option, the JSON still
lists every net whose geometry or remaining-edge count changed.

The comparison preserves duplicate objects and findings. Track endpoints are
undirected; reversing the two endpoints does not create a false geometry
change. Selection flags do not count as geometry. Pad records, net names/pin
counts, rule records, origin, and units are treated as immutable. The output
lists all added/removed track and via records, per-net remaining-edge changes,
and newly complete nets separately. Coordinates retain raw Altium units; the
reported `internal_units_per_mil` defines conversion.

Optional DRC comparison preserves each full rule/finding string and its
multiplicity, verifies every native subtotal and total, and compares the
processed rule sets. Each DRC board path must match its corresponding inventory.
All new and removed findings appear in the JSON, including findings that do
not trigger an automatic regression flag.

Exit codes:

- `0`: comparison completed with no implemented regression flag.
- `1`: comparison completed with changed immutable records, removed/modified
  baseline tracks or vias, an increased per-net edge count, changes outside the
  allowed net set, changed DRC processed rules/waiver counts, or new native
  clearance, short, width, hole, or via findings.
- `2`: invalid/incomplete input, wrong board identity, unreadable file, or an
  output failure. Inspect the error before relying on a result.

An exit code of zero is not electrical acceptance. All native findings still
need review. The legacy inventory omits some mechanical objects and does not
model polygons, arcs, pad stacks, stackup, or reference continuity. Pad records
are only a component-placement proxy. The tool does not evaluate rule priority,
online DRC settings, route quality, impedance, timing, or saved/reopened state.

The original preserved-trial comparison completed in 0.28 seconds including the
`uv` launcher. It reproduced 20 fewer remaining edges, 18 newly complete nets, 84
added tracks, one added via, zero removed baseline tracks/vias, and the exact
DRC delta of three added and 23 removed findings. It preserved the three known
new non-clearance/short/width findings for review. See
[quality evidence](../notes/FULL_RUN_QUALITY.md).

From `astra-run/`, after loading the isolated environment, the existing focused
tests cover reversed endpoints, duplicate occurrences, case-sensitive
net names, redundant/broken connection modes, changed pad/rule records despite
equal counts, truncated/inconsistent native reports, and read-only inventory
count validation:

```powershell
uv run --locked --project .\quickstart python -m unittest discover -s .\scripts -p 'test_compare_routing.py' -v
```

## Remove explicitly identified tracks

`FullTrackRemove.PrjScr > RemoveExplicitFullTracks` removes at most 128 exact
Top, L3, or Bottom tracks from the guarded full-run working PCB. It does not
save the PCB or run UI commands. A saved checkpoint must precede removal;
each target must be proven absent from the original input copper.

Create `runs/full-routing-2026-09-30/quality/full-track-remove/` and supply
`remove-tracks.tsv` with exactly this tab-separated header:

```text
net	x1_raw	y1_raw	x2_raw	y2_raw	width_raw	layer_id	expected_track_count
```

All rows use the same complete before-inventory track count. Coordinates and
width are unsigned raw integers; this board uses 10,000 units per mil. Net
names must match exactly. Endpoint direction does not matter. Empty names,
duplicate targets, invalid dimensions, stale counts, missing nets, or targets
that resolve to zero or multiple tracks refuse the entire request before any
geometry mutation. The exported `layer` and `selected` display fields are not
request fields. A TSV copied from an inventory therefore needs an explicit
column conversion and a fresh count.

The helper collects all target references and destroys the iterator before
removal. Each row uses `RemovePCBObject`, the documented
`PCBM_BoardRegisteration` notification, and the same per-row
`PreProcess`/`PostProcess` transaction pattern as FullTracks. The notification
name is intentional for deletion; see Altium's
[RemovePCBObject reference](https://www.altium.com/documentation/altium-dxp-developer/pcb-api-system-interfaces-reference).
No object-destruction call is used. One final iterator confirms that every
requested target is absent and the total decreased by the requested row count.
Each row still checks the active board and its exact target before removal.

The final scan passed its native qualification in batch482: four exact
run-added tracks were removed, and the complete request comparison found no
unexpected copper changes. The two scoped inner-layer removals preserve ARM
and SAI2_TXFS through explicit replacement paths. ENET_RD3 L4 and SD2_DATA2
L5/L7 additions use their existing native width scopes; ExportWidth482 reads
the latter without changing rules. The exact U1-AC26 ENET_RD3 via exception
requires the recorded pad, net, position, and 16/8 mil dimensions.

The directory receives `full-track-remove-request.tsv`,
`full-track-remove-audit.tsv`, and `full-track-remove-status.txt`. Only
`removed_batch_readback_ok_drc_not_checked` is a completed batch. Each audit row
starts pending, changes to `removing_inspect_on_interruption`, and records the
verified full-batch after-count after the final scan. An exception after mutation starts records
`failed_exception_inspect_partial_changes` and propagates. An interrupted or
failed row may have changed copper even when `completed_readbacks` has not
increased. Preserve the audit and inspect a fresh inventory before recovery.

Single-track removal, native Undo, and Redo passed whole-board inventory checks
in Altium 26.10.1 on October 1. A stale count of 5,143 refused without mutation
at an actual count of 5,142. One exact run-added L3 I2C1_SDA segment was removed,
restored by Undo, and removed by Redo; all other tracks, vias, pads, rules, and
net assignments matched. Evidence is in batch 224's `removal-qualification/`.
A batch is not one Undo step; recover each completed
step individually or restore the saved checkpoint. Wait for a fresh terminal
status before issuing another native command. After execution, compare the
whole track multiset with `before minus requested tracks`, require every other
primitive table to remain unchanged, and run native repour, DRC, and endpoint
checks. Native DRC is deferred until routing ends in this run. The ordinary comparator continues to flag intentional removals and
temporary unrouted regressions; those flags must remain visible.

The VDD_3V3 supply repair allows add-only L4 tracks at exactly 20 mil.
`ExportWidth517` reads the existing dominant width rule for that net and layer.
The repair connects existing vias; native repour and the all-net comparison
must confirm supply continuity before accepting the combined USB and SAI work.

`checkpoint_storage.py` shares identical immutable History and library files
across saved checkpoints and result packages using NTFS hard links. Every
linked file must match its manifest size and SHA-256. It preserves all paths
and contents and excludes inputs, the working project, captures, and videos.
The original checkpoint and package scripts called its `copy_project` helper;
those orchestration scripts are omitted from this repository. Their historical
`storage-copy.json` receipts reported reused bytes. The included CLI compacts
existing local snapshots with manifests at
`runs/full-routing-2026-09-30/checkpoints/*/checkpoint.json` and
`results/*/manifest.json`, relative to `astra-run/`. It is not a general project
packager. Supply `--output` with a new audit receipt path under an existing run
quality directory; it does not create that receipt's parent directory.

SAI1_TXD2 allows add-only L2 and L5 tracks within its existing 3.2–10 mil
width range. Four exact run-added removal exceptions identify the PDM_DATA0,
PDM_DATA1, and SAI1_RXD5 tracks that its connected replacements preserve.

The UART3_RTS batch adds L5 copper within its native 3.2–10 mil width range.
Its three inner-layer removal exceptions identify only the two ECSPI2_SCLK
L6 tracks and one DRAMA_DATA5 L2 track by exact net, width, and endpoints.
Connected replacements preserve those nets and the affected UART3_RXD L3
track. Both new vias use 16/8 mil dimensions at reviewed offsets from pads.

GPIO1_IO05 uses its native L3 width scope. Two exact GPIO1_IO07 L5 removal
exceptions allow its connected replacement around the CPU transition. The
J5-62 via exception requires the matching GPIO1_IO05 net, Bottom pad center,
and 16/8 mil dimensions; fabrication acceptance remains pending.

`BTGroundAccess.pas` removes one exact inherited Ground via after its two
incident inherited tracks and five run-added tracks receive connected
replacements. Its preflight and three native stage comparisons passed in
batch582. The helper requires the exact board, counts, net, position, size,
hole size, and layer span. [BT_ACCESS_582.md](../notes/BT_ACCESS_582.md) records
the engineering reason and remaining current-capacity limits.

The TD2 and TD3 requests use existing native width rules and exact run-added
removal scopes. TD2 also trims one inherited free antenna, documented in
[ENET_TD2_ACCESS_586.md](../notes/ENET_TD2_ACCESS_586.md). Their L2 and L7 signal
paths remain provisional and require the final GND-layer cleanup. `ExportAWidth587` and
`ExportBWidth587` only read the existing SAI width rules.

## Final native DRC ledger

`summarize_final_drc.py BASELINE.drc FINAL.drc OUTPUT_DIRECTORY` preserves every
native rule/finding occurrence, validates subtotals and the report footer, and
writes complete TSV and Markdown ledgers. Exact multiset additions and removals
retain repeated findings; they are not automatically new or repaired physical
defects. From `astra-run/`, after loading `quickstart/enter.ps1`, invoke it as
`uv run --locked --project .\quickstart python .\scripts\summarize_final_drc.py BASELINE.drc FINAL.drc OUTPUT_DIRECTORY`.
Replace the three uppercase arguments with actual DRC paths and a fresh local
output directory under `runs/<run-id>/`; the tool creates that directory and
overwrites its named ledger files if reused. The stopped-run report and durable
evidence are linked from [FINAL_ROUTING_REPORT.md](../notes/FINAL_ROUTING_REPORT.md).

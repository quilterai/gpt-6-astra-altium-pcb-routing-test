# Final electrical findings — checkpoint 113

The saved PCB has 9,724 copper tracks and 995 vias. The final native DRC ran on October 2, 2026 at 18:37:36 UTC, reported 3,569 findings and zero waivers, and took eight seconds. The post-DRC inventory still contains 20 nonredundant connection edges. The 33 native unrouted findings are 21 named opens and 12 inherited unassigned-copper findings. SD2_DATA0 is the additional native open; final conservative completion is 1,088/1,109 connections and 300/321 named nets. Routing stopped before the conditional SD2_NCD proposal was applied.

All 68 DRAMA/DRAMB signal nets and the four reset/ZQ/calibration nets in this review have zero remaining native connection edges. **Their copper connectivity is complete; DDR electrical acceptance fails.** The final report contains four maximum-delay failures, 78 DDR matching failures, six QSPI/eMMC matching failures, and 59 differential-routing findings. Current capacity, reference continuity, impedance, fabrication, and timing have not been signed off.

Evidence: [native DRC](../final-validation/final-native.drc), [exact timing/coupling rows](final-electrical-timing-coupling.tsv), [supporting JSON](final-electrical-findings.json), and [per-net DDR layers/vias](final-ddr-layer-allocation.tsv). Source interpretations are preserved in [DDR_PLAN](../../../astra-run/notes/DDR_PLAN.md) and [CONSTRAINTS](../../../astra-run/notes/CONSTRAINTS.md). These source notes describe the original design; their earlier connectivity counts are historical.

## Native timing failures

The unchanged maximum is 200 ps for every DDR clock/strobe conductor. Four fail:

| Net | Native delay, ps | Excess over 200 ps |
|---|---:|---:|
| DRAMA_SDQS0_C | 226.278 | 26.278 |
| DRAMA_SDQS0_T | 346.467 | 146.467 |
| DRAMB_SDQS1_C | 259.953 | 59.953 |
| DRAMB_SDQS1_T | 228.962 | 28.962 |

The unchanged within-pair limit is 1 ps. DRAMA_SDQS0 fails at 120.189 ps, DRAMB_CK at 12.044 ps, DRAMB_SDQS0 at 2.419 ps, and DRAMB_SDQS1 at 30.991 ps. DRAMA_CK's reported conductor values differ by 0.329 ps and DRAMA_SDQS1's by 0.511 ps; those two have no final within-pair finding. This does not accept their coupling, reference, or impedance.

| Native matching group | Tolerance, ps | Findings | Range among reported delay values, ps | Reported spread, ps |
|---|---:|---:|---:|---:|
| DDR_CK_DQS, pair/group matching | 85 | 14 | 104.137–346.467 | 242.330 |
| DRAMA_CA | 25 | 11 | 110.641–375.330 | 264.689 |
| DRAMB_CA | 25 | 11 | 108.927–345.908 | 236.981 |
| DRAM_BYTE0: B data0–7/DMI0/SDQS0 | 10 | 9 | 98.863–246.080 | 147.217 |
| DRAM_BYTE1: B data8–15/DMI1/SDQS1 | 10 | 10 | 136.632–259.953 | 123.321 |
| DRAM_BYTE2: A data8–15/DMI1/SDQS1 | 10 | 10 | 88.043–147.384 | 59.341 |
| DRAM_BYTE3: A data0–7/DMI0/SDQS0 | 10 | 9 | 146.699–346.467 | 199.768 |
| DDR_CK_DQS, within-pair matching | 1 | 4 | See conductor differences above | — |
| QSPI | 100 | 4 | 158.263–528.858 | 370.595 |
| EMMC_SD3 | 100 | 2 | 0–155.055 | 155.055 |

These are ranges explicitly reported in violation rows, not a complete timing export. Native pair-to-pair differences reach 181.980 ps against the 85 ps tolerance. EMMC's 0 ps SD3_DATA4 and 3.322 ps SD3_DATA3 readings occur on incomplete nets and do not represent completed-path flight time. The supplied source-relative checks also require CA within 25 ps of its channel CK_T, DQS within 85 ps of CK_T, and DQ/DMI within 10 ps of the byte's DQS_T. They remain required in addition to native group matching.

CPU package delays are already included in the native calculation according to the preserved correlation and earlier native checks. Do not add them a second time. The original inner-layer impedance entries were disabled and had no usable propagation-speed calculation; native width allowance is not a measured inner-layer impedance or validated delay model. The final delay numbers are Altium's current output, with that physical-model limitation still unresolved. Copper length sums include branches/stubs and cannot establish timing acceptance.

## Differential coupling and widths

The 59 native differential-routing findings comprise **18 excessive uncoupled-length findings and 41 track-width findings**. All six DDR clock/strobe pairs exceed their 100 mil uncoupled limit:

| Pair | Uncoupled length, mil | Limit, mil |
|---|---:|---:|
| DRAMA_CK | 617.606 | 100 |
| DRAMA_SDQS0 | 1,087.627 | 100 |
| DRAMA_SDQS1 | 240.058 | 100 |
| DRAMB_CK | 574.081 | 100 |
| DRAMB_SDQS0 | 230.773 | 100 |
| DRAMB_SDQS1 | 1,251.274 | 100 |

Other reported uncoupled failures are USB1 at 1,324.037 mil versus 100, PCIe clock at 572.873 versus 100, PCIe TX at 311.104 versus 100, and nine CSI/DSI pairs at 185.116–1,629.994 versus 50. Incomplete complementary legs can affect those interface readings. The actual DDR/PCIe rule uses a 4.8 mil gap, outer width 4.2 mil and inner width 15 mil; USB uses 4.9 mil gap and outer width 3.6 mil. Final width findings include retained 3.0–3.5 mil fanout versus 4.2 mil targets and USB 3.0 versus 3.6. The differential category was absent from the baseline report, so its 59 newly reported findings do not prove 59 newly created physical defects. Retained fanout and new paths must be reviewed individually.

## Layer, transition, and fabrication debt

The preserved stack identifies L2/L4/L7 as Ground layers and L5/L6 as Power layers. Native RoutingLayers allows all eight; that allowance enabled provisional completion but does not satisfy the user's final layer assignment requirement.

| DDR copper layer | Segments | Sum of copper lengths, mil | DDR/calibration nets using layer |
|---|---:|---:|---:|
| Top | 460 | 14,294.161 | 72 |
| L2 Ground | 219 | 5,843.097 | 9 |
| L3 signal | 186 | 14,012.185 | 18 |
| L4 Ground | 0 | 0 | 0 |
| L5 Power | 46 | 1,924.524 | 4 |
| L6 Power | 210 | 8,208.873 | 13 |
| L7 Ground | 35 | 944.886 | 2 |
| Bottom | 190 | 8,298.266 | 24 |

No uniform DDR byte/control layer grouping was established. DDR signal segments on Ground and Power layers require cleanup and subsequent impedance/reference/timing review. A broader prefix-based inventory flags 707 ordinary signal segments on L2, 179 on L4, 389 on L7, 478 on L5 and 580 on L6; these are a triage list, not a reviewed net-class census.

Nine DDR nets contain more than two assigned signal vias: A_CA4=4, A_CA5=7, A_CK_T=3, A_SDQS0_C/T=4 each, B_CKE1=4, B_CK_C=3 and B_SDQS1_C/T=3 each. The preserved NXP requirement limits a signal path to two; assigned-via totals include branches/stubs, so this is an explicit path-audit requirement rather than proof every listed path traverses every via. Of 123 assigned DRAMA/DRAMB signal vias, 26 have no assigned GND via within 50 mil; the greatest nearest-GND distance is 146.487 mil. These planar distances do not prove reference copper contact or transition-current continuity. Global GND connectivity alone does not verify the return under a critical route.

Own-pad and offset-pad vias were accepted provisionally for geometric completion in several trials. Filled/capped construction, solderability, drill registration and assembly acceptance were not established. Preserve the exact per-batch pad/via exceptions for fabrication review.

## Power and routing lessons

Native repours repeatedly split supply islands after signal tracks/vias were added on Power layers. Short explicit connections restored measured connectivity, but did not establish supply impedance, noise or current capacity. A prefix-based inventory contains 288 supply track segments below 5 mil, totaling 17,279.298 mil of copper; this includes retained copper and long provisional paths, not only short new necks. Review each rail's load and parallel current paths before fabrication. Existing POWER width permission down to 3 mil is a geometric rule bound, not a current rating.

The useful routing improvements were connected-copper reanchoring, compiled component/BFS searches, explicit cross-layer transition graphs, and complete neighbor-preserving local replacements. Single-layer failure did not prove multilayer impossibility; pad-center-only seeds and coarse grids also produced false negatives. Every delivered replacement needed exact raw-coordinate checks, duplicate/existing-row preflight and preservation of midsegment contacts. Supply source-bank identity and actual native repour results were more reliable than raster island assumptions. The DATA2 contact episode also required native connectivity cleanup despite geometric overlap.

The final priority is electrical correction rather than more completion-only insertion: correct physical DRC defects, restore intended signal/reference layer use, verify actual impedance and return paths, and then tune native package-plus-board delays and pair coupling. No DDR timing pass, fabrication release, or power-capacity acceptance is claimed here.

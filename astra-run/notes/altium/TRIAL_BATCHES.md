# Proposed 50-connection trial worksheet

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

**Proposal with progress noted at 2026-09-30 03:19 UTC:** five connections are
saved: `NetD1_A` and the four B2 PMIC controls (`NetR51_2`, `NetR52_2`,
`NetR48_2`, `NetR54_2`). Four more connections have visual results awaiting
inventory and save verification; do not count them as complete yet. ActiveRoute
is installed and has completed the saved B2 group. The tables below retain the
original proposal; they are not a completion ledger or DRC acceptance record.
See [trial evidence](../ROUTING_50_TRIAL.md) for verified results and
[additional candidates](ADDITIONAL_TRIAL_CANDIDATES.md) for nets that can use
existing layer access without adding vias.

## Evidence and scope

The original runtime paths below are relative to `astra-run/`.
Source: `runs/current-inspection/` export dated **2026-09-30 02:58:08 UTC**, for
`trials/routing-50-2026-09-30/QCMI_SOM8MM/IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc`.
The export has 856 remaining connection objects, 2,827 track segments, and
372 vias. Each proposed net below has exactly two pads and one nonredundant
ratsnest connection. `NetD1_A` has no remaining connection object. The native
baseline was 857 remaining; see [trial evidence](../ROUTING_50_TRIAL.md).

Sources are pads (historical record; not included),
connections (historical record; not included),
tracks (historical record; not included),
vias (historical record; not included), and
rules (historical record; not included). This directory is overwritten
by later exports; preserve a batch snapshot before editing. The export reports
connectivity-invalid flags, so these counts are not a replacement for native
connectivity refresh and reports.

Only **Interactive Routing**, **Interactive Multi-Routing**, and **ActiveRoute**
are allowed. Situs and every Auto Route scope are prohibited, through UI or
scripts. Follow the [routing tool limits and qualification notes](ROUTING.md).

The set excludes DDR, eMMC/SD data and clocks, QSPI, ECSPI, Ethernet data/clocks,
USB data pairs, PCIe, MIPI data pairs, and audio clocks/data whose constraints
remain unreviewed. Schematic pin records exposed three unsuitable unnamed
candidates: `NetR7_2` reaches U1-P2 `DRAM_ZN`, `NetC245_1` reaches U1-R22
`NAND_DQS`, and `NetC268_1` reaches U1-D15 `MIPI_VREG_CAP`; they are excluded.
These pin names come from
[06-CPUCTL QCMI SOM.SchDoc](<../../../speedrun-input/06-CPUCTL QCMI SOM.SchDoc>).
Exclusion does not establish that the remaining nets have no electrical
constraints. GPIO alternate functions, debug speed, width, and return paths
still require review.

## How to read the worksheet

- **T** = Top Layer, legacy layer ID 1; **B** = Bottom Layer, ID 32. These are
  physical layer identities, not an assumption about the PCB's custom names.
- **Span / gap** are straight-line millimeters: pad center to pad center / the
  exported ratsnest endpoints. Neither is a proposed or measured routed length.
  N = near, under 5 mm; M = medium, 5 through 15 mm; F = far, over 15 mm, using
  the pad span. Internal distances use 10,000 units per mil and 0.0254 mm per mil.
- The first pad is the **proposed source pad**, not an electrical direction.
  Sources within each multi-route candidate group share a surface layer.
- **V01–V19** each mean one existing through via on that net. The coordinate
  appendix identifies it. An exact endpoint chain of exported Top tracks links
  the named U1 pad to that via. This establishes geometric access in the export,
  not clearance, usable routing space, or post-route electrical verification.
- **T stub** means existing Top tracks and no via. **None** means no exported
  tracks or vias on that net. There are 20 opposite-surface candidates with no
  existing via; plan and inspect their layer transition before group completion.
  ActiveRoute adds no vias and cannot supply that missing access.

## Batch order and purpose

Batch sizes are 2–6 connections. Start with B1–B3, then B13 to qualify a short
layer change, then B4/B5 before the longest group B6. B7–B12 depend on that
control qualification. A batch is an inspection/checkpoint unit; it does not
require routing every member in one gesture.

| Batch | Count | Proposed method and quality question |
|---|---:|---|
| B1 | 4 | Top PMIC controls. Guide from U8-6/8/9/12 toward the left-side resistors; split into pairs if intervening pins or destination order complicate the group. Compare a manual connection with multi-routing. |
| B2 | 4 | Top U8-39/40/41/42 are adjacent pads: PMIC_ON_REQ, PMIC_STBY_REQ, SCL, SDA. Strong small multi-route candidate; preserve orderly exits and finish each resistor pad deliberately. ActiveRoute is also a candidate on Top. |
| B3 | 3 | Short Bottom resistor-to-CPU-fanout connections. Try ActiveRoute on the exact connections after extension qualification, or route individually. Inspect small pad entries; proximity alone does not guarantee clearance. |
| B4 | 4 | Adjacent J4-36/38/40/42 sources on Bottom, all with CPU through-via access. Good longer multi-route/ActiveRoute comparison; inspect destination fanout order before sharing a corridor. |
| B5 | 6 | J5 Bottom sources and two CPU fanout columns. Split IO10–12 and IO13–15 into two triples if needed. Test an orderly corridor without forcing crossings between destination columns. |
| B6 | 4 | UART1 from J8 Bottom across 28–31 mm to existing CPU vias. Reserve a deliberate corridor and compare detour, corners, and new vias with the shorter groups. Do not cross the CPU/DDR region merely to shorten the path. |
| B7 | 5 | GPIO05–09 from J5 Bottom; three have Top escape stubs, none has a via. Add suitable access interactively and preserve those stubs before considering Bottom group completion. |
| B8 | 4 | UART3 J4 Bottom group. RXD already has via access; CTS/RTS/TXD do not. Complete RXD separately or qualify the missing three transitions before treating it as one group. |
| B9 | 4 | JTAG J4 Bottom group. No vias exist; TDO has Top tracks. Use deliberate layer transitions and simple paths. Debug timing and the omitted TCK path still require design review. |
| B10 | 4 | Wake signals from J8-1/2/3/4 Bottom. Sources occupy both connector pad rows, so split BT and WL pairs if exits diverge. No vias exist; two nets have Top stubs. |
| B11 | 2 | WDOG_B and PMIC_NINT from adjacent CPU-edge Top pads. Long same-side manual or multi-route experiment; destinations diverge, so inspect branching paths and preserve the PMIC_NINT stub. |
| B12 | 3 | Independent reset/status controls, routed individually. PMIC_STBY_REQ has existing CPU fanout; SYS_NRST and NetD1_C need a layer transition. This is a checkpoint group, not one multi-route group. |
| B13 | 2 | Independent short JTAG_MOD and TEST_MODE layer-change trials. Both lack vias. Use individual routing to qualify via placement and endpoint confirmation before larger opposite-side groups. |

The U8 pin functions above come from the U8 `PCA9450_HVQFN56P_A` pin records in
[09-PMIC QCMI SOM.SchDoc](<../../../speedrun-input/09-PMIC QCMI SOM.SchDoc>).
They identify these four nets as controls rather than PMIC switching nodes.

## Exact proposed endpoints

| Batch | Net | Proposed source → target | Span / gap (mm) | Existing access |
|---|---|---|---|---|
| B1 | `NetR127_2` | U8-8 T → R127-2 T | N 4.40 / 4.40 | None |
| B1 | `NetR114_1` | U8-9 T → R114-1 T | N 4.23 / 4.23 | None |
| B1 | `NetR111_1` | U8-6 T → R111-1 T | N 4.82 / 4.82 | None |
| B1 | `NetR146_2` | U8-12 T → R146-2 T | N 3.21 / 3.21 | None |
| B2 | `NetR51_2` | U8-39 T → R51-2 T | M 5.20 / 5.20 | None |
| B2 | `NetR52_2` | U8-40 T → R52-2 T | M 5.74 / 5.74 | None |
| B2 | `NetR48_2` | U8-41 T → R48-2 T | M 6.41 / 6.41 | None |
| B2 | `NetR54_2` | U8-42 T → R54-2 T | M 5.45 / 5.45 | None |
| B3 | `NetR109_1` | R109-1 B → U1-F23 T | N 0.77 / 0.97 | V01 |
| B3 | `NetR108_1` | R108-1 B → U1-F22 T | N 1.33 / 1.80 | V02 |
| B3 | `TS_RES_EXT` | R103-1 B → U1-J24 T | N 1.62 / 1.62 | V03 |
| B4 | `UART2_RXD` | J4-36 B → U1-F15 T | F 16.64 / 16.79 | V04 |
| B4 | `UART2_TXD` | J4-38 B → U1-E15 T | F 16.07 / 16.16 | V05 |
| B4 | `UART4_RXD` | J4-40 B → U1-F19 T | F 16.94 / 17.13 | V06 |
| B4 | `UART4_TXD` | J4-42 B → U1-F18 T | F 16.71 / 16.66 | V07 |
| B5 | `GPIO1_IO10` | J5-50 B → U1-AD10 T | F 20.91 / 20.63 | V08 |
| B5 | `GPIO1_IO11` | J5-46 B → U1-AC10 T | F 20.98 / 20.76 | V09 |
| B5 | `GPIO1_IO12` | J5-44 B → U1-AB10 T | F 21.26 / 21.09 | V10 |
| B5 | `GPIO1_IO13` | J5-42 B → U1-AD9 T | F 20.40 / 20.57 | V11 |
| B5 | `GPIO1_IO14` | J5-40 B → U1-AC9 T | F 20.68 / 20.90 | V12 |
| B5 | `GPIO1_IO15` | J5-38 B → U1-AB9 T | F 20.98 / 21.22 | V13 |
| B6 | `UART1_CTS` | J8-5 B → U1-E18 T | F 28.26 / 28.26 | V14 |
| B6 | `UART1_RTS` | J8-13 B → U1-D18 T | F 29.58 / 29.58 | V15 |
| B6 | `UART1_TXD` | J8-7 B → U1-F13 T | F 30.24 / 30.59 | V16 |
| B6 | `UART1_RXD` | J8-11 B → U1-E14 T | F 30.58 / 30.87 | V17 |
| B7 | `GPIO1_IO05` | J5-62 B → U1-AF12 T | F 20.79 / 20.24 | T stub; 0 vias |
| B7 | `GPIO1_IO06` | J5-58 B → U1-AG11 T | F 20.21 / 20.21 | None |
| B7 | `GPIO1_IO07` | J5-56 B → U1-AF11 T | F 20.41 / 19.85 | T stub; 0 vias |
| B7 | `GPIO1_IO08` | J5-54 B → U1-AG10 T | F 20.04 / 20.04 | None |
| B7 | `GPIO1_IO09` | J5-52 B → U1-AF10 T | F 20.25 / 19.69 | T stub; 0 vias |
| B8 | `UART3_CTS` | J4-10 B → U1-A7 T | M 14.55 / 14.55 | None |
| B8 | `UART3_RTS` | J4-2 B → U1-B6 T | F 15.41 / 15.05 | T stub; 0 vias |
| B8 | `UART3_TXD` | J4-6 B → U1-B7 T | F 15.30 / 14.93 | T stub; 0 vias |
| B8 | `UART3_RXD` | J4-4 B → U1-D6 T | F 16.20 / 16.31 | V18 |
| B9 | `JTAG_TDI` | J4-54 B → U1-E27 T | F 16.84 / 16.84 | None |
| B9 | `JTAG_TDO` | J4-52 B → U1-E26 T | F 16.81 / 16.81 | T stub; 0 vias |
| B9 | `JTAG_TMS` | J4-58 B → U1-F27 T | F 17.05 / 17.05 | None |
| B9 | `JTAG_NTRST` | J4-60 B → U1-C27 T | F 15.50 / 15.50 | None |
| B10 | `BT_WAKE_HOST` | J8-3 B → U1-W27 T | F 20.46 / 20.46 | None |
| B10 | `BT_WAKE_DEV` | J8-1 B → U1-U26 T | F 21.18 / 20.62 | T stub; 0 vias |
| B10 | `WL_WAKE_HOST` | J8-4 B → U1-W26 T | F 18.23 / 17.67 | T stub; 0 vias |
| B10 | `WL_WAKE_DEV` | J8-2 B → U1-U27 T | F 18.14 / 18.14 | None |
| B11 | `WDOG_B` | U1-AG13 T → R55-1 T | F 19.63 / 19.63 | None |
| B11 | `PMIC_NINT` | U1-AF13 T → U8-13 T | F 21.80 / 21.66 | T stub; 0 vias |
| B12 | `PMIC_STBY_REQ` | R52-1 T → U1-E24 T | F 19.59 / 19.31 | V19 |
| B12 | `SYS_NRST` | R127-1 T → J5-39 B | F 28.13 / 28.13 | None |
| B12 | `NetD1_C` | D1-C T → Q1-3 B | M 13.20 / 13.20 | None |
| B13 | `JTAG_MOD` | R23-1 B → U1-D27 T | N 1.51 / 1.51 | None |
| B13 | `TEST_MODE` | J4-56 B → R134-2 T | M 5.79 / 5.79 | None |

Already recorded complete, outside those 49 rows: **`NetD1_A`, D1-A T → R125-2 T**,
about 1.52 mm of new copper in two segments, no new vias. Its pad span is
1.51 mm. Use the [recorded checkpoint](../ROUTING_50_TRIAL.md#batch-1-short-manual-connection)
for persistence and DRC qualification state; do not count it again.

## Existing fanout access

Coordinates are mils relative to the exported board origin
`(115633500, 82894100)` internal units. Every listed via spans layer IDs 1–32
and has 16 mil diameter / 8 mil hole. These are **existing dimensions**, not
approval of a new via size. All 19 pad-to-via chains were checked by matching
exact track endpoint coordinates on Top. The ratsnest's endpoint layer can
still show Top at a through via; inspect the via span rather than treating
that field as proof of a missing Bottom connection.

| Via | Net / CPU pad | X (mil) | Y (mil) |
|---|---|---:|---:|
| V01 | `NetR109_1` / U1-F23 | 1102.90 | 1289.55 |
| V02 | `NetR108_1` / U1-F22 | 1080.89 | 1288.90 |
| V03 | `TS_RES_EXT` / U1-J24 | 1125.70 | 1265.97 |
| V04 | `UART2_RXD` / U1-F15 | 963.76 | 1305.91 |
| V05 | `UART2_TXD` / U1-E15 | 963.58 | 1327.62 |
| V06 | `UART4_RXD` / U1-F19 | 1043.00 | 1305.66 |
| V07 | `UART4_TXD` / U1-F18 | 985.59 | 1305.39 |
| V08 | `GPIO1_IO10` / U1-AD10 | 864.82 | 950.58 |
| V09 | `GPIO1_IO11` / U1-AC10 | 865.33 | 972.28 |
| V10 | `GPIO1_IO12` / U1-AB10 | 865.50 | 993.98 |
| V11 | `GPIO1_IO13` / U1-AD9 | 808.50 | 951.18 |
| V12 | `GPIO1_IO14` / U1-AC9 | 808.37 | 973.50 |
| V13 | `GPIO1_IO15` / U1-AB9 | 808.77 | 995.22 |
| V14 | `UART1_CTS` / U1-E18 | 985.28 | 1327.22 |
| V15 | `UART1_RTS` / U1-D18 | 985.67 | 1348.92 |
| V16 | `UART1_TXD` / U1-F13 | 886.83 | 1304.74 |
| V17 | `UART1_RXD` / U1-E14 | 924.89 | 1345.62 |
| V18 | `UART3_RXD` / U1-D6 | 785.61 | 1349.13 |
| V19 | `PMIC_STBY_REQ` / U1-E24 | 1101.58 | 1326.51 |

## Acceptance for each batch

1. Confirm the exact trial document, intended net/pad selection, active copper
   layer, rule-derived width, and destination access. Existing 3 mil or 10 mil
   fanout tracks and the prior 4.1 mil trial do not choose a width for this batch.
   The exported 50-ohm non-power rule remains relevant.
2. Inspect both ends and the whole proposed corridor. Prefer simple paths,
   orderly pad exits, few justified vias, and room for adjacent nets. A source
   group with crossing destination order should be split, not forced into a bus.
3. Record the source checkpoint, exact endpoint pairs completed, unresolved
   endpoints, tool/layers, new track length and via count, and any replaced or
   damaged existing copper. Count a pair only after connectivity establishes it.
4. Refresh native connectivity and compare Board Information plus relevant DRC
   categories with the preserved baseline. Review new violations individually;
   a large pre-existing violation total does not excuse a new short or clearance
   failure. Inspect the entire path at useful scale, then save and reopen.

If all 49 proposed pairs complete without other connectivity changes, the
remaining count would decrease from **856 to 807**, giving 50 total new trial
connections including `NetD1_A`. That arithmetic is a cross-check, not acceptance
evidence. Reject a poor path even if the connection count decreases.

# Additional trial candidates

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

Prepared 2026-09-30 from the `runs/current-inspection/` export written at
03:10:44 UTC. These 21 proposed nets have 34 remaining connection objects in
that export. They supplement the original [trial worksheet](TRIAL_BATCHES.md)
when a net requires a new via and interactive via insertion is not qualified.
They are not completed work or evidence of clearance, routing space, electrical
constraints, or DRC acceptance.

The earlier candidate set comprised five saved nets plus 21 proposed nets in
B1, B3, B4, B5, and B6. Adding all 21 nets here would give 47 distinct nets and
60 new endpoint connections if every connection completes. Counts of nets,
endpoint connections, and track segments are different. Do not describe 50
completed endpoint connections as 50 fully routed nets.

The original 26-net set plus C1/C2 and C3-C6 below could give 50 endpoint
connections across 42 distinct nets. Reaching 50 distinct nets still needs
three additional candidates and deliberate layer access. Do not add unreviewed
DDR, synchronous data, clock, or analog reference nets just to meet a count.

## Sources and interpretation

Geometry comes from pads (historical record; not included),
tracks (historical record; not included),
vias (historical record; not included), and
connections (historical record; not included). These files are
overwritten by later exports; preserve a snapshot for any executed batch.

- T means Top Layer, legacy ID 1; B means Bottom Layer, legacy ID 32.
- Span is the greatest straight-line distance between pad centers on the net,
  in millimeters. It is not routed length or a prescribed topology.
- Each via reference means an exact track-endpoint chain on Top connects the
  named U1 pad to that existing through via. All listed vias span IDs 1-32.
  This establishes geometric access only, not electrical or clearance approval.
- Every two-pad net below has one remaining connection. Every three-pad net
  has two remaining connections. Complete all endpoints before counting a net
  as fully connected.
- Groups contain two to four nets for inspection and checkpoints. They do not
  require one simultaneous routing action.

## Proposed groups

| Group | Net | Exact pads | Span (mm) | Existing access |
|---|---|---|---:|---|
| C1 | `UART3_RXD` | J4-4 B; U1-D6 T | 16.20 | V1 |
| C1 | `USB1_ID` | J4-89 B; U1-D22 T | 13.09 | V2 |
| C1 | `USB2_ID` | J4-99 B; U1-D23 T | 13.59 | V3 |
| C1 | `WL_REG_ON` | J8-6 B; U1-R23 T | 20.81 | V4 |
| C2 | `SD2_VSEL` | U8-29 T; U1-AG12 T | 16.90 | Both Top; no tracks or vias |
| C2 | `WDOG_B` | U1-AG13 T; R55-1 T | 19.63 | Both Top; no tracks or vias |
| C2 | `PMIC_NINT` | U8-13 T; U1-AF13 T | 21.80 | Both Top; two Top tracks |
| C2 | `PMIC_STBY_REQ` | U1-E24 T; R52-1 T | 19.59 | Both Top; V5 |
| C3 | `I2C1_SCL` | U1-E9 T; R48-1 T; R10-2 T | 28.28 | All Top; V6 |
| C3 | `I2C1_SDA` | U1-F9 T; R54-1 T; R11-2 T | 28.40 | All Top; V7 |
| C4 | `I2C2_SCL` | J4-22 B; U1-D10 T; R12-2 T | 15.74 | V8; Top and Bottom needed |
| C4 | `I2C2_SDA` | J4-24 B; U1-D9 T; R13-2 T | 15.54 | V9; Top and Bottom needed |
| C5 | `I2C3_SCL` | J4-26 B; U1-E10 T; R14-2 T | 16.05 | V10; Top and Bottom needed |
| C5 | `I2C3_SDA` | J4-28 B; U1-F10 T; R15-2 T | 16.48 | V11; Top and Bottom needed |
| C6 | `I2C4_SCL` | J4-30 B; U1-D13 T; R16-2 T | 15.71 | V12; Top and Bottom needed |
| C6 | `I2C4_SDA` | J4-34 B; U1-E13 T; R17-2 T | 16.03 | V13; Top and Bottom needed |
| C7 | `NetR55_2` | U8-28 T; R106-2 T; R55-2 T | 6.12 | All Top; no tracks or vias |
| C7 | `TESTMODE` | U1-D26 T; R135-1 T; R134-1 T | 13.35 | All Top; two Top tracks |
| C7 | `RTC_RESET_B` | U1-F24 T; R111-2 T; R102-2 T | 48.35 | All Top; V14 |
| C8 | `USB1_VBUS` | R108-2 B; J4-81 B; C393-1 B | 11.84 | All Bottom; no tracks or vias |
| C8 | `USB2_VBUS` | R109-2 B; J4-91 B; C394-1 B | 13.55 | All Bottom; no tracks or vias |

C1 can use Bottom connections to the existing CPU fanout vias. C2 can use Top,
but destinations diverge, so inspect and split the group as needed. C3-C6 are
natural SCL/SDA pairs. For C4-C6, the connector is on Bottom while the pull-up
resistor and CPU pad are on Top; a Bottom-only result cannot complete the net.
Use both surfaces and the existing CPU via deliberately.

Attempt C7 nets individually. `RTC_RESET_B` has widely separated resistor
destinations and a 48.35 mm maximum span; short local completion is insufficient.
C8 contains two connector-to-sense/filter networks, not USB data pairs. Check
their voltage and width rules before selecting routing parameters.

## Existing through-via coordinates

Coordinates are mils relative to board origin `(115633500, 82894100)` internal
units. Every via below has an exported diameter of 16 mil and hole of 8 mil.
Those existing dimensions do not approve a size for any new via.

| Via | Net / CPU pad | X (mil) | Y (mil) |
|---|---|---:|---:|
| V1 | `UART3_RXD` / U1-D6 | 785.61 | 1349.13 |
| V2 | `USB1_ID` / U1-D22 | 1064.23 | 1346.75 |
| V3 | `USB2_ID` / U1-D23 | 1120.31 | 1345.03 |
| V4 | `WL_REG_ON` / U1-R23 | 1102.05 | 1112.36 |
| V5 | `PMIC_STBY_REQ` / U1-E24 | 1101.58 | 1326.51 |
| V6 | `I2C1_SCL` / U1-E9 | 808.62 | 1327.06 |
| V7 | `I2C1_SDA` / U1-F9 | 807.68 | 1305.38 |
| V8 | `I2C2_SCL` / U1-D10 | 863.67 | 1350.44 |
| V9 | `I2C2_SDA` / U1-D9 | 808.41 | 1349.15 |
| V10 | `I2C3_SCL` / U1-E10 | 864.93 | 1327.36 |
| V11 | `I2C3_SDA` / U1-F10 | 864.35 | 1304.65 |
| V12 | `I2C4_SCL` / U1-D13 | 885.75 | 1350.42 |
| V13 | `I2C4_SDA` / U1-E13 | 887.28 | 1327.98 |
| V14 | `RTC_RESET_B` / U1-F24 | 1124.88 | 1287.85 |

## Schematic checks and limits

The checks below read local ASCII pin and parameter records from the original
SchDoc files. Component `RECORD=34` designator records establish each referenced
`OwnerIndex`. Multipart symbols repeat pin records. These checks establish pin
labels and component values, not complete schematic connectivity or firmware
pin configuration.

- [09-PMIC QCMI SOM.SchDoc](<../../../speedrun-input/09-PMIC QCMI SOM.SchDoc>):
  U8 OwnerIndex 215 identifies pin 28 as `WDOG_B` and pin 29 as `SD_VSEL`.
  R106 OwnerIndex 1942 has value 100K. This supports treating `NetR55_2` as
  a watchdog control branch rather than an unidentified analog connection.
- [06-CPUCTL QCMI SOM.SchDoc](<../../../speedrun-input/06-CPUCTL QCMI SOM.SchDoc>):
  U1 OwnerIndex 225 identifies D22/D23 as USB1/2_ID; E9/F9, D10/D9, E10/F10,
  and D13/E13 as I2C1-4 SCL/SDA; F24 as RTC_RESET_B; D26 as TEST_MODE; and
  E24 as PMIC_STBY_REQ.
- In that same U1 symbol, `UART3_RXD` uses D6, whose base pin name is
  `ECSPI1_SCLK`, and `WL_REG_ON` uses R23, whose base pin name is
  `SD1_RESET_B`. AG12/AG13/AF13 have GPIO1_IO04/02/03 base names. These
  labels suggest muxed functions; they do not establish the configured mode.
- [05-CPUPHY QCMI SOM.SchDoc](<../../../speedrun-input/05-CPUPHY QCMI SOM.SchDoc>):
  R108/R109 (OwnerIndex 1358/2497) have value 30K. C393/C394 (1280/1305)
  have value 0.22UF. These support the USB VBUS sense/filter interpretation.
- Rejected unnamed candidates: `NetR28_1` reaches U1-D19 `PCIE_RESREF`,
  `NetR29_1` reaches U1-E19 `USB1_TXRTUNE`, and `NetR30_1` reaches U1-E22
  `USB2_TXRTUNE`. Their analog reference/tuning roles exclude them from this
  convenience trial. Do not substitute them merely because they have vias.

Follow the original worksheet's batch acceptance checks. Preserve input files,
inspect geometry, compare connectivity and DRC, save, and reopen. Only the
permitted interactive tools and ActiveRoute may create routes; Situs and all
Auto Route scopes remain prohibited.

## Three candidates requiring deliberate layer access

These independent peripheral nets are preferable to relaxing the electrical
exclusions to reach 50 distinct nets. Each has two pads, one remaining
connection, and no existing tracks or vias in the source export. They need a
new transition; they are not part of the 21 existing-access candidates above.

| Net | Exact pads | Span (mm) | Function evidence |
|---|---|---:|---|
| `NetD1_C` | D1-C T; Q1-3 B | 13.20 | D1 cathode to Q1 drain; LED control branch |
| `SYS_NRST` | R127-1 T; J5-39 B | 28.13 | System reset through R127; opposite resistor pad reaches U8-8 PMIC_RST_B |
| `TEST_MODE` | R134-2 T; J4-56 B | 5.79 | Test-mode connector branch through R134; opposite resistor pad is on TESTMODE with U1-D26 |

The source-pad raw coordinates are D1-C `(131936400, 99951500)`, R127-1
`(116333500, 87944100)`, and R134-2 `(127493500, 101884100)`. These identify
existing pads, not proposed via centers. Inspect nearby copper on every layer
and select an off-pad via site with a short, deliberate surface connection.
The D1 pads are 40 by 40 mil; R127/R134 pads are 25 by 25 mil. Do not assume
that a via inside one of these pads is acceptable for fabrication.

[04-CPUIO QCMI SOM.SchDoc](<../../../speedrun-input/04-CPUIO QCMI SOM.SchDoc>)
identifies D1 (OwnerIndex 6276) as LED GREEN, pins A ANODE and C CATHODE;
Q1 (3834) is NX3008NBKW,115, with pin 3 DRAIN. The other source files identify
R127 in the SYS_nRST branch and R134 in the TEST_MODE branch. These checks
support the functional choice; they do not establish route acceptance.

Do not insert a 16 mil via directly at the existing free Top escape endpoints
for GPIO1_IO05, GPIO1_IO07, or GPIO1_IO09. Those endpoints are respectively
`(124585700, 91834000)`, `(124391700, 91834000)`, and
`(124193900, 91834000)`. Adjacent foreign-net U1 pads are only 9.70-9.99 mil
away center-to-center and are 10 mil wide. A 16 mil via would overlap their
copper. Those otherwise useful GPIO controls need longer escapes before a via;
the absence of an existing via is not evidence that the stub endpoint fits one.

## Off-pad via sites for live inspection

A read-only geometric screen used the pad, track, via, and rule exports written
at 2026-09-30 03:30:18 UTC. It evaluated these explicit sites for a 16 mil
diameter, 8 mil hole through via. The values below are proposals for inspection,
not placement approval or full DRC. `NetD1_C` is the first add/Undo trial choice.

| Net | Proposed X raw | Proposed Y raw | User X / Y (mil) | Offset from Top pad | Smallest modeled foreign-copper gap (mil) | Smallest hole-edge gap (mil) |
|---|---:|---:|---|---|---:|---:|
| `NetD1_C` | 131936400 | 99451500 | 1630.29 / 1655.74 | 50 mil below D1-C | 62.46 | 238.32 |
| `SYS_NRST` | 115933500 | 87944100 | 30.00 / 505.00 | 40 mil left of R127-1 | 42.21 | 363.22 |
| `TEST_MODE` | 127093500 | 101884100 | 1146.00 / 1899.00 | 40 mil left of R134-2 | 27.06 | 473.05 |

The closest modeled foreign copper is R102-2 (`RTC_RESET_B`) for the D1 site,
R114-2 (`POR_B`) for the reset site, and J4-80 (`GND`, Bottom) for the test-mode
site. The reset site is near the left board edge; verify the actual outline and
keepouts before adding a via there. User coordinates subtract the exported
origin `(115633500, 82894100)` before dividing by 10,000.

The screen treated each pad as a rotated rectangle using its exported basic
Top X/Y dimensions, each straight copper track on legacy layer IDs 1-32 as a
segment with its exported width, and each via as a circle. It checked foreign
net copper on both surfaces and all exported inner-layer tracks. Hole checks
included every exported via and every pad with a nonzero exported hole size.
Same-net copper was excluded from copper spacing checks, but not hole checks.

Limits: the export omits polygon pours, regions, arcs, keepouts, board-outline
geometry, detailed pad shapes, and full pad/via stacks. Basic Top dimensions do
not establish the size on every layer. These distances cannot prove clearance
through the stack, a suitable plane connection, board-edge spacing, or an
acceptable Top trace from the pad to the via. Inspect all layers, run native DRC,
and check the short surface connection before acceptance.

The exported all-net `RoutingVias` rule prefers 16/8 mil; `HoleToHoleClearance`
is 10 mil; `BoardOutlineClearance` reports 10 mil; `PlaneClearance` is 20 mil.
`Clearance` and the higher-priority `Fanout_Top` summary report 3 mil, but the
summary omits their per-object matrices. `50-OHM SE` has higher priority than
the generic Width rule and scopes to `Not InNetClass('POWER')`; use Altium's
resolved rule and stackup to choose the surface trace width. The summary alone
does not establish a 4.1 mil or 10 mil width for these nets.

The unqualified [TrialVia script](../../scripts/TrialVia.pas) accepts one chosen
site, creates one undo-registered through via, and reads its attributes back. It
does not choose positions, check collision geometry, route, or save. Its first
qualification must add one via, export and inspect the result, undo it, and
verify exact restoration before using it for any trial connection.

## Connector escape limits and rejected UART paths

Read-only comparison used
`runs/routing-50-2026-09-30/batch-04-short-bottom/after/` and
`runs/routing-50-2026-09-30/rejected-uart-bottom/`. Existing CPU fanout vias
provide layer access at the CPU; they do not solve an outer connector row's
escape across its inner pad row.

J4 signal pads have local dimensions 27 by 8 mil and rotation 90 degrees, so
their width across the row is 8 mil. J5 pads are 8 by 28 mil with zero rotation.
Both connectors have 15.74-15.75 mil center pitch, leaving 7.74-7.75 mil between
adjacent pads. The rejected tracks are 4.1 mil wide. With 3 mil clearance on
each side, a passage requires `4.1 + 3 + 3 = 10.1 mil`, which exceeds the gap
by 2.35-2.36 mil. Even a 3 mil track requires 9 mil. The geometric maximum
width at 3 mil clearance would be only 1.74-1.75 mil, below the generic minimum.
Do not reduce widths or clearances to force these passages.

| Group | Outer source row, user Y (mil) | Intervening inner row, user Y (mil) | Required direction toward CPU |
|---|---:|---:|---|
| UART2/4, J4-36/38/40/42 | 1947.75 | 1840.05 | Down across the odd pad row |
| GPIO1_IO10-15, J5-50/46/44/42/40/38 | 233.27 | 354.53 | Up across the odd pad row |

J4's inner/outer row-center separation is 107.70 mil; J5's is 121.26 mil.
The same J4 obstacle applies to C1 `UART3_RXD` and C4-C6 I2C2/3/4, whose
connector endpoints are even outer-row pads. In those groups, CPU vias and
enabling Top plus Bottom do not provide a local transition at the connector.
Plan connector fanout and transitions before expecting direct paths. C3 I2C1
has three Top pads per net and does not have this particular connector barrier.

The rejected result added exactly 22 Bottom track segments and removed none.
The before/after pad and via TSVs are identical. No UART2 connections completed.

| Net | Added segments | Added Bottom length (mm) | Prior airwire length (mm) | Length / airwire |
|---|---:|---:|---:|---:|
| `UART4_RXD` | 12 | 31.6157 | 17.1257 | 1.8461 |
| `UART4_TXD` | 10 | 31.3623 | 16.6598 | 1.8825 |

RXD traveled around the right end of J4; TXD traveled around the left end.
This large detour is independently sufficient to reject the result as a poor
trial path and investigate a deliberate transition instead.

### Actual anchor-pad geometry

A bounded read-only OLE/pad-record parser inspected the saved batch-04 PCB's
`Pads6/Data` stream and parsed all 1,593 pads. J4's four unnumbered pads have
Top and Bottom shape code 2, decoded as RECT; both size pairs are 27 by 14 mil,
with rotation 90 degrees. They are not rounded-corner shapes.
Their net fields are empty in the live export.

- The RXD segment from raw `(128821200, 101138683)` to
  `(128821200, 101450517)` passes the inner right unnumbered pad centered at
  `(128917700, 101294600)`. Its centerline is 9.65 mil from the pad center in X.
  The modeled edge gap is `9.65 - 7 - 2.05 = 0.60 mil`.
- The TXD diagonal from `(120706600, 102362001)` to
  `(120901699, 102557100)` intersects the outer left unnumbered pad's rectangle,
  centered at `(120827100, 102371600)`. The centerline itself crosses the
  rectangle, so the track copper overlaps that pad geometry.

This establishes geometric proximity/overlap with the saved rectangular pad
shapes. It is **not a native Short-Circuit report**. Native DRC is still needed
to establish which rule Altium applies to those no-net pads and what it reports.
Do not claim a reported new short from this calculation alone.

The saved `Rules6/Data` records confirm the all-net Clearance rule uses
`DifferentNets`, `SameLayer`, and a 3 mil generic gap. Its explicit matrix
overrides concern fills, polygons, and regions at 5 mil; there is no override
for Track-SMDPad or Track-Via. The higher-priority Fanout_Top rule also has a
3 mil generic gap. This explains why the basic track-to-pad calculation uses
3 mil while many existing pad-to-region violations use 5 mil.

The same segment-distance screen found about 3.000 mil gaps to numbered pads
and vias: RXD near C393-1 (USB1_VBUS), C405-1 (VDD_PHY_1V2), and J4-99
(USB2_ID); TXD near several even J4 pads and the GND via at
`(125374600, 96581600)`. Differences below 0.0001 mil are coordinate-rounding
scale. Polygons, regions, and other omitted geometry remain unchecked; this
screen cannot replace native DRC or whole-path visual inspection.

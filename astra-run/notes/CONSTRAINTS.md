# Electrical constraints

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

Review started September 30, 2026. Rules, placement, net assignments, and stackup
are immutable for this run. Differences between supplied documents are resolved
through endpoint identity and the actual board settings. They do not authorize
rule edits or component movement.

## Evidence and coverage

[NET_PLAN.tsv](NET_PLAN.tsv) contains all **321 nets**, all **1,430 net-assigned
pads**, and **857 baseline remaining connection edges**. The export also has
163 pads with no net. Single-pad and generated-name nets remain in the register.
Names and endpoint lists come from the [fresh baseline](../../astra-output/evidence/baseline-inventory),
completed at 04:48:18 UTC on September 30, 2026. Its net, pad, track, via,
and rule inventories match the preserved historical baseline byte for byte.
The register preserves these baseline counts and separately records current
connection counts from reopened checkpoint 014: **495 remaining edges** and
**72 nets with no remaining edge**, with 3,822 tracks and 560 vias. Eight PMIC nets are accepted
after native DRC and exact save/reopen comparison. Twelve connected DDR
data/mask nets and four connected strobe nets remain provisional. The two
connected strobe pairs exceed the native 100 mil uncoupled-length limit.
Ordinary connections added after batch001 also await native electrical
acceptance; a zero connection count alone does not establish acceptance.
Batch007 UART1_TXD and UART1_CTS added Bottom tracks inside the reserved DDR
rectangle. Their eight crossing segments per net total 797.860 mil and
808.405 mil inside that area. `electrical/ordinary-corridor-after010.json`
records the exact tracks. A reroute proposal removes only their 32 new Bottom
tracks and adds connector access for L3; the original input contains no Bottom
track on either net.

Batch016 added 159 ordinary-control segments on L3_IN1. DDR planning keeps
Top and Bottom paths, existing transition vias, and specific pending via
sites. Batch018 replaced the UART3_RXD diagonal that blocked three proposed
A_SDQS0 transition sites and preserved the adjacent A_DATA6 transition.
The same batch removed the BOOT_MODE1/PMIC_ON_REQ crossing; native DRC
removed its three clearance findings and three shorts. The other nine
pending pair/return sites clear the new L3 copper by at least 24.72 mil.
This does not reserve all possible future DDR vias or establish reference
continuity. Each later transition needs the current all-layer check.

The applied local power work connects 39 isolated supply-capacitor terminals
to existing vias and ties four J5 supply-contact banks. It does not complete
their main feeds. Checked source-array and power-region proposals are
recorded below; their count guards must follow the actual execution order.

The read-only analysis used the original PCB, SHA-256
`2669fca73471169e5c4cf80b3dcd25790dd246219bd2cbc23c6c1044637d6f2b`,
and all ten original SchDoc files. Length-prefixed schematic records establish
component parameters, pin names, active multipart sheets, and package-delay
fields. They are not a substitute for a compiled schematic netlist. Actual
PCB pad-to-net membership supplies the endpoint graph.

Raw extracts and analyses were written under
`astra-run/runs/full-routing-2026-09-30/electrical/` in the original run;
these runtime outputs are not included. Paths abbreviated as `electrical/`
below are relative to `astra-run/runs/full-routing-2026-09-30/`.
`register-summary.json` records
coverage checks. `schematic-components.json`, `schematic-pins.json`,
`Board6.json`, `Rules6.json`, `Classes6.json`, and `DifferentialPairs6.json`
identify the evidence used below. No original file was edited.

## Fitted component evidence

The `Value`, `MFG_PN01`, and `Comment` parameters agree on these identities:

| Part | Parameter value | Source |
|---|---|---|
| U1 | NXP MIMX8MM6DVTLZAA, BGA486, 14 x 14 mm | `03-CPULPDDR4 QCMI SOM.SchDoc`, component OwnerIndex 1002 |
| U2 | Micron MT53E512M32D2NP-046 WT:F | Same sheet, OwnerIndex 241 and 2419 |
| U4 | SanDisk SDINBDG4-32G-I1 | `07-FLASH QCMI SOM.SchDoc` |
| U5 | Micron MT25QU256ABA1EW7-0SIT | Same flash sheet |
| U8 | NXP PCA9450AAHN | `09-PMIC QCMI SOM.SchDoc` |
| U10 | ST LD39015M12R | Same PMIC sheet |
| Y1 / QZ2 | 24 MHz / 32.768 kHz crystals | CPU control / PMIC sheets |

U2's library name is `MT53D512M32D2DS_BGA200P`; it does not match its fitted
part parameter. Keep the existing footprint and pin assignments. The exact
Micron package and the assigned pins are reviewed in [DDR_PLAN.md](DDR_PLAN.md).

## Original PCB stack and impedance settings

`Board6/Data` contains this stack. Thicknesses are mils. Preserve it unchanged.

| Copper | Thickness | Dielectric below | Thickness / Dk |
|---|---:|---|---|
| L1_PS | 1.7 | TU768 prepreg | 2.77 / 3.9 |
| L2_GND_1 | 1.2 | TU768 core | 3.94 / 4.25 |
| L3_IN1 | 1.2 | TU768 prepreg | 5.04 / 3.9 |
| L4_GND_2 | 1.2 | TU768 core | 12 / 4.25 |
| L5_PWR_1 | 1.2 | TU768 prepreg | 5.04 / 3.9 |
| L6_PWR_2 | 1.2 | TU768 core | 3.94 / 4.25 |
| L7_GND_3 | 1.2 | TU768 prepreg | 2.77 / 3.9 |
| L8_SS | 1.7 | Bottom solder mask | 0.4 / 3.5 |

The supplied `imx8_98_7_rev_8_21_LAYER_STACK.csv` instead describes Ventec
VT47, 0.689/0.7 mil copper, and a 28 mil center core. Its 2.2 mil 50-ohm
widths and `L6_INNER2` designation do not describe this PCB stack. Use that
file as historical evidence, not as an instruction to change the board.

The original enabled impedance-profile entries are on L1/L8 only:

| Profile | Stored surface width / gap (mil) | Stored calculated impedance | Delay, ps/mm |
|---|---|---:|---:|
| S50 | 4.1 / not applicable | 54.581907 ohms | 5.880652 |
| D85 | 4.2 / 4.8 | 89.181495 ohms | 5.533727 |
| D90 | 3.6 / 4.9 | 95.301249 ohms | 5.507535 |
| D100 | 3.0 / 6.0 | 105.947727 ohms | 5.511732 |

Each profile stores 10 percent tolerance. These are stored calculations, not
fabrication measurements. The rule profile GUIDs differ from the IDs in the
visible Board6 profile records. Confirm the installed application's evaluated
rule and width before extending a critical net; do not repair IDs or change
values during routing. Inner profile entries are disabled and contain zero
calculated propagation speed. Zero means no usable calculation here, not zero
physical flight time.

The compressed `V9_STACKCUSTOMDATA` payload contains the same stack and
profiles as XML, with revision date July 7, 2025. Its `ElectricParameters`
entries explicitly give `TP` in ns/m, numerically equal to ps/mm. This
resolves the misleading `PROPAGATION_SPEED` keys in Board6: 0.149369 for
S50 and 0.140557 for D85 are rounded ps/mil delay values, not velocities.
`electrical/stack-custom-data.txt` preserves the decoded evidence. These
stored profile delays support planning estimates; verify the native timing
calculation, including neck widths and pad/via contributions, for acceptance.

`Polygons6/Data` has ten polygon definitions: eight on Top, one GND polygon
on L2, and one GND polygon on L7. The L2/L7 polygons span the board outline
and store `SHELVED=FALSE`. No polygon definition on L4/L5/L6 was found in this
stream. This does not prove continuous copper: inspect the actual pours,
voids, islands, and GND connection under every critical path. Keep signal
tracks out of intended reference/power regions unless the existing design's
actual copper and evaluated rules establish a permitted path.

## Native rule interpretation

The original `Rules6/Data` has 78 enabled rules. Priorities are local to a rule
type; the smallest priority number takes precedence. The exported summary
omits important per-layer values and matching modes.

| Rule | Stored scope or value | Routing use |
|---|---|---|
| `50-OHM SE`, Width priority 2 | `Not InNetClass('POWER')`; L1/L8 min=pref=max 4.1 mil; MidLayer2 pref/max 3.2 mil | 4.1 mil has original-rule evidence for ordinary surface signals. Verify evaluated scope. |
| `Width`, priority 3 | All; min 3, preferred 10, max 100 mil | Power width also needs current/return assessment. |
| `Clearance`, priority 2 | All; generic 3 mil plus object matrix | Inspect the relevant matrix entry, not generic clearance alone. |
| `Fanout_Top`, priority 1 | `WithinRoom('Page05 LPDDR4')` | Historical room-name scope needs native evaluation. |
| `RoutingVias` | Through hole; diameter min/preferred 16 mil, max 50 mil; hole min/preferred 8 mil, max 28 mil | Original `Rules6` confirms these bounds. Preserve inherited vias and the layer span. |
| `85OHM_PHY` | DDR_CK_DQS or PCIE; L1/L8 width 4.2, gap 4.8 mil | BGA priority-1 rule may supersede only where its room scope applies. |
| `90OHM_USB` | USB pair class; L1/L8 width 3.6, gap 4.9 mil | Check pair and single-ended width interactions natively. |
| `DDR_PAIRS` | Within-pair only, delay tolerance 1 ps | Distinct from pair-to-pair matching. |
| `DDR_DQS_to_CLK` | Group/pair-to-pair matching, 85 ps | Includes both channel clocks and all four strobes. |
| `Schematic Length Constraint_2` | All DDR_CK_DQS pair members, maximum 200 ps | Meet this stricter limit and the source-relative timing windows. |
| `DDR_BYTE0` through `DDR_BYTE3` | Native byte classes, group delay tolerance 10 ps | Native class numbering is not CPU channel order. |
| `DRAMA_CA` / `DRAMB_CA` | Each includes its clock pair, CA0-5, CS0/1, CKE0/1; 25 ps | Keep group spread within the native limit. |
| `EMMC` / `QSPI` | 100 ps group delay tolerance | Preserve the exact native member sets. |

Altium distinguishes group matching from matching the two members of a pair.
Its group rule uses the longest member as the upper limit, so a 10 ps group
tolerance is a 10 ps spread, not a general +/-10 ps window around any chosen
reference. Both modes must be checked separately.
[Altium high-speed rules](https://www.altium.com/documentation/altium-designer/pcb/design-rule-types/high-speed).

Differential-pair widths are checked by the applicable Differential Pairs
Routing rule. Altium documents online and batch checking for that rule type;
the absence of its section in a report does not establish acceptance. During
DRC, the applicable Clearance rule checks pair spacing. The differential
rule's Min/Preferred/Max Gap settings guide routing and are not themselves
DRC gap checks. Confirm actual checker coverage before accepting pair
widths or maximum uncoupled length.
[Altium routing rules](https://www.altium.com/documentation/altium-designer/pcb/design-rule-types/routing#differential-pairs-routing).

The batch004 CPU clearance repairs extended seven single-ended 3 mil
segments by 6 mil each. The exact Width findings changed; their unchanged
count does not accept the added 42 mil of undersized copper. Widening these
full segments to 3.2 mil passes the offline geometry model with at least
3.235 mil clearance. Native acceptance remains unresolved: the width rule
stores a global 3.2 mil minimum but 4.1 mil minimum on Top, and baseline
3.3/3.5 mil single-ended tracks also have Width findings. Resolve the native
interpretation without changing the rule. See
`electrical/seven-stubs-3p2-review.json`.

## Ordinary control routing

Batch001 completed the local U8 control connections
`NetR51_2`, `NetR52_2`, `NetR48_2`, `NetR54_2`, `NetR127_2`, `NetR114_1`,
`NetR111_1`, and `NetR146_2`. Their resistors are 0 ohms in the PMIC schematic.
Exact pads and existing access are in the register. Fresh native DRC and
save/reopen checks accepted these eight Top connections. Their paths stay local
to U8/resistors and outside the DDR reservation.

| Net | U8 signal and pad | Resistor pad |
|---|---|---|
| NetR51_2 | PMIC_ON_REQ, 39 | R51-2 |
| NetR52_2 | PMIC_STBY_REQ, 40 | R52-2 |
| NetR48_2 | SCL, 41 | R48-2 |
| NetR54_2 | SDA, 42 | R54-2 |
| NetR127_2 | PMIC_RST_B, 8 | R127-2 |
| NetR114_1 | POR_B, 9 | R114-1 |
| NetR111_1 | RTC_RESET_B, 6 | R111-1 |
| NetR146_2 | SW_EN, 12 | R146-2 |

All eight have two Top pads, one baseline remaining edge, no POWER-class
membership, and no required layer transition. Their endpoint bounds are
X=104.76-685 and Y=269.76-720.24 mil from the PCB origin, below the initial
DDR reservation. Fresh native checks accepted the 4.1 mil surface routes.

Short `NetR108_1` and `NetR109_1` connections are USB VBUS sensing nodes, not
USB data pairs. Each connects through a 30k series resistor to VBUS; the
0.22 uF capacitors C393/C394 connect VBUS to GND on the other resistor side.
Use their existing CPU via access. `TS_RES_EXT` is an analog sensor reference, requiring
a short quiet path. It is not a general-purpose GPIO merely because it is short.

Keep these generated nets out of ordinary batches: `NetR7_2` (DRAM_ZN),
`NetR28_1` (PCIe reference), `NetR29_1` / `NetR30_1` (USB analog tuning),
`NetC268_1` (MIPI regulator bypass), and `NetC245_1` (NAND_DQS local
18 pF shunt to GND, separate from the eMMC strobe).
Connector inner-row escape needs verified layer access. The historical
7.75 mil pad gap cannot hold a 4.1 mil trace plus two 3 mil clearances.

The original `L3_IN1` layer is legacy layer 3 (`MidLayer2`), with native
single-ended preferred and maximum width 3.2 mil. Batch013 connected
`BOOT_MODE1` with two 3.2 mil segments totaling 737.166 mil. Native width,
clearance, short, routing-layer, and via-style findings did not change. The
controller observed continuous current L2 GND beneath that path, apart from
its endpoint antipads. Batch014 then completed 14 ordinary nets with 57 L3
segments at 3.2 mil. All these segments stay outside the DDR planning rectangle;
the offline model found no added copper or keepout violation. Current native
DRC and saved-state evidence remain separate acceptance checks.

This is qualified native routing under the unchanged rules, not a new impedance
profile or a measured impedance claim. The stored inner profile remains disabled.
Do not extend the result to DDR or other differential rules without their own
width, coupling, timing, and reference checks. Added through vias also require
current-plane repour and native checks. The next combined signal/GND proposal
was rechecked after batch014; two signal sites and one ground site required
changes because the new L3 tracks crossed the former proposed via positions.

## Inherited unassigned copper at three short locations

The fresh native review identifies unassigned pad/fanout contacts at U1-M2,
U1-N2, and U4-K5. Their active schematic pins have explicit NoERC markers
and no wire segment touching the pin connection point:

| Pad | Schematic pin | NoERC evidence |
|---|---|---|
| U1-M2 | DRAM_AC17 / unused in LPDDR4 | DDR sheet (320,1000), Small Cross, suppress all |
| U1-N2 | DRAM_AC19 / MTEST | DDR sheet (320,820), Thin Cross, suppress one-pin net |
| U4-K5 | Active-low RST input | Flash sheet (440,620), Thin Cross, suppress floating input, no driver, and one-pin net |

These findings agree with empty PCB net assignments. Preserve the pins as
unconnected. A bounded repair may address the identified unassigned fanout
without assigning a destination or changing schematic/PCB net membership.
`electrical/no-net-pin-intent.json` records the exact source objects and the
zero-wire intersection checks. The schematic coordinates above are document
units, not board-relative routing coordinates.

## Other interface dependencies

- **eMMC:** U1 to U4 SD3 clock, command, data0-7, and strobe. U4's reset pad
  K5 is intentionally unconnected. The native `EMMC_SD3` matching class
  contains only clock, command, and data0-7. `SD3_STROBE` directly connects
  U4-H5 RCLK to U1-P27 NAND_CE1_B; check its timing separately. C245 is an
  unrelated 18 pF shunt from U1-R22 NAND_DQS to GND on `NetC245_1`.
  Preserve R117/R118 pulls and decoupling. Firmware mode and the complete
  end-to-end strobe budget remain unknown.
- **QSPI:** U1 to 1.8 V U5, six-member class, 100 ps native group tolerance.
  Preserve the actual clock/CS/data endpoints and 10k R37 CS pull. Device timing and
  loaded clock rate must be evaluated before functional sign-off.
  C245's separate NAND_DQS load is consistent with NXP's FlexSPI dummy-read
  strobe guidance for a memory without a DQS output; the configured read
  sampling mode remains unknown.
  [NXP IMX8MMHDG Rev. 4.1, Table 11](https://community.nxp.com/pwmxy87654/attachments/pwmxy87654/imx-processors/218788/1/IMX8MMHDG-NEW.pdf).
- **SD1/SD2, Ethernet, ECSPI, audio:** connector-facing synchronous groups.
  Reserve ordered connector escapes, clock paths, and continuous reference
  copper. Far-end loads and configured rates are not contained in this SOM.
  Native membership and endpoint identity permit physical planning without
  inventing far-end electrical margins.
- **USB/PCIe/MIPI:** 15 recorded differential pairs. Preserve polarity and
  pair classes. Fixed native dimensions govern routing. Actual connector
  escape, coupling, skew, and return transitions require group validation.
- **Crystals/reference:** preserve placement and all existing passive values.
  Keep local loops short and away from switching nodes and unrelated clocks.
  U8's 32.768 kHz output reaches U1-A26 through 0-ohm R100; U1-B25 returns
  through 0-ohm R113 to VDD_SNVS_0V8. These CPU RTC pins do not form a
  second crystal loop. QZ2 and Y1 are the actual 32.768 kHz and 24 MHz
  crystal networks.
- **Power/GND:** 26 classified nets include rails, switching nodes, internal
  regulator outputs, and ground. Preserve input/output capacitor topology,
  short switching loops, and quiet sense connections. A lower airwire count
  does not establish adequate current capacity or a connected pour.

Unknown operating rates, currents, edge rates, and external-board budgets stay
unknown in the register. These limits constrain sign-off; they do not call for
changing this evaluation board or halting independent routes with known rules.

## Power routing topology

These buck paths follow actual PCB pad membership. Keep their short local
switching loops separate from ordinary control batches:

| Regulator | Switching net and U8 pads | Inductor | Output rail | Feedback |
|---|---|---|---|---|
| BUCK1 | LX1, 36/37 | L5 | VDD_SOC_0V8 | R_SNSP1, U8-38, R142/R143 |
| BUCK2 | LX2, 45/46 | L6 | VDD_ARM_0V9 | R_SNSP2, U8-44, R140/R141 |
| BUCK3 | LX3, 31/32 | L10 | VDD_DRAM&PU_0V9 | R_SNSP3_CFG, U8-30, R144/R145 |
| BUCK4 | LX4, 19/20 | L11 | VDD_3V3 | U8-21 on output rail |
| BUCK5 | LX5, 15 | L13 | VDD_1V8 | U8-14 on output rail |
| BUCK6 | NetL15_1, 50/51 | L15 | NVCC_DRAM_1V1 | U8-52 on output rail |

All six switching nets lack POWER-class membership in the unchanged board.
The generic non-POWER width scope therefore needs special attention when
choosing an allowed copper construction; a 4.1 mil signal-width route alone
does not establish current capacity. Do not change class membership or rules.
The original Top polygons cover four CPU/DDR output rails and four GND
regions, with GND reference polygons on L2/L7. There is no original LX or
VSYS polygon in `Polygons6/Data`.

NXP specifies short high-current loops, quiet remote-sense access for bucks
1-3, and local output-capacitor sensing for bucks 4-6. Its guide estimates
peak LX current at roughly 1.4 times load current. Use the unchanged
placement while keeping control and reference paths away from switching
copper. The regulator ratings are limits, not measured board loads.

U8-57 EP is the noisy power ground. U8-5 AGND and U8-43 BUCK_AGND need
quiet access to the main GND through nearby vias; avoid direct Top copper
connections from the analog ground pads to EP. Keep the main GND beneath
the PMIC continuous and connect the EP with several return/thermal vias.
[NXP PCA9450 application note AN12840, sections 6.2-6.4](https://www.nxp.com/docs/en/application-note/AN12840.pdf).

U8 LDO1/LDO2 feed NVCC_SNVS_1V8/VDD_SNVS_0V8; LDO3 feeds VDDA_1V8;
LDO4 feeds VDD_PHY_0V9; LDO5 feeds NVCC_SD2. U10 feeds VDD_PHY_1V2.
VINT and EMMC_VDDIM are local regulator-capacitor nodes, not general rail
outputs for other loads. Preserve their assigned endpoints and short return
loops. USB1_VBUS/USB2_VBUS are connector sense/filter paths in this SOM;
the endpoint graph does not show an attached bulk USB load.

## Checked power additions after batch022

L5_PWR_1 and L6_PWR_2 are existing positive copper layers. Their original
records contain no tracks, polygons, fills, or copper regions; neither is
an assigned negative power plane. New solid polygons on these layers add
copper without changing the stack or rules. The unchanged polygon rule
uses direct connections. Every new pour needs native clearance, connectivity,
island, and neck inspection.

| Proposal | New vias / tracks | Construction and present limit |
|---|---:|---|
| NVCC_DRAM_1V1 source plus C324 return | 6 / 14 | Four source and two GND16/8mil vias;20mil Top source branches,25mil Bottom capacitor branches; minimum modeled clearance5.003mil |
| VDD_3V3 source and J5 bank access | 8 / 20 | Four source and four distributed connector vias;20/25mil source-capacitor leads and14mil bank taps; C311/C312 returns are separate |
| SOC, ARM, DRAM/PU, and1.8V sources | 16 / 41 | Four16/8mil source vias per rail,20mil Top feeds and25mil Bottom output-capacitor ties; minimum modeled clearance3.4mil |
| CPU capacitor/reference GND returns | 0 / 66 | Thirty-three isolated Bottom pads to existing GND vias;5mil constrained launches, widened to10mil where space allows; minimum modeled clearance3.278mil |

All proposed source vias are off-pad. The NVCC rectangle on L5 spans
(25,650) to (850,1480) mil and connects51 existing plus four proposed
source vias in the conservative raster check. A separate eight-vertex3.3V
region preserves3.2mil spacing from that rectangle and connects its eight
existing, four source, and four connector vias. Raster connectivity survives
a5mil erosion in both regions; this is supporting geometry evidence, not
native pour or current-capacity acceptance. Exact coordinates and checks are
in `electrical/nvcc-l5-region-review.json` and
`electrical/vdd3v3-l5-region-review.json`.

The L6 allocation for SOC, ARM, DRAM/PU, and1.8V remains under joint
connectivity review. Do not create those regions independently and assume
the remaining rail can pass between them. The checked source arrays are
separate from that allocation and retain their exact reserved coordinates.

PCA9450AA bucks1-4 have3A device ratings and bucks5-6 have2A ratings.
These are sizing envelopes. Supplied evidence does not establish load
current, via-barrel plating, allowable rail drop, or current sharing.
Local leads therefore do not establish whole-feed ampacity. LX/input loops,
output-capacitor grounds, quiet feedback, and native poured paths remain
required parts of each regulator connection.
[NXP PCA9450 data sheet, Table17](https://www.nxp.com/docs/en/data-sheet/PCA9450.pdf).

# DDR routing and validation plan

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

Rules, placement, and net assignments remain unchanged. This plan uses the
original PCB and schematic records read on September 30, 2026. Connectivity
counts use the controller's fresh 04:48:18 UTC baseline, whose core geometry
and rule inventories match the preserved original-state export.

The `electrical/` paths below are relative to the historical
`astra-run/runs/full-routing-2026-09-30/` run. Those analysis exports and the
named candidate artifacts are not included in this package.

## Devices and physical topology

U1's part parameter is **MIMX8MM6DVTLZAA**. U2's is
**MT53E512M32D2NP-046 WT:F**, a two-die, two-channel x16, single-rank,
2 GB memory configuration. The memory supports LPDDR4 operation at 1.1 V
VDDQ as well as LPDDR4X operation at 0.6 V. The available exact-part Micron
Rev. F document describes LPDDR4X electrical limits and explicitly points
to document `CCM005-554574167-10684` for LPDDR4 limits; do not apply its
0.6 V timing/termination table to this 1.1 V board.
[Micron Rev. F, November 2020, pp. 1-2, 19-23](https://datasheet.octopart.com/MT53E512M32D2NP-046-WT:F-Micron-datasheet-182858602.pdf).

PCB assignments connect CPU channel A to memory channel B and CPU channel B
to memory channel A. CPU A byte0 connects to memory B byte1; CPU A byte1 to
memory B byte0. CPU B byte0/1 connect to memory A byte0/1. Preserve this
mapping and the existing in-byte permutations. No new pin or byte swapping
is authorized.

Most DDR signal nets have U1 and U2 as their only pads. Exceptions are:

- Each clock conductor also reaches one pad of 150-ohm R8 (A) or R9 (B),
  which connects across its pair. Keep this assigned topology, with short
  local access to the resistor near U2. Fitted variant status is not proven.
- CKE0/1 each have a 10k pulldown at R121/R122/R123/R124 near U1.
- `DRAM_NRESET` has U1-R1, U2-T11, and 10k R4 to GND.
- `NetR7_2` joins U1-P2 DRAM_ZN to 240-ohm R7; R7's other pad is GND.
- `DRAM_ZQ0` joins U2-A5 to 240-ohm R5. `DRAM_ZQ1` joins U2-A8 to
  240-ohm R6. Both resistor supply pads belong to NVCC_DRAM_1V1.

The U2 schematic labels R3/H3/P5/J5/A8 as NC for the fitted single-rank
part. Those pads are assigned to CS1/CKE1/ZQ1 nets in the PCB. Preserve
the assignments and count their physical connectivity; do not remove nets
or infer an additional memory rank from their names. `DRAM_VREF` is a
single-pad U1-P1 net, not a missing memory connection.

Batch017 connects both ZQ nets with short 4.1 mil Bottom leads. The
controller's native inspection confirmed each lead ends at the assigned
Bottom resistor pad 2 and the selected original Top fanout remains intact.
The native L7 view showed surrounding reference copper under the short
paths, apart from each signal via's antipad, with no observed split
crossing. This is a limited visual reference check for these two local
connections, not a whole-board plane or impedance assessment.

## Byte classes and exact clock/strobe endpoints

| Native class | CPU group | Memory byte | Data and mask |
|---|---|---|---|
| DRAM_BYTE3 | A byte0, SDQS0 | B byte1 | DRAMA_DATA0-7, DMI0 |
| DRAM_BYTE2 | A byte1, SDQS1 | B byte0 | DRAMA_DATA8-15, DMI1 |
| DRAM_BYTE0 | B byte0, SDQS0 | A byte0 | DRAMB_DATA0-7, DMI0 |
| DRAM_BYTE1 | B byte1, SDQS1 | A byte1 | DRAMB_DATA8-15, DMI1 |

| Pair | True path | Complement path | CPU delays T/C, ps |
|---|---|---|---|
| DRAMA_CK | U1-L2 to U2-P8 | U1-L1 to U2-P9 | 41.1 / 41.2 |
| DRAMB_CK | U1-U2 to U2-J8 | U1-U1 to U2-J9 | 41.8 / 42.2 |
| DRAMA_SDQS0 | U1-A2 to U2-W10 | U1-B2 to U2-V10 | 59.0 / 58.9 |
| DRAMA_SDQS1 | U1-G1 to U2-W3 | U1-H1 to U2-V3 | 48.6 / 47.2 |
| DRAMB_SDQS0 | U1-AA1 to U2-D3 | U1-Y1 to U2-E3 | 49.9 / 48.6 |
| DRAMB_SDQS1 | U1-AG2 to U2-D10 | U1-AF2 to U2-E10 | 55.5 / 55.0 |

The timing files call strobes `DQS`; actual PCB names use `SDQS`. The
endpoint pairs above establish the association. Full exact endpoints and
CPU pin names for every DDR net are in [NET_PLAN.tsv](NET_PLAN.tsv).

## Timing interpretation without changing rules

Let `T(net)` mean PCB propagation delay plus the documented CPU package
delay and the applicable via delay. The supplied timing table gives:

| Signal group | Source delay requirement |
|---|---|
| Clock | At most 200 ps; T/C difference at most 1 ps |
| CA0-5, CS0/1, CKE0/1 | Within 25 ps of that channel's CK_T |
| Each DQS | Within 85 ps of that channel's CK_T; T/C difference at most 1 ps |
| DQ and DMI | Within 10 ps of that byte's DQS_T |

The CSV's absolute limits 225/285/295 ps are upper envelopes from a 200 ps
clock. They do not replace matching to the actual routed CK_T/DQS_T delay.
Also satisfy the stricter native settings: **all six clock/strobe pairs at
most 200 ps**, native CA-group spread at most 25 ps, byte-group spread at
most 10 ps, and pair-group spread at most 85 ps. A path below 200 ps can
satisfy both the native strobe maximum and the source envelope. Do not
increase the limit to 285 ps.

`DDR_PAIRS` enables only the within-pair check. `DDR_DQS_to_CLK` enables
group/pair-to-pair checks. They have different purposes despite matching
the same pair class. The source-relative checks should be retained as an
independent verification of the native result.

NXP's LPDDR4-3000 guidance includes CPU package and via flight time, solid
GND references, at most two signal vias per path, and a GND transition via
within 50 mils. It recommends at least 2W spacing between high-speed traces
and 5W separation from other signals for clocks/strobes routed separately.
Its permitted in-byte swaps do not authorize changing this board's map.
[NXP IMX8MMHDG Rev. 4.1, July 8, 2022, sections 3.4.2-3.4.2.1 and 3.4.6](https://community.nxp.com/pwmxy87654/attachments/pwmxy87654/imx-processors/218788/1/IMX8MMHDG-NEW.pdf).

The supplied 2.133 GHz column is not a verified operating mode. It matches
the memory speed grade; the CPU datasheet specifies LPDDR4 support through
3000 MT/s. Preserve the given delay rules and document the operating-rate
assumption separately.
[NXP IMX8MMCEC Rev. 2, November 2022, Table 29](https://www.nxp.com/docs/en/data-sheet/IMX8MMCEC.pdf).

## Source discrepancies resolved by endpoint identity

All four supplied engineering files were read, including the legacy XLS.
[Length Tuning Comprehensions.xlsx](<../../speedrun-input/Length Tuning Comprehensions.xlsx>),
sheet `Length Tuning Comprehensions`,
cells G2:H2, incorrectly repeats U1-L1/U2-P9 for DRAMA_CK_T. The CSV uses
U1-L2/U2-P8, agreeing with the PCB. The XLSX E2:F2 and strobe-reference rows
also use the complement-clock pins despite naming CK_T. Use the actual
true-clock endpoints above. Do not rename or reconnect a PCB net to fit a
spreadsheet row.

Of 68 CSV rows, 56 match both PCB endpoints exactly. Twelve DATA rows
have a different memory pin in the actual board. These are in-byte
permutations. The CPU pin remains correct and supplies the package-delay
identity. Keep the actual memory pad from the register:

| Net suffix | CSV U2 pad | Actual U2 pad |
|---|---|---|
| DRAMA_DATA10 | V2 | V4 |
| DRAMA_DATA11 | U2 | V2 |
| DRAMA_DATA12 | U4 | U2 |
| DRAMA_DATA13 | V4 | U4 |
| DRAMA_DATA14 | Y4 | AA4 |
| DRAMA_DATA15 | AA4 | Y4 |
| DRAMB_DATA2 | E2 | F2 |
| DRAMB_DATA3 | F2 | E2 |
| DRAMB_DATA4 | F4 | E4 |
| DRAMB_DATA5 | E4 | F4 |
| DRAMB_DATA6 | C4 | B4 |
| DRAMB_DATA7 | B4 | C4 |

The XLS clock report describes an older routed board on L1_TOP/L8_BOT. It
assigns CPU pad delays 41.1/41.2/41.8/42.2 ps, zero to U2 clock pads, and
12 ps per listed via. Summed rows give A T/C 164.897/166.526 ps and B T/C
177.827/176.986 ps. A's 1.629 ps mismatch exceeds today's 1 ps native rule.
This report establishes a historical calculation convention, not acceptance
of current routing or authority to copy its paths/delay constants.

Altium adds user-defined pad/via propagation delays to its stack-based
routing delay; it does not automatically calculate pad/via delay. Do not
add the CPU package delay a second time if the PCB value already contains it.
Check actual pad and via fields and the native Delay column.
[Altium Pin Package Delay](https://www.altium.com/documentation/altium-designer/pcb/high-speed-design/xsignals/pin-package-delay).

An offline correlation finds all 83 nonzero U1 schematic package delays at
the same binary location in the original PCB: little-endian double, offset
194 in pad subrecord 5. All 12 clock/strobe pad values agree within floating
point precision. This supports their existing presence in the PCB; confirm
the field's native interpretation before final timing accounting. No physical
1-100 ps double was identified in the original via records by that scan.
That absence does not prove zero via delay or establish an alternate value.

Batch002 native delay findings confirm that the stored CPU package values
are included. For example, unrouted `DRAMA_DATA10` reports 46.2 ps, its
CPU package value, while routed `DRAMA_DATA13` reports 147.384 ps including
48.8 ps of package delay. Use the actual native total for tuning; do not add
the package value again. That first byte attempt has a 59.328 ps spread
among its eight connected members and does not yet meet its 10 ps group rule.

Package delays alone span 12.7, 16.0, 18.3, and 21.6 ps in native byte groups
0, 1, 2, and 3; the CA groups span 30.6 ps (A) and 27.6 ps (B). Each exceeds
its native group's tolerance. Reserve room to compensate package differences;
matching copper lengths would not match total delays.

The original stack XML resolves the surface delay scale: S50 is
0.149368563 ps/mil and D85 is 0.140556674 ps/mil. For preliminary planning,
use package delay plus profile delay times path length, then include verified
via contributions. Existing narrow fanout and branch paths still need native
measurement. For matched T/C surface paths with equal via contributions,
package compensation alone would require these relative copper lengths:

| Pair | Ideal C length minus T length, mil |
|---|---:|
| DRAMA_CK | -0.71 |
| DRAMB_CK | -2.85 |
| DRAMA_SDQS0 | +0.71 |
| DRAMA_SDQS1 | +9.96 |
| DRAMB_SDQS0 | +9.25 |
| DRAMB_SDQS1 | +3.56 |

These values are compensation estimates, not required physical length
targets. Final acceptance uses total native delay and the 1 ps pair limit.

## Corridors, order, and acceptance

Baseline DDR endpoint bounds are X=86.89-769.08 mil and
Y=863.14-1405.81 mil, measured from the PCB origin. Reserve an initial
planning rectangle X=40-850, Y=800-1475 mil on relevant layers, plus the
existing U1/U2 escapes and adjacent tuning area. This is a planning
reservation, not a new PCB keepout or a proof of clear space. Revise its
extent from live geometry while preserving all placed components.

The initial layer allocation follows the existing access and unchanged
surface profiles. It is a planning choice, subject to native geometry checks:

| Group | Initial allocation | Existing access and remaining work |
|---|---|---|
| DRAMA_DATA8-15 and DMI1; DRAMB_DATA0-7 and DMI0 | Top, 4.1 mil | These 18 paths have no baseline vias. Keep the adjacent strobe corridors available. |
| Both CK pairs and all four SDQS pairs | Bottom, native D85 dimensions 4.2/4.8 mil | Each U2 pair endpoint has a via. CPU endpoints have no via; add deliberate signal and GND return transitions after checking clearance. |
| CA, CS, and CKE | Bottom, 4.1 mil initially | Existing access has vias at both U1 and U2; reserve clock/strobe paths first. Preserve CKE resistor branches. |
| DRAMA_DATA0-7 and DMI0; DRAMB_DATA8-15 and DMI1 | Bottom candidate, 4.1 mil | U2 endpoints have vias; U1 endpoints need deliberate access. Resolve congestion by native geometry and available original layers. |

No inner-layer profile entry is enabled in the original stored profile data.
L3 remains an alternative only after native width, propagation-delay, and
reference checks establish its actual treatment. Do not enable a profile or
change a design rule to make this planning allocation fit.

Of 70 existing DDR signal vias, 66 have an assigned GND via within 50 mil.
The exceptions are below. Distances establish proximity only; check actual
ground connectivity and continuous reference copper before accepting them.

| Net at U2 | Signal via X/Y, mil | Nearest assigned GND via distance, mil |
|---|---|---:|
| DRAMA_CK_T | 213.64 / 1196.33 | 62.85 |
| DRAMB_CK_T | 214.84 / 1103.27 | 63.20 |
| DRAMA_CKE1 | 270.89 / 1213.88 | 52.70 |
| DRAMB_DATA15 | 180.33 / 893.99 | 51.00 |

Reserve local GND stitching access near the clock transitions. Preserve the
signal vias; a new return via must obey the original rules and connect the
relevant reference copper. `electrical/ddr-existing-via-returns.tsv` records
the full measurements; all coordinates there are board-relative mils.

1. Inspect existing DDR escapes, signal vias, and L2/L7 pours. Verify the
   applicable width/gap, native package delay, and reference continuity for
   a representative path. Keep original tracks/vias unless a bounded local
   repair has a specific reason and a checkpoint.
2. Plan both clock pairs and four strobe pairs first; reserve their tuning
   space before ordinary nets enter the region. Prefer existing L1/L8
   access and the native pair dimensions. L3 may be considered only after
   native rule/reference/delay evaluation; the CSV alone is insufficient.
3. Finish one byte group at a time in existing pad order, including DMI.
   Use the class table, not class-number guesses. Keep layer/via patterns
   consistent where feasible; measure delay instead of imposing equal length.
4. Complete CA/control for each channel, preserve pulldowns and across-clock
   resistors, then reset and calibration nets. Keep ZQ/reference paths short
   and quiet. Recheck decoupling and rail connections beneath the region.
5. Tune to the native limits and independently check the source-relative
   windows. Check exact endpoints, pair polarity, shorts, clearance, width,
   hole/via rules, coupling/uncoupled length, return paths, and saved state.

A connected byte is provisional until delay, reference, and native DRC checks
agree for that saved board. Unverified operating mode and absent SI simulation
limit functional sign-off, but do not authorize rule changes or prevent useful
physical routing under the given constraints.

## CPU transition proposals and current provisional copper

Batch004 has 2,944 legacy tracks, 372 vias, and 837 remaining connection
edges. Eight A-byte1 and four B-byte0 data/mask nets are connected. Native
clearance and short counts returned to the inherited 911 and 3 findings
after the CPU approach repairs. Seven extended 3 mil single-ended stubs
remain provisional width work; their 42 mil of new narrow centerline is
not accepted by an unchanged finding count. No connected DDR member is
accepted before width, timing, reference, and pair checks are complete.

The following offline proposals preserve all placed components. Coordinates
are mils relative to PCB origin (raw 115633500,82894100). Each proposed
through via is 16/8 mil. Exact raw coordinates and measured clearances are
in `electrical/priority-strobe-vias-review.json` and
`electrical/remaining-pair-vias-review.json`.

| Pair | T via X/Y | C via X/Y | Proposed GND return X/Y |
|---|---|---|---|
| DRAMA_SDQS1 | 650 / 1284 | 634.8 / 1271.6 | 615 / 1284 |
| DRAMB_SDQS0 | 640 / 1012.8 | 653.5 / 1038.3 | 612 / 1018 |
| DRAMA_CK | 640 / 1214 | 652.5 / 1190 | 615 / 1185 |
| DRAMB_CK | 650 / 1115 | 650 / 1095 | 625 / 1115 |
| DRAMA_SDQS0 | 688.67 / 1435 | 708.67 / 1435 | 688.67 / 1460 |
| DRAMB_SDQS1 | 637.5 / 903 | 650 / 928.8 | 623 / 888 |

The first two pairs need nine new Top segments at 4.2 mil, directly from
their four CPU pad centers to the signal vias, with no inherited-stub edits.
`priority-strobe-top-leads-candidate.tsv` contains those additions. The
remaining pairs use existing partial fanout. Their proposed 4.2 mil leads
start outside the pad rows and need five 6 mil extensions of inherited
3 mil pair stubs. Hold those extensions until native differential-pair width
checking establishes an allowed construction. The geometry model does not
resolve width-rule applicability.

The complete adjacent-geometry plan also needs three endpoint edits on
`DRAMB_DATA4` and two edits plus one horizontal addition on `DRAMA_DATA13`.
Each replacement preserves that net's total centerline length and moves its
last diagonal before the associated CPU clock escape. The separate
`ddrb-data4-clock-followup-candidate.tsv` and
`ddra-data13-clock-followup-candidate.tsv` files contain exact old/new tracks;
the controller must update their expected object count before applying them.

All proposed transitions were checked against the fresh batch004 inventory,
the original keepout regions, other proposed transitions, and reserved
passages for B DATA0/1/12/13 and A DATA6. The model uses 3 mil copper,
5 mil keepout, and 10 mil hole spacing. No proposed via overlaps a CPU pad;
each signal return is within 49 mil and the GND centers are inside the
original L2/L7 GND regions. Native DRC, current pours, connected returns,
pair coupling, total delay, and saved-state comparison remain required.

Offset via-in-pad candidates were considered separately and rejected by
the conservative geometry checks. Their drilled holes also intersected
the BGA lands, requiring fabrication information absent from the inputs.
They are not part of these ordinary off-pad proposals.

Three additional memory-side return candidates cover the four baseline
proximity exceptions. `memory-ground-return-candidate.tsv` contains the
first choice in each row below; counts remain placeholders for the controller.
`memory-ground-return-review.json` records nearby objects and alternate sites.

| Proposed GND X/Y, mil | Signal transition served | Center distance, mil | Minimum modeled copper gap, mil |
|---|---|---:|---:|
| 248 / 1172 | A CK_T and A CKE1 | 42.10 / 47.73 | 3.636 |
| 210 / 1122 | B CK_T | 19.35 | 3.345 |
| 180 / 873 | B DATA15 | 20.99 | 3.706 |

These ordinary 16/8 mil vias do not overlap pads and pass the modeled
10 mil hole spacing. Their centers lie inside the original L2/L7 GND
regions. Native current-pour connectivity and clearance remain required.

## Checked repair candidates after batch016

The connected A_SDQS1 and B_SDQS0 Bottom paths still require coupling and
delay repair. Complete replacements retain their four existing signal
vias and all original Top fanout. They use 4.2 mil tracks and nominal
4.8 mil pair gaps, including paired detours that increase common delay.

| Pair | Existing Bottom segments removed | New Bottom segments | Estimated T/C delay, ps | Estimated skew, ps | Minimum modeled clearance, mil |
|---|---:|---:|---|---:|---:|
| DRAMB_SDQS0 | 12 | 26 | 127.041 / 127.597 | 0.557 | 3.10 |
| DRAMA_SDQS1 | 8 | 24 | 142.101 / 141.888 | 0.214 | 4.80 |

The estimates use prior native delay plus copper-length change and the
stored D85 surface propagation coefficient. Original Board6 records
store enabled Bottom D85 = 0.140557 ps/mil and S50 = 0.149369 ps/mil,
matching the rounded Top values; L7_GND_3 is the Bottom reference.
Native delay and current reference copper remain the acceptance evidence.
The proposed strobe delays are within 10 ps of the current longest
connected members B_DATA7 = 130.381 ps and A_DATA13 = 147.384 ps. Other
byte members still need routing or tuning; this is not byte acceptance.

`electrical/ddrb-strobe0-tuned-repair-*` and
`electrical/ddra-strobe1-tuned-v2-repair-*` contain exact requests and checks.
The A v2 proposal increases its parallel clearance from A_CA0 to 8.46 mil
and supersedes the first A candidate while preserving its estimated delay.
Each has a coupling report. A whole-segment model correlated with current
native findings predicts less than 100 mil uncoupled length for both
pairs; a stricter parallel-overlap-only model exceeds 100 mil because it
counts corner projections and escape ends. The native differential-pair
check must resolve this distinction before acceptance. Do not treat the
offline estimate as a passed pair rule.

The A repair was checked with the proposed A_CA0 Bottom path and the
remaining pair/return sites. `electrical/ddra-ca0-tracks.tsv` adds thirteen
4.1 mil Bottom segments between existing vias, with no added transition.
The path passes through the north opening of the memory power-via column
and then below A_SDQS1. Its modeled clearance is at least 3.09 mil and
new centerline length is 548.739 mil. Package plus surface-copper delay is
about 127.62 ps, before via contribution and native endpoint treatment.
Actual CA matching must include the routed channel clock.

A_CA0 and the A strobe replacement depend on removal of the 32 new
UART1_CTS/TXD Bottom segments. The UART1 replacement uses existing CPU
vias and four proposed J8 transitions to L3. Their original fanout and
assigned endpoints remain intact. The exact requests have count guards
that must be refreshed from the execution inventory.

Batch018 replaced UART3_RXD's diagonal from (553.81, 1580.93) to
(785.61, 1349.13), which crossed three proposed A_SDQS0 signal/return
sites. The applied v2 detour preserves those sites and the adjacent
A_DATA6 via at (728, 1448).
The other nine pending pair/return sites remain at least 24.72 mil from
new batch016 L3 copper. Top/Bottom DDR allocation remains feasible for
the checked paths; further transitions need fresh all-layer checks.

Power-region planning after batch022 includes the twelve remaining pair
and return sites plus B_DATA13(620,927), B_DATA12(642,947), and
A_DATA6(728,1448) as through-via reservations. New power pours must
respect their antipads while preserving the existing L2/L7 GND references.
The checked33-pad CPU GND-return proposal adds no holes and keeps its
Bottom segments east of x875mil, outside these DDR access reservations.

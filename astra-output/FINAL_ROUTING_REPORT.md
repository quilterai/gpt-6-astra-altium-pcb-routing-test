# Final routing report: QCMI_SOM8MM

> Public edition of the October 2, 2026 report. Paths and access instructions
> refer to this package; identifying workstation details are removed. Numerical
> engineering findings are preserved. The native input and output designs are
> unchanged.

The routing experiment stopped on October 2, 2026. This report describes the
saved board, the final native Altium DRC, the remaining electrical work, and the
recording limits. No routing repairs were made after the stop request.

The run notes describe supporting agents assigned to bounded geometry and
electrical reviews and monitoring, with the main controller as the sole live
Altium writer. This was not a controlled experiment isolating each agent's
contribution. The
maintained tools in `../astra-run/` include later portability and safety edits;
this report describes the saved run, not validation of those later tool versions.

**The board is incomplete and does not pass electrical or manufacturing
acceptance.** The conservative final result is **1,088 of 1,109 required
connections routed, or 98.11%**, with **21 named open connections**. There are
**300 of 321 named PCB nets without a native open finding, or 93.46%**. These
two percentages describe different things. Neither means that the connected
nets meet their width, impedance, return-path, timing, or fabrication requirements.

Native DRC reports **3,569 violations, zero waived**, compared with 4,320 in
the original board. The final audit also identifies **1,555 track segments on
GND-designated layers** and **1,058 controlled-impedance track segments on PWR
layers**. Those layer findings are separate from the native DRC total. Native
DRC reports 59 differential-pair coupling or width findings, 84 matching
findings, and four propagation-delay findings. DDR timing and layer grouping
were not completed.

## Where the result and evidence live

The definitive stopped board is in
[the final project](QCMI_SOM8MM.PrjPcb).
Open that project in Altium Designer. The project includes the PCB, ten schematic
sheets, libraries, variants, output jobs, supplied engineering references, and
the generated native reports. All 19 declared project document paths resolve.
The earlier checkpoint113 PCB is retained separately as pre-DRC evidence.

The main evidence entry points are:

- [Final verification and board identity](verification.json).
- [Native DRC, readable HTML](evidence/final-validation/final-native.html)
  and [original text](evidence/final-validation/final-native.drc).
- [Every final DRC occurrence in Markdown](evidence/final-validation/DRC_APPENDIX.md)
  and [the machine-readable ledger](evidence/final-validation/drc-all-findings.tsv).
- [Every exact added finding](evidence/final-validation/drc-added-findings.tsv)
  and [every exact removed finding](evidence/final-validation/drc-removed-findings.tsv).
- [Layer audit](evidence/audits/final-layer-audit.json),
  [exact segment ledger](evidence/audits/final-layer-audit-tracks.tsv),
  and [per-net totals](evidence/audits/final-layer-audit-nets.tsv).
- [Electrical findings](evidence/audits/final-electrical-findings.md)
  and [all timing/coupling occurrences](evidence/audits/final-electrical-timing-coupling.tsv).

The appendices are deliberately exhaustive. Each DRC occurrence has a stable
`DRC-NNNN` identifier, full native rule scope, exact native finding text, and an
exact-baseline-match flag. Coordinates and units are retained as Altium reported
them. The TSV files preserve repeated occurrences; they do not collapse several
violations into one net-level summary.

## Board identity, preservation, and limits

The final PCB was saved at **2026-10-02 18:48:03.909 UTC**, after DRC and a reset
of the displayed error markers. Its size is **10,842,112 bytes** and its SHA-256 is
`ff874ed815ac5bb9d63cff1cab7cc17cf9abd1326e242108f2979e545f9b1e3d`.
Resetting markers removes visual clutter; it does not resolve a violation. The
reports were preserved before that reset.

Checkpoint113, saved at 17:49:09.524 UTC, contains the same audited routing
geometry before the final DRC/save cycle. Its PCB hash is
`dc3af417562bdb3b545b887f4558ff599c99d212ac570ea96c1078388abbb511`.
The final binary hash is different, so the files are not described as
byte-identical. The post-DRC native inventory matches batch639 in every exported
track, via, pad, rule, and net-assignment record. The final saved file was not
closed and reopened as a separate final test; the report records that limitation.

The final inventory contains 9,724 legacy track objects, 995 vias, 1,593 pads,
321 named nets, and 78 rule objects. Track-object counts include the legacy
export's scope and are not counts of routed nets or independent paths. The
original full-run inventory contained 2,825 track objects and 372 vias. Exact
comparison finds 6,927 added track records and 28 removed or modified original
track records; it finds 626 added via records and three removed or modified
original via records. That is a net increase of 6,899 tracks and 623 vias.

It would be incorrect to say that every inherited copper primitive survived
unchanged. Local native Push operations and reviewed access repairs modified
some original geometry. The exact old records are preserved in
[original tracks modified](evidence/original-tracks-modified.tsv)
and [original vias modified](evidence/original-vias-modified.tsv).
One documented example is the 1.61 mil inherited RXD3 fanout tip replaced during
native batch628; [the access note](../astra-run/notes/RXD3_NATIVE_633.md) explains that change and
the affected-terminal checks. An exact record difference can also represent
resegmentation of a connected conductor, so the ledger is not a claim that all
31 changed original primitives lost electrical contact.

The baseline-to-final comparison finds **zero changes to exported pad records,
rule records, and net assignments**, and no change to the exported board origin
or units. Pad positions and rotations provide substantial evidence that placement
was preserved, but the inventory does not independently export every component
body attribute. The 24 input files included in this package match their
preserved original hashes. Three original autosave-history files are omitted
and listed separately in the [input manifest](../astra-run/notes/input-manifest.json).
The original input project was not overwritten. No rule limit was relaxed for
this final audit, and no component was moved during it.

## Why the final count differs from the last routing checkpoint

The cached connection inventory reports 20 remaining edges and 301 named nets
without an edge. That supports the earlier provisional result of
1,089/1,109 connections. The final native DRC reports **21 named unrouted
connections**, plus 12 inherited unassigned-copper findings. The additional
named open is `SD2_DATA0`: the report identifies the via at
`(1103.65mil,1011.66mil)` and R119-2 on Bottom at
`(1199.49mil,1020.09mil)`.

The fresh post-DRC export still contains only 20 ratsnest edges, and all 321
nets have the inventory's connectivity-invalid flag. Consequently, another read
of that same counter cannot overrule the native open finding. The conservative
headline subtracts 21 from the established 1,109 required connections, and
subtracts the 21 distinct named open nets from 321. It is a reconciliation of
the native reports, not a claim that a new Board Information dialog displayed
the corrected numerator.

The baseline had 252/1,109 routed connections and 857 remaining. The conservative
final improvement is therefore **836 fewer open required connections**. The
cached inventory's improvement is 837. Both values are retained with their
sources. The last recorded RXD3 connection is still present; the correction
comes from the SD2_DATA0 discrepancy, not from silently deleting RXD3 progress.

There are 321 named net objects in this actual PCB, including generated names
and single-pad nets. There are 1,109 required connection edges. A power net can
contain many terminals and many required edges. A multi-terminal net becomes
whole only after its remaining connectivity is resolved. This is why the
connection percentage and whole-net percentage differ. The connection headline
uses the larger connection denominator while this report also records whole-net
counts.

All final named open nets are listed below. Each has one native open occurrence;
the full native endpoints appear in the detailed register later in this report.

| Interface | Named open nets |
|---|---|
| DSI | DSI_CK_N, DSI_CK_P, DSI_D2_P, DSI_D0_N, DSI_D1_N |
| CSI | CSI_D0_N, CSI_CK_N, CSI_D2_N |
| PCIe | PCIE_RX_N, PCIE_RX_P, PCIE_TX_P |
| USB | USB1_DP, USB2_DN, USB2_DP |
| SD/eMMC | SD2_NCD, SD1_DATA1, SD1_DATA0, SD2_DATA0, SD3_DATA4, SD3_DATA3 |
| SAI | SAI1_TXD3 |

## Native DRC procedure and what its totals mean

Altium Designer 26.10.1 completed the final native batch DRC at
**2026-10-02 18:37:36 UTC** on the full-run working PCB. Altium reported eight
seconds elapsed. The public report uses a redacted working-document path. The
configured limit was 100,000 findings; the observed 3,569 findings are below
that limit. No waived findings are reported.

The observed report options included report-file creation, violations, subnet
details, verification of shorting copper, drilled-SMD-pad reporting, and
multilayer-pad zero-hole reporting. The final audit used the existing settings.
The batch list included width, unrouted connections, differential-pair routing,
delay, and matching checks. Impedance, return-path, and vias-under-SMD coverage
was not established by this run; those categories must not be presented as
passed because they are absent from the output. PCB Health was not requested.

The parser verifies each processed rule subtotal and the final report total.
It compares multisets of the **full rule text plus full finding text**, retaining
duplicate occurrences. There are **243 added and 994 removed exact occurrences**,
for a net decrease of 751. There are 3,326 final occurrences that exactly match
the original report. Changes in coordinates, segmentation, scope text, or batch
coverage can change an exact finding without creating or fixing a distinct
physical defect. The added/removed tables therefore describe report occurrences,
not 243 proven new physical defects and 994 independently verified repairs.

The original report did not have identical processed-section coverage to the
final report. Earlier run notes document enabling additional batch categories
without changing design-rule constraints. This is especially relevant to
timing and coupling comparisons. The complete set of processed rule strings
added or removed is retained in
[evidence/final-validation/drc-summary.json](evidence/final-validation/drc-summary.json). Unchanged native rule objects
and a changed set of report sections are different facts.

| Category | Original | Final | Exact added | Exact removed |
|---|---:|---:|---:|---:|
| Board Clearance | 4 | 11 | 7 | 0 |
| Clearance | 911 | 917 | 6 | 0 |
| Component Clearance | 0 | 1 | 1 | 0 |
| Delay | 0 | 4 | 4 | 0 |
| Differential pair coupling | 0 | 59 | 59 | 0 |
| Hole Size | 3 | 3 | 0 | 0 |
| Matched Lengths | 19 | 84 | 84 | 19 |
| Minimum Solder Mask Sliver | 1363 | 1363 | 0 | 0 |
| Net Antennae | 165 | 101 | 58 | 122 |
| Room Definition | 61 | 61 | 0 | 0 |
| Short-Circuit | 3 | 3 | 0 | 0 |
| Silk To Silk | 34 | 34 | 0 | 0 |
| Silk To Solder Mask | 475 | 475 | 0 | 0 |
| Un-Routed Net | 869 | 33 | 1 | 837 |
| Width | 413 | 420 | 23 | 16 |
| **Total** | **4,320** | **3,569** | **243** | **994** |

Processed zero-finding sections: Height Constraint (Min=0mil) (Max=1000mil) (Prefered=500mil) (All); Hole To Hole Clearance; Modified Polygon (Allow modified: No), (Allow shelved: No); Power Plane Connect Rule(Direct Connect )(Expansion=20mil) (Conductor Width=10mil) (Air Gap=10mil) (Entries=4) (All); Routing Layers(All); Routing Topology Rule(Topology=Shortest) (All); Routing Via (MinHoleWidth=8mil) (MaxHoleWidth=28mil) (PreferredHoleWidth=8mil) (MinWidth=16mil) (MaxWidth=50mil) (PreferedWidth=16mil) (All).

### Clearance, short circuits, and remaining opens

There are **917 clearance occurrences**, six more than the original report;
all six exact new findings are around CPU pads and Top tracks. Their measured
gaps are 2.495, 2.650, 2.580, 2.702, 2.790, and 2.790 mil against a 3 mil
requirement. They involve U1-C27, U1-D27, U1-AG17, U1-AG22, and U1-AG23. The
same nearby trace can produce two pad-related findings, so these six occurrences
must not be assumed to require six independent repairs.

The three short-circuit findings are exact inherited occurrences involving
U1-M2, U1-N2, and U4-K5 with unassigned copper. They remain blockers. Their
inherited status is provenance, not permission to waive them or assign a guessed
net. Resolving them requires checking the schematic and pin intent. The final
audit made no such electrical-assignment change.

The 33 unrouted occurrences consist of the 21 named opens above and 12 inherited
unassigned-copper occurrences. Treating all 33 as missing named signal routes
would misstate completion. Treating only the 20 cached ratsnest edges as the
native result would overstate completion. The complete ledger keeps both kinds
of native open visible.

### Width, board edge, and mechanical findings

There are **420 width occurrences**, compared with 413 originally. The exact
comparison has 23 added and 16 removed occurrences. Twenty of the new reported
segments have 3 mil actual width under a 4.1 mil requirement. Three are 5 mil
Bottom segments under a 4.1 mil requirement. Width failures therefore include
both below-limit and above-limit geometry; simply widening everything would
not resolve this category. Rule priority and layer-specific width settings must
be read for the particular segment.

The new board-edge findings are seven L3_IN1 track occurrences. Four report
6.431 mil clearance against 10 mil. Three report a collision against the same
10 mil requirement. Several are connected segments at the top perimeter, around
Y=1992 to 2000 mil. This exposes a limitation of the earlier geometric screening:
passing its local copper-distance check did not establish compliance with the
native board-outline rule. The four original board-clearance findings remain.

One component-clearance finding reports a collision between BH1 at
`(1881.85mil,1881.82mil)` and UL_BOX at `(1990mil,1745mil)`, against 10 mil.
It is absent from the original report but does not by itself prove component
movement; the exported pad placement is unchanged. Native body/keepout
interpretation and prior batch coverage need inspection before assigning cause.

The final report retains 1,363 minimum solder-mask sliver occurrences, 475
silk-to-solder-mask occurrences, 34 silk-to-silk occurrences, 61 room-definition
occurrences, and three hole-size occurrences. Those exact category totals are
unchanged. They remain part of the deliverable and cannot be omitted merely
because the experiment concentrated on connectivity. Net antennae decrease
from 165 to 101, but the exact comparison contains 58 added and 122 removed
occurrences. Stub and branch changes explain why the category difference alone
is insufficient to characterize this work.

## Routing on GND and PWR layers

The board names L2, L4, and L7 as GND layers, and L5 and L6 as PWR layers.
The inventory uses generic internal names such as `Mid Layer 1`, so the audit
maps physical IDs to the supplied stack rather than classifying by that generic
string. Top is L1_PS; the ordinary internal signal layer is L3_IN1; Bottom is
L8_SS. The original stack and unchanged rules are described in
[the constraint review](../astra-run/notes/CONSTRAINTS.md).

The audit counts **all track primitives** on GND layers under the literal
no-routing requirement. It also provides a narrower non-POWER signal count so
ground and supply conductors are not concealed within one total. There are
1,555 total GND-layer segments across 83 nets, with summed centerline length
78,310.218 mil. Of these, 1,275 segments on 74 non-POWER nets have the enabled
50-OHM SE scope; their summed length is 68,628.460 mil.

On PWR layers, there are 1,296 total segments across 75 nets. The enabled
`50-OHM SE` width rule has scope `Not InNetClass('POWER')`. Applying that actual
net-class scope identifies **1,058 controlled-impedance segments across 65
unique nets**, totaling **56,797.068 mil**. This is a rule-based classification,
not an inference from names such as CLK or DATA. Local room and differential-pair
width priorities are not evaluated separately for every segment. The ledger
states that limitation; it does not claim a field-solver impedance measurement.

| Physical layer | Role | All segments | All centerline length, mil | Controlled-impedance segments |
|---|---|---:|---:|---:|
| L2 | GND | 724 | 32,799.241 | 707 |
| L4 | GND | 406 | 18,202.138 | 179 |
| L5 | PWR | 537 | 27,951.537 | 478 |
| L6 | PWR | 759 | 41,566.565 | 580 |
| L7 | GND | 425 | 27,308.839 | 389 |

Only ten target-layer track records are exact matches to original geometry;
all ten are on L7. Every other target-layer record differs from the original
multiset. A differing record may be new routing or a modified original segment,
so the audit uses `not_exact_inherited` instead of claiming every one was wholly
new copper. Length totals include branches, overlaps, and stubs, and exclude
polygon copper. They are not unique source-to-destination route lengths.

Native `Routing Layers(All)` reports zero violations. That does not enforce
the separate requirement to remove routing from GND layers or keep controlled
impedance signals off PWR layers. The final result fails those requirements.
These connections were counted provisionally during the throughput phase, with
layer cleanup deferred. The run stopped before that cleanup occurred. Removing
such copper without replacement would reduce connectivity; it requires planned
rerouting and fresh timing/reference validation, not a cosmetic layer rename.

## DDR, differential pairs, and delay matching

The DDR source mapping and native classes were preserved. CPU channel A connects
to memory channel B and CPU channel B to memory channel A. The native byte-class
mapping is documented in [DDR_PLAN.md](../astra-run/notes/DDR_PLAN.md), along with the supplied
spreadsheet endpoint discrepancies and the board's actual pad assignments.
No pin swap or rule relaxation was used to resolve those discrepancies.

All DDR nets included in the final electrical inventory have zero cached open
edges. That is useful connectivity progress, but it is not DDR completion. The
native DRC directly demonstrates delay and matching failures. It also reports
uncoupled lengths and widths inconsistent with the differential-pair rules.
No JEDEC or device-specific compliance claim is made for the final board.

Four clock/strobe conductors exceed the unchanged 200 ps maximum:

| Net | Native total delay | Excess over 200 ps |
|---|---:|---:|
| DRAMA_SDQS0_C | 226.278 ps | 26.278 ps |
| DRAMA_SDQS0_T | 346.467 ps | 146.467 ps |
| DRAMB_SDQS1_C | 259.953 ps | 59.953 ps |
| DRAMB_SDQS1_T | 228.962 ps | 28.962 ps |

These are native reported propagation delays, not geometric trace lengths
converted with one assumed velocity. Earlier qualification showed that stored
CPU package delays are included in the native totals. Adding those values
again would double-count them. Via-delay accounting and reference continuity
still require their own review.

The 84 matched-delay occurrences include the 85 ps clock/strobe group, both
25 ps CA groups, the 1 ps within-pair check, four 10 ps byte groups, and QSPI
and eMMC groups. Their exact findings and group limits are retained in the
electrical appendix. A group spread reported below is calculated only from
the values actually printed in those findings; it is not a complete independent
timing export or a substitute for checking all reference-relative requirements.

| Matching scope | Tolerance, ps | Occurrences | Min/max reported delay, ps | Reported spread, ps |
|---|---:|---:|---:|---:|
| InDifferentialPairClass('DDR_CK_DQS' | 85 | 14 | 104.137 / 346.467 | 242.330 |
| InNetClass('DRAMA_CA' | 25 | 11 | 110.641 / 375.330 | 264.689 |
| InNetClass('DRAMB_CA' | 25 | 11 | 108.927 / 345.908 | 236.981 |
| InDifferentialPairClass('DDR_CK_DQS' | 1 | 4 | Within-pair difference findings | See exact appendix |
| InNetClass('DRAM_BYTE0' | 10 | 9 | 98.863 / 246.080 | 147.217 |
| InNetClass('QSPI' | 100 | 4 | 158.263 / 528.858 | 370.595 |
| InNetClass('EMMC_SD3' | 100 | 2 | 0.000 / 155.055 | 155.055 |
| InNetClass('DRAM_BYTE2' | 10 | 10 | 88.043 / 147.384 | 59.341 |
| InNetClass('DRAM_BYTE1' | 10 | 10 | 136.632 / 259.953 | 123.321 |
| InNetClass('DRAM_BYTE3' | 10 | 9 | 146.699 / 346.467 | 199.768 |

There are 59 differential-pair-category occurrences, comprising 18 excessive uncoupled-length findings and 41 width findings: five under the USB rule,
nine under the default rule, and 45 under the DDR/PCIe rule. This category includes
both uncoupled-length and width findings. It must not be described as 59 unique
failing pairs. A single pair can contribute multiple segments and multiple
types of findings. The exact rule stores the gap and width bounds as well as
the class scope, so the preserved report supports a targeted follow-up.

The worst native within-pair skew is 120.189 ps against 1 ps. All six DDR clock/strobe pairs exceed the 100 mil uncoupled-length limit, ranging from 230.773 to 1,251.274 mil. The DDR inventory includes 254 signal segments on GND layers and 256 on PWR layers. Nine DDR nets have more than two assigned vias; a path-level audit is needed because branches and stubs can inflate a net total. Of 123 assigned DRAMA/DRAMB signal vias, 26 have no assigned GND via within 50 mil; the greatest nearest-GND distance is 146.487 mil.

DDR source access, long detours, multiple signal vias, layer changes, and
occupation of the reference layers complicate later tuning. The audit provides
per-net layer allocation, widths, via counts, and native reported timing values.
A net's summed copper length includes branches and does not establish its
electrical path delay. A nearest-GND-via distance is a screening measurement;
it cannot prove that the via actually connects continuous reference copper on
the required layers. The final electrical notes distinguish these measured
geometry facts from unverified electrical acceptance.

## Other electrical and fabrication work still open

Several supply and ground connections include narrow local replacements. A
width allowed by a generic native rule does not prove adequate current capacity,
voltage drop, thermal behavior, or power distribution. The latest RXD3 work,
for example, retains a short GND Bottom neck narrowed from 10 mil to 5 mil;
earlier supply necks are listed in the electrical audit. No current-budget or
thermal simulation was completed for these geometries.

Via-in-pad and dense BGA access were used in the provisional routing. Filled
and capped via fabrication acceptance was not established. Drill and annular
requirements, mask behavior, assembly risk, and whether the intended fabricator
can build the chosen access need explicit acceptance. The absence of a native
via-size error does not settle those questions.

Polygons and reference planes are not represented by the simple track/via
inventory. Repour was used during routing, but the final report does not claim
that every signal has a continuous reference, every transition has a suitable
return connection, or every supply region has adequate feed geometry. The
native report contains zero modified-polygon findings, which is a narrower fact.
Controlled impedance requires the actual stack, reference copper, fabrication
tolerances, and path geometry; a matching nominal track width alone is not proof.

The incomplete USB, PCIe, CSI, and DSI nets also prevent interface acceptance.
Connected members of an incomplete pair are not a usable finished interface.
Likewise, completing an SD or SAI conductor does not establish timing to its
associated clock. The final deliverable retains the native class rules and
the supplied design data so a later reviewer can validate interface behavior
without reconstructing it from a screenshot.

## What the run demonstrated, and where the method fell short

The run demonstrated substantial connection completion from the supplied fanout
without component relocation or altered exported rule limits. Exact Altium
inventories, guarded edits, native routing operations, terminal-contact checks,
and saved checkpoints made individual geometry changes auditable. The final
RXD3 connection and its neighboring replacements have explicit native readback
and touched-terminal evidence. Many completed connections are real progress.

The result also shows the cost of optimizing primarily for connection count.
Provisional use of GND/PWR layers and postponement of matching produced a large
cleanup burden. That burden is measured above rather than presented as a small
finishing step. The final board is close to full connectivity by edge count,
but its remaining electrical work is much larger than the 21 open edges suggest.

DRC was deliberately deferred during the later throughput phase. The final
check found six exact new clearance occurrences, seven board-edge occurrences,
new width occurrences, and extensive timing/pair findings. Local geometric
screening was useful for proposed changes but did not reproduce Altium's complete
constraint system. The SD2_DATA0 discrepancy is direct evidence that the cached
connection graph was also insufficient as a sole completion gate.

Tool development improved some repeated operations, but script construction,
candidate review, and difficult fanout access consumed too much of the overall
elapsed time. Subagents sometimes produced proposals that awaited integration
while the main routing work stalled. Later ownership rules kept one desktop
writer and one status writer, and bounded the work agents could block. Those
changes helped coordination but did not recover all lost throughput.

Recording and monitoring had independent failures: Windows replacement denials,
RDP/display transitions, license interruption, and periods without changing
routing images. Recovering those tools interrupted the routing schedule. A live
heartbeat proves that a process is alive; it does not prove routing progress.
Wall-clock elapsed time includes outages and idle intervals; it is not a measured
active-routing duration.

For any future continuation, a small set of invariants should accompany each
meaningful connection batch: exact topology, permitted layer use, native width
and clearance, and a current native connectivity reconciliation. Difficult
timing groups should reserve usable space before ordinary routing consumes it.
That does not require running an exhaustive manufacturing report after every
single segment. It requires ensuring that progress is measured against the
constraints that would otherwise invalidate a large amount of later work.

## Recording and package scope

The published timelapse omits idle intervals. It is an edited view of the run,
not continuous evidence that routing progressed throughout the elapsed time.
The complete raw capture collection, monitoring logs, and dashboard service are
not included in this repository. Routing and acceptance claims in this report
rely on the supplied native design files, inventories, reports, and audit ledgers.

[The package manifest](manifest.json) records the current public files and their
hashes. Text evidence has identifying workstation paths and private operational
references removed; its hashes describe the redacted files in this package.
Native design files retain their saved bytes and their own recorded hashes.
The count of Altium autosave-history files and generated project caches omitted
from the saved package is in [the verification record](verification.json).

## Follow-up order if the board is continued later

1. Open a copy of the saved final project, reconcile the SD2_DATA0 native open,
   and inspect all 21 named open endpoints. Preserve this final audit unchanged.
2. Resolve the inherited shorts using the actual schematic and device pin intent;
   repair the six new clearance occurrences, seven new board-edge occurrences,
   and applicable width defects. Do not change requirements to remove findings.
3. Plan signal-layer capacity and replace the prohibited GND/PWR signal routing
   with valid paths. Keep track of connected terminal groups so cleanup does not
   silently reopen already connected nets.
4. Complete the remaining interfaces, then perform DDR clock/strobe, CA, and
   byte-group tuning using the actual native delays and source-relative limits.
   Check pair gap, coupling, layer grouping, signal-via count, and return paths
   together rather than treating length matching as an isolated operation.
5. Review power integrity, via-in-pad fabrication, mask, silk, rooms, mechanical
   clearance, stack-dependent impedance, and the remaining inherited findings.
6. Repour as appropriate, run complete native validation, save, reopen, repeat
   the independent inventory/constraint checks, and only then decide whether a
   release or manufacturing claim is justified.

These are future work items. They were not executed after the stop request.

## Detailed native findings requiring immediate attention

The following registers reproduce native findings, including coordinates and
the exact threshold text. The complete 3,569-occurrence appendix remains the
authoritative exhaustive list, including inherited mask, silk, room, and other
findings that are too numerous to repeat in this narrative.

### All final named and unassigned open findings

| ID | Category | Exact native finding |
|---|---|---|
| DRC-0921 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net DSI_CK_N Between Pad J4-15(648.3mil,1840.05mil) on L8_SS And Pad U1-A11(865.83mil,1405.81mil) on L1_PS |
| DRC-0922 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net DSI_CK_P Between Pad J4-17(664.05mil,1840.05mil) on L8_SS And Track (875.83mil,1396.11mil)(875.83mil,1405.81mil) on L1_PS |
| DRC-0923 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net DSI_D2_P Between Pad J4-23(711.29mil,1840.05mil) on L8_SS And Track (895.51mil,1396.1mil)(895.51mil,1405.81mil) on L1_PS |
| DRC-0924 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net DSI_D0_N Between Pad J4-3(553.81mil,1840.05mil) on L8_SS And Pad U1-A9(826.47mil,1405.81mil) on L1_PS |
| DRC-0925 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net CSI_D0_N Between Pad J4-33(790.03mil,1840.05mil) on L8_SS And Pad U1-A14(924.89mil,1405.81mil) on L1_PS |
| DRC-0926 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net CSI_CK_N Between Pad J4-45(884.52mil,1840.05mil) on L8_SS And Pad U1-A16(964.26mil,1405.81mil) on L1_PS |
| DRC-0927 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net CSI_D2_N Between Pad J4-51(931.76mil,1840.05mil) on L8_SS And Pad U1-A17(983.95mil,1405.81mil) on L1_PS |
| DRC-0928 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net PCIE_RX_N Between Pad U1-A19(1023.31mil,1405.81mil) on L1_PS And Pad J4-63(1026.25mil,1840.05mil) on L8_SS |
| DRC-0929 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net PCIE_RX_P Between Track (1033.02mil,1395.82mil)(1033.02mil,1405.81mil) on L1_PS And Pad J4-65(1042mil,1840.05mil) on L8_SS |
| DRC-0930 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net PCIE_TX_P Between Track (1052.71mil,1395.82mil)(1052.71mil,1405.81mil) on L1_PS And Pad J4-71(1089.24mil,1840.05mil) on L8_SS |
| DRC-0931 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net USB1_DP Between Track (1092.36mil,1396.11mil)(1092.36mil,1405.81mil) on L1_PS And Pad J4-85(1199.48mil,1840.05mil) on L8_SS |
| DRC-0932 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net SD2_NCD Between Track (1170.81mil,1002.4mil)(1180.8mil,1002.4mil) on L1_PS And Pad J4-88(1215.23mil,1947.75mil) on L8_SS |
| DRC-0933 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net DSI_D1_N Between Pad J4-9(601.06mil,1840.05mil) on L8_SS And Pad U1-A10(846.15mil,1405.81mil) on L1_PS |
| DRC-0934 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net USB2_DN Between Pad U1-A23(1102.05mil,1405.81mil) on L1_PS And Pad J4-93(1262.47mil,1840.05mil) on L8_SS |
| DRC-0935 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net USB2_DP Between Track (1111.97mil,1396.03mil)(1111.97mil,1405.81mil) on L1_PS And Pad J4-95(1278.22mil,1840.05mil) on L8_SS |
| DRC-0936 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net SD1_DATA1 Between Track (1170.81mil,1022.09mil)(1180.8mil,1022.09mil) on L1_PS And Pad J8-12(1769.37mil,607.87mil) on L8_SS |
| DRC-0937 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net SD1_DATA0 Between Pad U1-Y27(1180.8mil,1031.79mil) on L1_PS And Pad J8-8(1769.37mil,639.37mil) on L8_SS |
| DRC-0938 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net SD2_DATA0 Between Via (1103.65mil,1011.66mil) from L1_PS to L8_SS And Pad R119-2(1199.49mil,1020.09mil) on L8_SS |
| DRC-0939 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net SD3_DATA4 Between Pad U1-N27(1180.8mil,1169.58mil) on L1_PS And Pad U4-B3(1702.6mil,1413.53mil) on L1_PS |
| DRC-0940 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net SD3_DATA3 Between Track (1171.09mil,1159.6mil)(1180.8mil,1159.6mil) on L1_PS And Pad U4-B2(1682.91mil,1413.53mil) on L1_PS |
| DRC-0941 | Un-Routed Net | Violation between Un-Routed Net Constraint: Net SAI1_TXD3 Between Track (1071.882mil,896.389mil)(1072.44mil,896.948mil) on L1_PS And Track (1576.72mil,354.53mil)(1576.72mil,436.08mil) on L8_SS |
| DRC-0942 | Un-Routed Net | Violation between Un-Routed Net Constraint: Track (1741.97mil,1256.05mil)(1759.72mil,1238.3mil) on L1_PS Dead Copper - Net Not Assigned. |
| DRC-0943 | Un-Routed Net | Violation between Un-Routed Net Constraint: Track (668.98mil,1179.425mil)(678.825mil,1179.425mil) on L1_PS Dead Copper - Net Not Assigned. |
| DRC-0944 | Un-Routed Net | Violation between Un-Routed Net Constraint: Track (668.98mil,1199.115mil)(678.825mil,1199.115mil) on L1_PS Dead Copper - Net Not Assigned. |
| DRC-0945 | Un-Routed Net | Violation between Un-Routed Net Constraint: Track (678.825mil,1179.425mil)(688.67mil,1169.58mil) on L1_PS Dead Copper - Net Not Assigned. |
| DRC-0946 | Un-Routed Net | Violation between Un-Routed Net Constraint: Track (678.825mil,1199.115mil)(688.67mil,1189.27mil) on L1_PS Dead Copper - Net Not Assigned. |
| DRC-0947 | Un-Routed Net | Violation between Un-Routed Net Constraint: Via (1759.72mil,1238.3mil) from L1_PS to L8_SS Dead Copper - Net Not Assigned. |
| DRC-0948 | Un-Routed Net | Violation between Un-Routed Net Constraint: Via (228mil,1180mil) from L1_PS to L8_SS Dead Copper - Net Not Assigned. |
| DRC-0949 | Un-Routed Net | Violation between Un-Routed Net Constraint: Via (240mil,1103mil) from L1_PS to L8_SS Dead Copper - Net Not Assigned. |
| DRC-0950 | Un-Routed Net | Violation between Un-Routed Net Constraint: Via (253.13mil,1204.68mil) from L1_PS to L8_SS Dead Copper - Net Not Assigned. |
| DRC-0951 | Un-Routed Net | Violation between Un-Routed Net Constraint: Via (276.4mil,1100.82mil) from L1_PS to L8_SS Dead Copper - Net Not Assigned. |
| DRC-0952 | Un-Routed Net | Violation between Un-Routed Net Constraint: Via (765.6mil,1188.9mil) from L1_PS to L8_SS Dead Copper - Net Not Assigned. |
| DRC-0953 | Un-Routed Net | Violation between Un-Routed Net Constraint: Via (766.88mil,1113.22mil) from L1_PS to L8_SS Dead Copper - Net Not Assigned. |

### All inherited short-circuit findings

| ID | Category | Exact native finding |
|---|---|---|
| DRC-0918 | Short-Circuit | Violation between Short-Circuit Constraint: Between Pad U1-M2(688.67mil,1189.27mil) on L1_PS And Track (678.825mil,1199.115mil)(688.67mil,1189.27mil) on L1_PS Location : [X = 12250.569mil][Y = 9480.13mil] |
| DRC-0919 | Short-Circuit | Violation between Short-Circuit Constraint: Between Pad U1-N2(688.67mil,1169.58mil) on L1_PS And Track (678.825mil,1179.425mil)(688.67mil,1169.58mil) on L1_PS Location : [X = 12250.569mil][Y = 9460.44mil] |
| DRC-0920 | Short-Circuit | Violation between Short-Circuit Constraint: Between Pad U4-K5(1741.97mil,1256.05mil) on L1_PS And Track (1741.97mil,1256.05mil)(1759.72mil,1238.3mil) on L1_PS Location : [X = 13305.32mil][Y = 9545.46mil] |

### Exact new clearance, width, edge, and component findings

| ID | Category | Exact native finding |
|---|---|---|
| DRC-0850 | Clearance | Violation between Clearance Constraint: (2.58mil < 3mil) Between Pad U1-AG17(983.95mil,893.99mil) on L1_PS And Track (993.58mil,889.827mil)(993.58mil,895.53mil) on L1_PS |
| DRC-0851 | Clearance | Violation between Clearance Constraint: (2.702mil < 3mil) Between Pad U1-AG17(983.95mil,893.99mil) on L1_PS And Track (993.58mil,895.53mil)(993.65mil,895.6mil) on L1_PS |
| DRC-0852 | Clearance | Violation between Clearance Constraint: (2.79mil < 3mil) Between Pad U1-AG22(1082.37mil,893.99mil) on L1_PS And Track (1092.21mil,857.79mil)(1092.21mil,893.99mil) on L1_PS |
| DRC-0853 | Clearance | Violation between Clearance Constraint: (2.79mil < 3mil) Between Pad U1-AG23(1102.05mil,893.99mil) on L1_PS And Track (1092.21mil,857.79mil)(1092.21mil,893.99mil) on L1_PS |
| DRC-0854 | Clearance | Violation between Clearance Constraint: (2.495mil < 3mil) Between Pad U1-C27(1180.8mil,1366.44mil) on L1_PS And Track (1180.8mil,1356.45mil)(1217.157mil,1367.674mil) on L1_PS |
| DRC-0855 | Clearance | Violation between Clearance Constraint: (2.65mil < 3mil) Between Pad U1-D27(1180.8mil,1346.75mil) on L1_PS And Track (1180.8mil,1356.45mil)(1217.157mil,1367.674mil) on L1_PS |
| DRC-0984 | Width | Violation between Width Constraint: Track (1052.744mil,894.096mil)(1052.85mil,894.202mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-0985 | Width | Violation between Width Constraint: Track (1052.85mil,894.202mil)(1052.85mil,903.83mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-0992 | Width | Violation between Width Constraint: Track (1071.882mil,896.389mil)(1072.44mil,896.948mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-0993 | Width | Violation between Width Constraint: Track (1072.44mil,896.948mil)(1072.44mil,903.92mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-1033 | Width | Violation between Width Constraint: Track (1121.74mil,1006.335mil)(1126.441mil,1011.037mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-1049 | Width | Violation between Width Constraint: Track (1121.74mil,992.42mil)(1121.74mil,1006.335mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-1051 | Width | Violation between Width Constraint: Track (1126.441mil,1011.037mil)(1126.441mil,1014.555mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-1052 | Width | Violation between Width Constraint: Track (1131.52mil,901.8mil)(1131.52mil,903.7mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-1103 | Width | Violation between Width Constraint: Track (1171.09mil,1218.66mil)(1187.65mil,1218.66mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-1111 | Width | Violation between Width Constraint: Track (1187.65mil,1218.66mil)(1188.5mil,1218.66mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-1131 | Width | Violation between Width Constraint: Track (1644.42mil,1395.66mil)(1650.42mil,1401.66mil) on L8_SS Actual Width = 5mil, Target Width = 4.1mil |
| DRC-1134 | Width | Violation between Width Constraint: Track (1650.42mil,1401.66mil)(1679.38mil,1401.66mil) on L8_SS Actual Width = 5mil, Target Width = 4.1mil |
| DRC-1139 | Width | Violation between Width Constraint: Track (1679.38mil,1375.66mil)(1679.38mil,1401.66mil) on L8_SS Actual Width = 5mil, Target Width = 4.1mil |
| DRC-1179 | Width | Violation between Width Constraint: Track (657mil,1162.74mil)(660mil,1159.74mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-1180 | Width | Violation between Width Constraint: Track (660mil,1159.74mil)(668.98mil,1159.74mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-1181 | Width | Violation between Width Constraint: Track (662.98mil,1238.475mil)(678.825mil,1238.475mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-1182 | Width | Violation between Width Constraint: Track (662.98mil,1258.165mil)(678.825mil,1258.165mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-1183 | Width | Violation between Width Constraint: Track (662.98mil,1297.545mil)(678.825mil,1297.545mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-1184 | Width | Violation between Width Constraint: Track (662.98mil,1317.225mil)(678.825mil,1317.225mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-1185 | Width | Violation between Width Constraint: Track (662.98mil,1336.905mil)(678.825mil,1336.905mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-1186 | Width | Violation between Width Constraint: Track (662.98mil,982.575mil)(678.825mil,982.575mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-1346 | Width | Violation between Width Constraint: Track (944.57mil,913.68mil)(951.4mil,906.857mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-1373 | Width | Violation between Width Constraint: Track (993.65mil,895.6mil)(993.65mil,903.98mil) on L1_PS Actual Width = 3mil, Target Width = 4.1mil |
| DRC-3410 | Board Clearance | Violation between Board Outline Clearance(Outline Edge): (Collision < 10mil) Between Board Edge And Track (1089.24mil,1971.75mil)(1117.49mil,2000mil) on L3_IN1 |
| DRC-3411 | Board Clearance | Violation between Board Outline Clearance(Outline Edge): (Collision < 10mil) Between Board Edge And Track (1117.49mil,2000mil)(1580mil,2000mil) on L3_IN1 |
| DRC-3412 | Board Clearance | Violation between Board Outline Clearance(Outline Edge): (6.431mil < 10mil) Between Board Edge And Track (1171.98mil,1971.75mil)(1192.23mil,1992mil) on L3_IN1 |
| DRC-3413 | Board Clearance | Violation between Board Outline Clearance(Outline Edge): (6.431mil < 10mil) Between Board Edge And Track (1192.23mil,1992mil)(1206mil,1992mil) on L3_IN1 |
| DRC-3414 | Board Clearance | Violation between Board Outline Clearance(Outline Edge): (6.431mil < 10mil) Between Board Edge And Track (1206mil,1992mil)(1576mil,1992mil) on L3_IN1 |
| DRC-3415 | Board Clearance | Violation between Board Outline Clearance(Outline Edge): (6.431mil < 10mil) Between Board Edge And Track (1576mil,1726mil)(1576mil,1992mil) on L3_IN1 |
| DRC-3416 | Board Clearance | Violation between Board Outline Clearance(Outline Edge): (Collision < 10mil) Between Board Edge And Track (1580mil,2000mil)(1806mil,1774mil) on L3_IN1 |
| DRC-3569 | Component Clearance | Violation between Component Clearance Constraint: (Collision < 10mil) Between Small Component BH1-MOUNTING HOLE (1881.85mil,1881.82mil) on L1_PS And SMT Small Component UL_BOX (1990mil,1745mil) on L1_PS |

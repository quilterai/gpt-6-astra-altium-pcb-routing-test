# Trial DRC comparison

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

## Repaired trial: 04:12 UTC

The fresh native report started **2026-09-30 04:12:08 UTC**, completed in four
seconds, and was written at **04:12:12 UTC**. It reports **4,300 violations**
and zero waived violations. The baseline has 4,320; the first post-trial check
had 4,303. The exact individual-finding comparison preserves duplicate
occurrences and includes each finding's rule text.

**There are no new clearance, short-circuit, or width findings relative to the
baseline.** Native Repour All removed the two LED-via shorts and two LED-via
clearances. Selecting and deleting the one offending `PMIC_NINT` segment
removed its two new clearances. Those six findings are absent from the repaired
report; the three original shorts remain.

The trial still has unresolved findings. Relative to the baseline, the repaired
report contains **three added and 23 removed individual findings**. One added
finding is a different description of the still-unrouted `PMIC_NINT` connection;
one is an antenna on its retained partial track; one is the previously observed
Top Overlay text collision. A lower total does not establish design acceptance.

| Category | Baseline | Before repair | Repaired | Added vs baseline | Removed vs baseline |
|---|---:|---:|---:|---:|---:|
| Clearance | 911 | 915 | 911 | 0 | 0 |
| Short-Circuit | 3 | 5 | 3 | 0 | 0 |
| Un-Routed Net | 869 | 848 | 849 | 1 | 21 |
| Width | 413 | 413 | 413 | 0 | 0 |
| Net Antennae | 165 | 162 | 164 | 1 | 2 |
| Board Outline Clearance, outline edge | 3 | 4 | 4 | 1 | 0 |
| Board Outline Clearance, cutout edge | 1 | 1 | 1 | 0 | 0 |
| Hole Size | 3 | 3 | 3 | 0 | 0 |
| Matched Net Lengths | 19 | 19 | 19 | 0 | 0 |
| Minimum Solder Mask Sliver | 1,363 | 1,363 | 1,363 | 0 | 0 |
| Silk To Solder Mask | 475 | 475 | 475 | 0 | 0 |
| Silk To Silk | 34 | 34 | 34 | 0 | 0 |
| Room Definition | 61 | 61 | 61 | 0 | 0 |
| **Total** | **4,320** | **4,303** | **4,300** | **3** | **23** |

### Exact residual added findings

Coordinates below use the report's mil values relative to the board origin.

1. **Un-Routed Net:** `PMIC_NINT`, between Top track
   `(906.828, 312.009)` to `(906.828, 883.693)` and Top track
   `(915.16, 893.99)` to `(915.16, 903.72)`. This replaces the baseline
   `PMIC_NINT` finding from U8-13 to the same CPU stub. It is one incomplete
   connection, not a newly completed net.
2. **Net Antennae:** Top track `(906.828, 312.009)` to `(906.828, 883.693)`.
   This is the long retained `PMIC_NINT` segment ending before the removed
   diagonal segment. The original CPU-stub antenna also returns after removal
   but matches a baseline finding, so it is not newly added versus baseline.
3. **Board Outline Clearance:** collision less than 10 mil between Board Edge
   and Top Overlay text `.ProjectNameShort` at `(2110, 1585)`. No route-batch
   cause is established. No text, board outline, or rule edit was made to hide
   this finding.

The removed diagonal segment was raw `(124701782, 91731029)` to
`(124785100, 91834000)`, width 41000, Top layer. Its guarded selector changed
selection only; the deletion occurred through Altium. The two baseline
`PMIC_NINT` CPU escape segments remain.

### Repaired routing count

The repaired trial has **18 newly fully connected nets**, plus partial
`USB1_VBUS` and `PMIC_NINT`, across 20 touched nets. The completed nets are:

- `NetD1_A`, `NetD1_C`.
- `NetR51_2`, `NetR52_2`, `NetR48_2`, `NetR54_2`, `NetR127_2`,
  `NetR114_1`, `NetR111_1`, `NetR146_2`.
- `NetR109_1`, `NetR108_1`, `TS_RES_EXT`.
- `USB1_ID`, `USB2_ID`, `WDOG_B`, `SD2_VSEL`, `USB2_VBUS`.

There are **20 fewer net connections** than the baseline. `USB2_VBUS`
completed two connections; `USB1_VBUS` completed only C393-1 to J4-81.
The 21 removed exact unrouted finding strings include the old `PMIC_NINT`
description, which is replaced by one new unrouted string. Thus the reduction
is 20, not 21. The 849 unrouted DRC findings imply **837 remaining net
connections plus the 12 baseline unassigned-copper findings**. Native Board
Information at **04:14:28 UTC** independently reported **1,109 total,
272 routed, and 837 remaining connections**, compared with the baseline's
1,109 total, 252 routed, and 857 remaining. The 04:04:39 inventory with 836
remaining connections predates the deliberate `PMIC_NINT` disconnection.

The two removed baseline antenna findings are the `USB1_ID` via at
`(1064.23, 1346.75)` and `USB2_ID` via at `(1120.31, 1345.03)`.

The repaired report was generated at the project output path below. The pre-repair
PCB and both native reports were preserved in
`astra-run/runs/routing-50-2026-09-30/final-before-repair/` during the original run;
these trial artifacts are not included in this repository.

### Saved and reopened checkpoint

The controller saved, closed, and reopened the trial at **04:15-04:16 UTC**.
The fresh inventory completed at **04:16:56 UTC** and reports 321 nets,
1,593 pads, **2,909 legacy track objects, 373 vias, and 837 nonredundant
connection objects**. Its 837 count agrees with the native Board Information
report. Legacy track totals exclude some extended mechanical layers; they are
not whole-document primitive totals. The API connectivity-invalid flags remain
set after reopen and are not used as proof of connectivity; the native report
and matching connection count provide the measurement.

Saved PCB SHA-256:

```text
cf8253b370543494b4f429fb7b368ae060b40e27bc1054c65916a7e33f0bd655
```

Source checkpoint:
`astra-run/trials/routing-50-2026-09-30/QCMI_SOM8MM/IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc`.
The historical selected result destination was
`astra-run/results/setup-trial-2026-09-30/QCMI_SOM8MM/`, with its `evidence/`
directory beside `QCMI_SOM8MM/`. Publication and push success must be verified
separately; this document records the measured board, not a Git upload result.

The LED via and exact Top stub survived reopening. The live via experiment also
verified native Undo returning 373 to 372 vias with zero geometry delta, then
Redo restoring the added via. The stub's original readback error came from
reversed endpoint order; the independently exported geometry was correct.
The source fix accepting either order was not rerun because an existing LED
track makes the duplicate-add guard refuse. See [script qualifications](../scripts/README.md).

The explicit DRC-segment selector was live-qualified after native
**Edit > DeSelect > All**: exactly one new `PMIC_NINT` segment was selected and
deleted through Altium. Both baseline PMIC escape segments remain.
**Ctrl+D opens View Configuration in this session and is not Deselect All.**
The remaining partial-track antenna and overlay-text collision are retained
exceptions, not waived findings. The trial completed 18 nets, below the
approximately 50-net target, and does not establish fabrication or high-speed
design acceptance.

## Preserved first post-trial check: 03:58 UTC

Measured report: **2026-09-30 03:58:46 UTC**, completed in four seconds; `.drc`
and `.html` modification time **03:58:50 UTC**. This is the first post-trial
check, before any subsequent repair or repour. It reports **4,303 violations**
and zero waived violations versus the preserved baseline's 4,320.

**This pre-repair state was not DRC-accepted:** its lower total includes seven new findings,
including two new shorts at the explicit LED via. Twenty-four baseline findings
disappeared. Counts compare exact individual finding text within each rule,
including duplicate occurrences, rather than subtracting category totals alone.

Baseline: `astra-run/runs/routing-50-2026-09-30/baseline/design-rule-check.drc`.
Original report path: `astra-run/trials/routing-50-2026-09-30/QCMI_SOM8MM/Project
Outputs for QCMI_SOM8MM/Design Rule Check -
IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.drc`. The corresponding HTML was also
fresh. Altium replaces these paths; the 03:58 evidence is preserved under
`final-before-repair/`.

## Category comparison

| Category | Baseline | 03:58 check | Added findings | Removed findings |
|---|---:|---:|---:|---:|
| Clearance | 911 | 915 | 4 | 0 |
| Short-Circuit | 3 | 5 | 2 | 0 |
| Un-Routed Net | 869 | 848 | 0 | 21 |
| Width | 413 | 413 | 0 | 0 |
| Net Antennae | 165 | 162 | 0 | 3 |
| Board Outline Clearance, outline edge | 3 | 4 | 1 | 0 |
| Board Outline Clearance, cutout edge | 1 | 1 | 0 | 0 |
| Hole Size | 3 | 3 | 0 | 0 |
| Matched Net Lengths | 19 | 19 | 0 | 0 |
| Minimum Solder Mask Sliver | 1,363 | 1,363 | 0 | 0 |
| Silk To Solder Mask | 475 | 475 | 0 | 0 |
| Silk To Silk | 34 | 34 | 0 | 0 |
| Room Definition | 61 | 61 | 0 | 0 |
| **Total** | **4,320** | **4,303** | **7** | **24** |

## Exact new findings and attribution

Coordinates below use the report's mil values relative to the board origin,
except where raw database coordinates are explicitly labeled.

| Finding | Objects and measured result | Trial attribution |
|---|---|---|
| Clearance | U1-AG13 at (905.21, 893.99) and Top track (906.828, 883.693) to (915.16, 893.99): **0.685 mil < 3 mil** | Batch 6 `PMIC_NINT` connection; adjacent pad is `WDOG_B` |
| Clearance | U1-AG14 at (924.89, 893.99) and that same Top track: **2.68 mil < 3 mil** | Batch 6 `PMIC_NINT`; adjacent pad is `REF_CLK_32K` |
| Clearance | Polygon Region, 131 holes, `L7_GND_3`, and via (1630.29, 1655.74), Top to Bottom: **Collision < 5 mil** | Explicit `NetD1_C` via |
| Clearance | Polygon Region, 144 holes, `L2_GND_1`, and that via: **Collision < 5 mil** | Explicit `NetD1_C` via |
| Short-Circuit | Polygon Region, 131 holes, `L7_GND_3`, and that via; raw report location X=13193.64 mil, Y=9945.15 mil | Explicit `NetD1_C` via |
| Short-Circuit | Polygon Region, 144 holes, `L2_GND_1`, and that via; same raw report location | Explicit `NetD1_C` via |
| Board Outline Clearance | Board Edge and Top Overlay text `.ProjectNameShort` at (2110, 1585): **Collision < 10 mil** | No route-batch attribution established; inspect resolved text and board context |

The inventory identifies the offending Top segment as `PMIC_NINT`, raw
`(124701782, 91731029)` to `(124785100, 91834000)`, width 41000, layer ID 1.
It connects toward an existing CPU escape stub. The actual native clearance
findings invalidate that connection's quality despite its completed ratsnest.

The LED via is raw `(131936400, 99451500)`, diameter 160000, hole 80000,
spanning IDs 1-32. Its two shorts are **native reported findings**, unlike the
earlier read-only rectangular-pad overlap analysis of the rejected UART paths.
Native Repour All subsequently removed these four via-related findings, as
confirmed by the repaired report above. This demonstrates why the TSV geometry
screen, which omits polygon copper, could not qualify the via alone.

## Removed findings and routing count

The 21 removed unrouted findings cover these retained trial groups:

| Group | Removed unrouted findings |
|---|---:|
| `NetD1_A` manual connection | 1 |
| Eight PMIC resistor/control nets: `NetR51_2`, `NetR52_2`, `NetR48_2`, `NetR54_2`, `NetR127_2`, `NetR114_1`, `NetR111_1`, `NetR146_2` | 8 |
| Short Bottom `NetR109_1`, `NetR108_1`, `TS_RES_EXT` | 3 |
| `USB1_ID`, `USB2_ID` | 2 |
| Batch 6 `WDOG_B`, `SD2_VSEL`, `PMIC_NINT` | 3 |
| `USB2_VBUS`, both connections | 2 |
| `USB1_VBUS`, C393-1 to J4-81 connection only | 1 |
| `NetD1_C` after the explicit via/stub and Bottom completion | 1 |
| **Total** | **21** |

This pre-repair state had 19 newly fully connected nets plus a partial `USB1_VBUS` net, across
20 touched nets. Completed connectivity does not establish acceptable quality;
`PMIC_NINT` and `NetD1_C` have new findings above. `USB1_VBUS` still needs its
other endpoint connection.

The removed antenna findings are the `PMIC_NINT` Top stub from
(915.16, 893.99) to (915.16, 903.72), the `USB1_ID` via at
(1064.23, 1346.75), and the `USB2_ID` via at (1120.31, 1345.03).

Baseline unrouted DRC included 857 net connections and 12 pieces of unassigned
dead copper. With 21 net findings removed and no new unrouted findings, this
pre-repair report implies **836 remaining net connections plus those 12 unassigned
findings**. Reconcile that with a fresh native Board Information report and
inventory; do not present 848 as the number of remaining net connections.

No new width or antenna findings appeared. All three original shorts remain.
The trial has not completed the requested approximately 50-net exercise, and
this report does not establish fabrication or high-speed design acceptance.

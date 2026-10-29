# Read-only detail exports

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

The controller alone runs these scripts. They target the working board
`work/full-routing-2026-09-30/QCMI_SOM8MM/IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc`
relative to `astra-run/`, resolved from the loaded script project. Runtime
`runs/` paths below are also relative to `astra-run/`. They use the already
qualified exact-path board lookup and iterator pattern. They contain no routing,
selection, save, redraw, rule write, component write, object creation/removal,
or process commands.
Placement export completed in AD26; the stack and delay paths still need
qualification as described below.

## Core placement and stack export

Open [FullDetails.PrjScr](../scripts/FullDetails.PrjScr) through Altium's normal
File > Open. Select the exact entry point through File > Run Script:

| Entry point | Output under `runs/full-routing-2026-09-30/quality/details/` |
|---|---|
| `ExportFullPlacement` | `components.tsv`, `placement-board.tsv`, `placement-status.txt` |
| `ExportFullStackup` | `layers.tsv`, `stackup-board.tsv`, `stackup-status.txt` |

Create the output directory before running either procedure; it is ignored
runtime output and is not included in this repository. Both procedures reject a
missing directory or a missing/mismatched loaded board. There is no success
dialog. Require a fresh
status containing `complete`, fresh tables, and the expected board path in the
identity table. A script parse error can occur before any status write; an old
`complete` file is not a fresh result. On an Altium exception, record its exact
line, dismiss it, stop the script, and inspect the source before another run.

Placement fields are component designator, comment, footprint name, reference
X/Y, rotation, layer ID, and layer label. Expected initial native component
count is 228; reconcile the returned count. Coordinates use raw Altium units,
with `internal_units_per_mil` and board origin in the identity table. Rotation
uses degrees. No sorting, property normalization, or default values alter the
returned records. This supplies the component object evidence missing from
the base pad inventory.

The stack export reads the documented legacy `Board.LayerStack` view. Each row
records physical iteration order, actual layer name/ID, copper thickness, and
the associated dielectric's type ID, material, height, and dielectric constant.
Thickness and height remain raw coordinates. A missing dielectric object is
explicitly marked `no_object`. Repeated layer IDs or more than 64 layers fail
visibly. Check all eight expected copper layers against Layer Stack Manager;
legacy access can omit newer stack features.

These fields do not establish the net, continuity, voids, or return path of a
reference plane/polygon. No reference assignment is inferred from layer names,
and no trace width or impedance is calculated from these values alone.

Source support: Altium's [design-object API](https://www.altium.com/documentation/altium-dxp-developer/pcb-api-design-objects-interfaces-reference)
documents component name/comment/pattern/rotation and inherited group X/Y;
its [system API](https://www.altium.com/documentation/altium-dxp-developer/pcb-api-system-interfaces-reference)
documents the legacy layer iterator and dielectric properties. These references
are older than AD26 and establish API intent, not live qualification. The
installed examples directory contained no DelphiScript source examples found
by the scoped `.pas`/`.PrjScr` search.

## Separate installed-getter delay probe

[FullDetailsDelay.PrjScr](../scripts/FullDetailsDelay.PrjScr) contains only
`FullDetailsDelay.pas > ExportFullDelayDetails`. It is separate so a missing
DelphiScript delay member cannot prevent loading the core detail project.
Create its separate runtime output directory at
`runs/full-routing-2026-09-30/quality/delay-details/` before running the probe.

The probe reads all U1 pads and vias whose exact net name starts with `DRAMA_`
or `DRAMB_`. It writes `pad-delays.tsv`, `via-delays.tsv`, `delay-board.tsv`, and
`delay-status.txt`. The pad table includes full pad identity/net/location and
`propagation_delay_native`. The via table includes net/location/dimensions/span,
`propagation_delay_native`, and `delay_native`. The values are raw doubles;
the script does not assume seconds, picoseconds, package inclusion, or via
calculation semantics. It never substitutes zero after a failure.

Installed source evidence was read through .NET PE metadata, without loading
the PCB editor or invoking its API. The assembly is:

```text
C:\Program Files\Altium\AD26\System\Altium.Pcb.DataModel.Net.Interfaces.dll
ProductVersion: 26.10.1.5
Length: 4622728 bytes
SHA-256: c269de3bd40d4c8ca065171c9b6fcd0b4f869450884bb0536fa83ba7dc723e05
```

| Installed interface | Getter | Metadata signature |
|---|---|---|
| `IPadImplementation` | `GetState_PropagationDelay` | `20-00-0D`: instance, zero arguments, Double |
| `IViaImplementation` | `GetState_PropagationDelay` | `20-00-0D` |
| `IViaImplementation` | `GetState_Delay` | `20-00-0D` |

This establishes actual installed getter names and types. DelphiScript exposure
and returned units remain pending a bounded live read. If parsing rejects a
getter, keep the exact failure and use the core exporter; do not replace it with
a guessed property or hide the failure. The helper has no write path to the PCB.

The electrical reviewer independently found that 83 nonzero U1 pad delays in
the original PCB binary correlate with schematic `PINPROPAGATIONDELAY` values
as seconds. This is binary-layout inference until a native getter/Properties
value agrees. For initial cross-checks: U1-L2/L1/U2/U1 correspond to schematic
41.1/41.2/41.8/42.2 ps. Compare raw getter scale and actual native Properties;
do not add a package contribution a second time.

Altium documents that user-defined pad/via delay contributes to displayed net
delay in addition to routing delay. It does not compute pad/via delay by itself.
See [Pin Package Delay](https://www.altium.com/documentation/altium-designer/pcb/high-speed-design/xsignals/pin-package-delay).
The probe does not export total net routing delay or establish enabled
impedance-profile associations.

No source-confirmed applicable-rule evaluator has been added. Width/gap rule
selection for a particular layer/object, actual plane continuity, and profile
associations remain native inspection requirements.

## Qualification and preservation

1. Preserve the current completed base inventory, then run placement first.
   Check component count, exact designators, several positions/rotations/layers,
   full board identity, and fresh status. Record the first export as the
   immutable component baseline.
2. Run stackup separately. Check eight copper layers and compare their actual
   names/thicknesses/materials with Layer Stack Manager before using them for
   DDR planning. A successful legacy export is not proof of reference copper.
3. If needed, run the separate delay probe. Check the known U1 clock/strobe
   values and representative DDR vias in native Properties. Record units and
   getter semantics only after that check.
4. Export the ordinary inventory again and compare it with the saved pre-read
   inventory. Pads, nets, tracks, vias, rules, origin, and connection counts
   should remain unchanged. Saving/reopening is not performed by these helpers.
5. Copy completed detail outputs to an immutable batch directory before a later
   run replaces the current files. Compare all component columns as exact
   records, preserving duplicate occurrences; the base comparator still uses
   its pad proxy and does not yet ingest `components.tsv`.

Static review found no forbidden process/edit calls in either source. The
controller's placement invocation on 2026-09-30 at 05:23:04 UTC completed with
228 components, the exact full-run work path, and a fresh `complete` status.
The helper author verified these saved files without a live invocation.
An independent original-file comparison found all 228 designators, footprints,
X/Y coordinates, rotations, and layers unchanged, with zero coordinate or
rotation tolerance. It decoded `Components6/Data` and used `Texts6/Data` to
resolve the original `UL_BOX` component, whose source designator is absent.
The other 227 source designators also match their text records. Evidence is
`astra-run/runs/full-routing-2026-09-30/quality/placement-original-comparison.json`;
component comments were not part of this original placement comparison.
The saved native component table has
SHA256 `b9c56fad05bb8eb7c6cfa73fbdd9c9aa7048e80823e442598d528b7f4718a4b3`.

The controller's `ExportFullStackup` invocation failed with
`Undeclared identifier: FirstLayer`. Its status remains `read_legacy_stack`;
the controller dismissed the error and stopped the script. Do not use that
invocation's stack output. The legacy documented `FirstLayer` access is not
exposed through this AD26 script interface as written. Inspect the stack in
the native Layer Stack Manager until a separately qualified export is available.
The delay probe remains unqualified. Wrong-board rejection and broader
no-change checks still require controller evidence.

## First PMIC inventory comparison

After the PMIC export completes, preserve it under the chosen immutable batch
directory and preserve the exact eight-net request there. `001-pmic8` is the
current batch. Its allowlist is `NetR51_2`, `NetR52_2`, `NetR48_2`, `NetR54_2`,
`NetR127_2`, `NetR114_1`, `NetR111_1`, `NetR146_2`.

From `astra-run/`, after loading `. .\quickstart\enter.ps1`, set `$AstraPmicAfter`
to that completed export, `$AstraPmicNets` to its preserved allowlist, and
`$AstraPmicResult` to a new `.json` output filename. This historical comparison
requires the original run baseline and PMIC batch artifacts, which are not
included. Then run:

```powershell
$AstraPmicBoard = (Resolve-Path -LiteralPath '.\work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc').Path
uv run --locked --project .\quickstart python .\scripts\compare_routing.py `
    .\runs\full-routing-2026-09-30\baseline-inventory $AstraPmicAfter `
    --expected-board $AstraPmicBoard `
    --allowed-nets $AstraPmicNets --output $AstraPmicResult
```

This first-batch baseline is appropriate only before other full-run copper.
For later groups, use that group's saved before inventory as the first input;
also compare useful milestones with the original baseline. Review the full
per-net/geometry output and live DRC. Add paired native DRC paths only at the
planned report milestones. Exit zero is not a native DRC or timing sign-off.

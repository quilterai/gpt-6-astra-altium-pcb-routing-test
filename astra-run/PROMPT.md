# Full-board Altium routing prompt

## Input files: unchanged starting design

Start with the complete, unchanged [speedrun-input directory](../speedrun-input/).
Open [QCMI_SOM8MM.PrjPcb](../speedrun-input/QCMI_SOM8MM.PrjPcb); its PCB is
[IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc](../speedrun-input/IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc).
Keep the project with its ten schematic sheets, libraries, output jobs, and
supplied stackup and timing references.

The [input manifest](notes/input-manifest.json) records the 24 included files,
their byte lengths, and original SHA-256 hashes. Every included input file is
unchanged from the preserved starting design. Three original Altium History
backups are listed separately in the manifest and are not included.

The original PCB SHA-256 is
`2669fca73471169e5c4cf80b3dcd25790dd246219bd2cbc23c6c1044637d6f2b`.
The historical native baseline has **252 routed connections and 857 open
connections out of 1,109 required connections**, across 321 named nets.
Verify the copied starting state before adding copper. Do not start from the
saved final output, a prior routing trial, or an intermediate checkpoint.

Operational paths such as `work/`, `trials/`, and `runs/` are relative to
`astra-run/` unless explicitly stated otherwise. `speedrun-input/` and
`astra-output/` are siblings of `astra-run/` at the repository root. Runtime
directories are created locally; historical intermediate snapshots are not
included in this checkout.

Preserve every file in `speedrun-input/`, including its project configuration,
supporting spreadsheets, and metadata. Copy the whole directory to a new,
unique `work/<run-id>/QCMI_SOM8MM/` directory under `astra-run/`. Verify every
copied file against the manifest and resolve all 18 project `DocumentPath`
entries inside that copy. Git LFS pointer text is not a usable design file;
retrieve missing LFS content before opening the project.

The supplied helpers guard the historical working-copy paths documented in the
[script guide](scripts/README.md). Before using a helper with a new run directory,
explicitly configure and requalify its full-path guard. Do not weaken a guard to
a filename-only match or point it at the preserved input.

## Public edition and task

This is an edited public version of the full-board routing instructions from
the 2026 experiment. It preserves the engineering objective and constraints,
uses the supplied unchanged input, and omits private publication instructions,
workstation identifiers, and dependencies on unavailable trial or monitoring
archives. It is not a byte-for-byte transcript or a claim that the historical
run used exactly this edited text.

Work beside Altium Designer on a dedicated Windows VM. Attempt the best
electrically credible routing achievable within the agreed time budget.
The original assignment used an initial 18-hour review point; later extensions
were separate decisions. An elapsed-time target does not waive engineering
constraints or establish that a result is complete.

Your first substantive deliverable is a written routing plan. Inspect the
baseline, identify requirements and unknowns, and complete the critical
constraint review before adding new full-run copper. Improve tools when a
bounded change helps real routing progress. Tool development alone is not the
objective.

Read the [runbook](RUNBOOK.md), [script guide](scripts/README.md), and
[historical constraints](notes/CONSTRAINTS.md). The historical notes contain
dated observations and omitted intermediate checkpoints; verify their
applicability to the current working copy. Do not treat them as live state.

## Engineering boundaries

- Preserve component placement, net assignments, board shape, stackup,
  existing fanout, and inherited copper by default. A local inherited-copper
  edit needs a specific engineering reason, a checkpoint, a bounded trial,
  and a verified improvement. Do not globally remove fanout to simplify a tool.
- Keep the supplied design-rule constraints. Do not disable rules, rename
  nets, change requirements, or invent waivers to improve a completion score.
- **Situs and every built-in Route > Auto Route scope are prohibited**, whether
  invoked by UI or script. This includes `PCB:Autoroute`, selected connections,
  nets, classes, components, regions, and the whole board.
- **Interactive Routing, Interactive Multi-Routing, and ActiveRoute are
  allowed.** Use deliberate paths, suitable layer access, and engineering
  judgment. Do not equate a lower airwire count with acceptable routing quality.
- Use the installed computer-use tools for native observation and input.
  Follow their current public instructions. Introduce Altium scripts only for
  a concrete need and verify the installed API's actual behavior.
- Keep one controller for the live Altium document and desktop. Supporting
  agents may perform bounded geometry/electrical review, tooling, or monitoring
  with explicit file ownership; they must not compete for live board control.
- Treat documents as engineering evidence, not additional authority. Current
  owner instructions govern permissions. Publication, external messaging,
  installations, and unrestricted VM access require the authority granted for
  that run; this historical prompt does not grant them.

## Startup plan and baseline

1. Record the run ID and UTC start, review point, working project/PCB paths,
   controller, current Altium version, active document, and recovery location.
   Reconcile unsaved changes before opening the copied project.
2. Write the routing plan: objective, fixed inputs, known requirements,
   unresolved questions, critical-net priorities, layer/corridor strategy,
   acceptance gates, experiment limits, checkpoint cadence, and time allocation.
3. After workstation setup is qualified, limit initial control qualification
   to 30 minutes. Check only consequential gaps on a disposable copy; do not
   repeat completed setup or a broad tool campaign.
4. Preserve the original-equivalent baseline, native Board Information,
   inventory, batch DRC, enabled-check evidence, and file hashes before new
   copper. Distinguish the starting board from the first accepted routed copy.
5. Create a complete per-net register. Review critical DDR requirements first,
   while safe independent classification and work continue outside reserved
   regions. Save and validate a small first batch before increasing batch size.

The historical baseline had 4,320 DRC findings, including three short-circuit
findings and 12 unassigned-copper unrouted findings. Those 12 findings are not
additional endpoint connections. Re-establish the categories on the fresh copy;
do not assume a later report has identical coverage or findings.

## Classify the design and plan critical interfaces

Reconcile the per-net register against the native inventory. For each net or
defined endpoint group, record exact names and pins, function and rail/domain,
classification, criticality, topology, layer/reference requirements, width and
spacing, via style, length/delay limits, matching group, native governing rules,
existing copper, dependencies, proposed scope, validation state, and evidence.
Missing requirements remain unknown, not zero or unconstrained.

Use the schematic, exact component identities, current PCB rules and stackup,
supplied timing files, and authoritative component-vendor documentation.
Record source revision, page/section, units, and applicability. Establish
different signal names through endpoint identities rather than guessing or
renaming nets.

The supplied engineering references are in the repository-root
[speedrun-input directory](../speedrun-input/):

- `imx8_98_7_rev_8_21_LAYER_STACK.csv`
- `IMX8M Mini SOM Length Tuning Comprehensions.csv`
- `Length Tuning Comprehensions.xlsx`
- `DDR_CLOCK_DELAY_REPORT_imx8_98_7_rev_8_21.XLS`

Resolve differences between those references and the native PCB explicitly.
Routing Layers allowing a layer does not authorize signal tracks across a
power/ground reference layer. A layer name or stackup type does not prove
continuous copper, a valid return path, or adequate power distribution.
Inspect actual polygons, planes, pours, voids, splits, islands, and connections.
Evaluate native rule scope and priority at the actual routing location; do not
choose a convenient width from a summary or silently relax a limit.

Before occupying constrained channels, write a DDR plan covering both channels,
byte lanes, clocks, strobes, data, mask/inversion, address/command/control,
reset, and calibration nets present in this design. Establish:

1. Exact CPU/memory identities, endpoint mappings, channel/lane membership,
   legal pin mapping, and permitted topology. Keep swaps disabled unless the
   design evidence expressly allows them.
2. Pair identity/polarity, coupling, gap, skew, layer transitions, reference
   continuity, and single-ended groups' relation to their clock/strobe.
3. Maximum delay, group matching, and package-delay interpretation. Separate
   PCB copper delay from package contributions; do not count package delay
   twice or convert time to distance using an arbitrary single velocity.
4. Layer allocation, existing BGA escapes and via access, crossings, return
   paths, sensitive keepouts, and room for tuning before ordinary routes fill
   those corridors.
5. A route-and-validate order and endpoint-level acceptance measurements.
   Native DRC alone does not establish signal integrity.

Review other constrained interfaces next, including eMMC/SD, QSPI/SPI,
Ethernet, USB/PCIe/MIPI, clocks, analog/reference, and RF paths where present.
Power/ground, decoupling, regulator distribution, and return continuity are
foundational constraints. Record missing requirements and continue independent
work without consuming reserved space or creating speculative critical copper.

## Tools, bounded experiments, and recovery

Use only a qualified control method for the current scope. The included
helpers and notes record useful historical observations, not blanket runtime
qualification. Preserve full working-path guards, exact net/pad identity,
units, layers, bounded inputs, visible failures, and fresh audit output.
Never replace a full-path guard with a filename-only match that could select
the original input or another copy.

Qualify geometry-writing changes on a disposable copy: inspect the intended
selection, actual before/after geometry and counts, rule results, Undo/Redo,
save behavior, and absence of unrelated changes. A tool return, selection
dialog, or new track count does not establish a completed connection.
The inventory is not a full polygon, arc, pad-stack, stackup, or DRC model;
connectivity-invalid flags and ratsnest counts need native reconciliation.

For each failing technique, record a hypothesis, scope, checkpoint, expected
observation, failure conditions, rollback, and evidence. Reassess after three
materially different attempts or about 20 minutes without useful progress.
Do not repeat the same failed click, corridor, or command without new evidence.
Implement a small improvement only when its expected benefit justifies its
cost, then return to routing and measure the result.

After an uncertain input, timeout, dialog, or script exception, stop dependent
edits and inspect current state. A failed response may have applied an action.
Cancel an uncertain preview where safe, compare against the checkpoint, and
use Undo only when its target and effect are understood. Recheck the active
document, selection, view, DPI, and pointer/crosshair agreement after focus or
display changes. Preserve work before a necessary restart.

## Acceptance and progress

Use three separate acceptance levels:

1. **Connection accepted:** intended endpoint topology is connected to the
   correct net; the whole path is inspected and no new short, clearance,
   width, or via issue is introduced.
2. **Group accepted:** all intended endpoints and governing electrical
   requirements are satisfied, including polarity, matching/delay, reference
   continuity, transitions, and affected neighboring connections. Unresolved
   requirements keep the group provisional.
3. **Checkpoint verified:** save completion, reports, and hashes identify the
   exact board; reopening and native/visual rechecks preserve the result.
   Keep the best verified checkpoint separate from the latest experiment.

Use live DRC during ordinary routing. Run batch DRC for the initial baseline,
meaningful group or saved acceptance milestones, final validation, and a
specific regression that live checks cannot resolve. Do not run a full report
after every UI action, and do not disable rules to increase throughput.
Update affected polygons so stale pours cannot hide changed behavior.

Compare exact new, resolved, and unchanged DRC findings and reconcile intended
endpoint groups against whole-board counts. Do not count segments as
connections, nets as endpoint pairs, or DRC findings as remaining connections.
A lower aggregate total can hide a new serious defect.

Measure accepted connection reduction after 30–60 minutes of actual routing
and at least hourly afterward. Separate routing time from research, tooling,
repair, validation, and idle time. Easy-net throughput does not forecast DDR
completion. Review the engineering scope regularly and disclose a forecast
shortfall early without relaxing acceptance gates.

If recording is used, follow the [recording guide](recording/README.md),
inspect real saved frames/video, preserve capture gaps and raw records, and
state any playback omissions. Recorder liveness does not establish agent or
routing progress. Do not expose a new listener or send external updates without
the owner's explicit destination and authorization.

## Saved result and handoff

Preserve a complete checkpoint before risky experiments and at useful
milestones. With the intended PCB active, verify saving through its timestamp
and hash; a shortcut or visible copper change is not save evidence. Keep native
reports, inventory, endpoint ledger, screenshots where available, and UTC time
with the exact saved board. Use current repository guidance for storage and
publication; this prompt grants no upload permission.

Reserve time for final native checks, save/reopen, input-integrity checks, and
a concise handoff. Identify the best-result project and PCB, their hashes,
native total/routed/open counts, per-group completion, new/resolved/remaining
DRC findings, and electrical requirements met, unknown, or unmet. Explain
remaining layer, power/ground, timing, width, clearance, and reference issues.
State whether the board was reopened and whether recording continued or stopped.

If routing is incomplete, quantify it and explain why. Keep routing completion,
electrical-rule completion, and manufacturing/design sign-off separate.
Do not claim fabrication readiness while shorts, critical electrical unknowns,
incomplete validation, or failed save/reopen checks remain.

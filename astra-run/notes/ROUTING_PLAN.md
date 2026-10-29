# Full-board routing plan

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

Run: `full-routing-2026-09-30`. Start recorded at 2026-09-30 04:33:43 UTC;
initial 18-hour review point: 2026-09-30 22:33:43 UTC.
This initial plan precedes all full-run copper edits.

## Objective and authority

Produce the best electrically credible routing of QCMI_SOM8MM within the run
budget. Start from a complete verified copy of preserved input. Preserve placement,
net assignments, shape, stackup, fanout, and inherited copper. All design rules
and component positions are immutable. The user confirms that this board has
been fully routed with the given inputs; resolve interpretation issues within
those inputs. Keep an intact
baseline and a best verified checkpoint separate from current experiments.
Situs and every Auto Route scope are prohibited. Use Interactive Routing,
Interactive Multi-Routing, or selected-net ActiveRoute with deliberate paths.
Preserve complete verified checkpoints and their validation evidence.

The main controller alone operated the live Altium document and desktop and
integrated code changes. A monitoring agent maintained progress observations.
Two supporting agents prepared bounded geometry and electrical reviews in
separate run directories; they could not execute live Altium scripts or edit
the active project. These role descriptions do not establish exact supporting
model identities or a controlled single-model-only experiment.

## Current queue, October 2 at 05:33 UTC

Saved checkpoint099 has 1,076 of 1,109 required connections complete, with
33 remaining. Batch571 completes ENET_TD1; batch583 restores VDD_3V3 after
repour. Aggregate584 confirms exact copper and preserves all earlier
connections.
Planner579 repairs SD2_WP in the SD3_DATA1 proposal before application;
planner582 prepares BT access. Incomplete574/575/577/578 proposals
remain unapplied.

Search current connectivity trees for alternate access before repeating a
blocked pad window. Where a small inherited fanout change can resolve a
specific obstruction, document its reason and exact geometry, preserve a
checkpoint, and require a bounded native trial with verified improvement.
Component positions, pads, design rules, and net assignments remain fixed.

Use connected local replacements where run-added tracks block a remaining
pad escape. Preserve each affected net through explicit endpoints and native
comparison after repour. Reserve proposed copper between agents, then rebase
each request on the last actual inventory. Stop a failed local search after
its bound and record the obstruction before selecting another connection.
The controller applied prepared batches while supporting review agents
prepared the next paths. Useful results were saved as complete checkpoints.
Final native DRC and reopen remained deferred at this planning stage.

For differential nets, use the dominant differential rule's per-layer width
fields. Its summary spans all layers and is not a width range for each layer.
DiffPairsRouting and 100OHM_MIPI specify 3 mil on Top/Bottom and 15 mil on
inner layers in the preserved rules. Keep existing low-clearance endpoint
geometry unchanged where possible; do not expand a connection task into
unrelated DRC repair before full connectivity.

## Routing priority

After 100% connectivity, remove routing from GND layers, move all
controlled-impedance routing off PWR layers, and verify DDR byte-lane grouping,
layer assignment, and delay matching against the controller, memory, and
applicable DDR standard. Preserve design rules and component positions.
Connectivity alone does not complete these requirements. Then run the final
native DRC and save/reopen checks, resolving findings before sign-off.

Increase completed connections and whole nets before further DDR length tuning.
Preserve the DDR corridor, escapes, and transition reservations. Use larger
groups of ordinary and single-ended interface nets, then supply connections.
Check actual remaining counts after each useful group. Defer batch DRC until
routing ends. Keep exact primitive readbacks, native inventory, saves, and
bounded offline geometry screens. The dashboard's primary counter uses all
1,109 connections; the 321 named-net inventory is a separate measure. A failed
native routing pass leads to checked access or explicit paths, not repeated
attempts with the same inputs. Reviews have two-to-five-minute limits and do
not block independent routing. Preserve saved checkpoints and unchanged rules
and placement throughout.

## Starting evidence

The original PCB hash is documented as
`2669fca73471169e5c4cf80b3dcd25790dd246219bd2cbc23c6c1044637d6f2b`.
Verify all original and copied files before opening the new project.
From `astra-run/`, use
`work/full-routing-2026-09-30/QCMI_SOM8MM/`; preserve an unopened copy
under `runs/full-routing-2026-09-30/baseline-unopened/QCMI_SOM8MM/`.

Historical baseline: 321 nets, 1,593 pads, 372 vias, 1,109 native connections,
252 routed and 857 remaining. Historical DRC: 4,320 findings, including three
shorts and 12 unassigned-copper unrouted findings separate from connections.
These values are provisional until fresh native reports and inventory agree.
The setup trial is a separate result: 18 newly complete nets and 20 fewer
remaining connections. Its copper is not the starting full-run board.

Live discovery identifies Altium Designer 26.10.1. The first fresh capture shows
the PCB canvas in a 3364 by 1876 window, without a routing preview. Exact loaded
file path still needs independent verification before any board edit.

Input verification passed for all 27 original manifest files. Both the fresh
working project and unopened baseline contain 28 identical files: the extra
`QCMI_SOM8MM.PrjPcbStructure` is a generated file retained from the source.
All 18 source `DocumentPath` entries resolve inside each copied project.
Copy manifests are under `runs/full-routing-2026-09-30/`.

## Constraint review and reserved space

Resolve the exact CPU and fitted LPDDR4 part, channel and byte membership,
endpoint mapping, topology, package-delay interpretation, and native rules
before critical routing. Swapping stays disabled. The supplied timing worksheet
and existing DDR_CK_DQS maximum-delay rule appear to disagree about DQS limits;
retain that conflict until authoritative evidence resolves it.

Reserve the complete CPU-to-LPDDR4 region, both device escapes, and adjacent
tuning space for critical paths. The 08:33 review assigns current DDR routes
to Top/Bottom and permits provisional ordinary L3 paths beneath that region
where they preserve reference copper and planned through-via clearances.
Batch018 replaced the part of UART3_RXD that blocked three pair/return sites
and a data-via reservation with a checked local detour. Fresh-check
every later DDR via and do not assume L3 fallback space remains available.
The review is `electrical/ddr-l3-016-transition-review.json` under the run.
Treat `NetR7_2` as DRAM calibration, not an ordinary resistor net.
Review eMMC/SD, QSPI, Ethernet, USB/PCIe/MIPI if fitted, clocks, crystals,
references, and power distribution next. Identify every remaining net in the
register, including generated names and nets with no visible airwire.

Layer strategy is provisional: use L1_PS and L8_SS for proven local surface
connections. Read the actual Layer Stack Manager and inspect copper/reference
continuity before allocating internal signal layers. Names such as GND/PWR and
an all-layer Routing Layers rule do not establish usable signal layers or
continuous references. Resolve CSV versus PCB layer names, 2.2 mil impedance
widths versus the general 3 mil minimum, and rule priority at actual endpoints.
No guessed impedance, delay-to-length conversion, or rule relaxation is allowed.

## Work queue and routing order

1. Verify and preserve input/copy hashes and project dependencies. Publish the
   audited setup handoff. Start fresh monitoring with honest planning status.
2. Open the fresh work project; export inventory with full-path guards, run
   native baseline Board Information and DRC, verify online rule checks, and
   inspect actual stackup and reference copper.
3. Complete the critical DDR corridor review and initial all-net register.
   Resolve a group's governing requirements before editing its copper.
4. Save a small production batch of local PMIC controls near U8, outside the
   DDR region, after exact endpoint/rule review. Reuse qualified selected-net
   Top ActiveRoute where appropriate. Validate and reopen before enlarging scope.
5. Route verified DDR groups in the order established by
   [DDR_PLAN.md](DDR_PLAN.md); preserve tuning room. Work on independent
   peripheral groups when a critical fact is missing. Connector groups need a
   real layer-access plan, not long detours.
6. Complete other interfaces, ordinary controls, and power/ground connectivity
   according to dependencies. Review plane/polygon islands, shorts, antennas,
   transitions, reference continuity, and critical timing throughout.
7. Preserve the best result, run final native validation, save/reopen, verify
   input integrity, publish through LFS, and write the exact continuation queue.

## Acceptance and evidence

Keep online DRC active for clearance, shorts, width, and via checks. Inspect
whole paths, pad exits, actual nets, and neighboring copper. Refresh affected
polygons after transitions. Use inventory and endpoint comparisons between
batches; run batch DRC at baseline, meaningful acceptance milestones, final
validation, or a diagnosed issue that online checks cannot settle.

A connection is accepted only with intended topology and no new electrical
defects. A group is accepted only when its electrical constraints are met;
unknown requirements keep it provisional. A verified checkpoint requires saved
file identity, native reports, exact deltas, complete dependencies, hashes, and
a successful reopen. Main-window File > Save plus disk timestamp/hash evidence
establishes saving. Native connection counts, net counts, segments, and DRC
findings remain separate measurements.

Retain exact new/resolved/unchanged DRC findings, not just aggregate counts.
Inherited shorts remain blockers to electrical sign-off. Existing fanout edits
require a bounded local reason, checkpoint, trial, and verified improvement.

## Time and experiment limits

Recovery at about 17:00 UTC retains checkpoint 009 with 623 remaining
connections, 486/1,109 routed (43.82%), and 72/321 whole nets connected
(22.43%). Batch 022 completed 234 connections from the original 857. The last
hour of routing before interruption reduced 729 to 623, though power/GND work
does not forecast the pace of critical DDR completion. Native DRC preserves
the prior clearance, short, width, and via findings; four signal-access antennas
and earlier electrical acceptance issues remain open.

The user grants roughly 24–36 further hours from this recovery. Plan against
the earlier October 1 17:00 UTC cutoff, protecting the final three hours for
repair, native validation, save/reopen, and publication. This leaves about
21 hours for the remaining connectivity and critical timing work, requiring
about 30 connections per hour before difficult validation work. Review actual
group completion and throughput every two hours; do not count the idle period
as routing time or assume easy power groups predict DDR progress.

First verify the reopened checkpoint inventory and preserve the recording
gaps and source-frame history. The immediate copper queue is three local sense nets, two ordinary
L3 signals, the checked six-via/fourteen-track NVCC/C324 source/ground access,
and a bounded L5 NVCC polygon qualification. Continue VDD_3V3 source distribution
and other rails in parallel with electrical review. Qualify exact local track
removal for the two UART1 detours and then apply the checked DDR pair/CA repairs.
Avoid another general tool campaign; each new capability retains the existing
20-minute trial bound and must support a concrete connection or repair.

The following reviews record the earlier pace before the interruption.

At 09:27 UTC the exported remaining count is 692, down from 729 at 08:29
and 857 at baseline. The whole-run average is about 34 fewer connections per
hour. There are 72/321 complete nets (22.43%) and 417/1,109 routed connections
(37.60%). Batch018 repaired the PMIC/BOOT crossing and UART3 via obstruction;
batch019 added no non-airwire DRC findings. These connectivity measures do
not establish DDR acceptance.

Apply the prepared local capacitor supply and connector-bank connections,
finish the three local sense paths and two ordinary nets with new access,
then save, reopen, and publish a checkpoint. Qualify removal in one bounded
trial, remove only the identified batch007 UART1 detours, and reconnect those
signals east of DDR. Use the prepared A_CA0 and paired-strobe repairs for the
next critical group. Keep ground and main power-feed design moving in parallel.
An explicit L5 NVCC_DRAM polygon could connect the existing memory and CPU
rail vias; a small guarded polygon helper is the only new geometry capability
currently needed. It requires a checkpoint and a bounded native qualification.
The initial review point remains 22:33:43 UTC, about 13 hours away. Completing
the remaining connectivity alone needs about 53 connections per hour, before
timing, residual shorts, and final acceptance. Larger checked power/GND groups
are the immediate throughput priority. Reassess after the next checkpoint.

At 06:28 UTC the measured pace was below the required rate: 20 new connected
nets and 20 fewer remaining connections after almost two hours, with only the
eight PMIC connections accepted. This is 23/321 whole nets connected (7.17%)
and 272/1,109 connections routed (24.53%). The original had three complete
nets and 252 routed connections. These measures must not be interchanged.

The controller will use larger ordinary-net ActiveRoute batches outside the
reserved DDR region while agents prepare checked layer-access and local GND
connections. Existing helpers are sufficient. Native export comparisons will
measure each batch, with full DRC and save/reopen at useful milestones. Keep
DDR width/timing findings open while independent routing proceeds. Reassess
throughput after the next hour; avoid spending another hour on helper setup.

Initial tool qualification ends by 05:03:43 UTC (30 minutes). Reuse installed
controls and qualify only needed gaps on a disposable copy. A later new control
experiment is limited to three materially different attempts or about 20 minutes
unless a specific new lead warrants a documented extension. Record hypothesis,
scope, starting checkpoint, expected result, failure/rollback, and evidence.

Provisional allocation: first hour for baseline/constraints and first accepted
batch; next six hours for DDR and constrained interfaces with independent work
in parallel; next eight hours for remaining groups and repairs; final three hours
for difficult residual work and acceptance, with the last hour protected for
save/reopen, validation, and publication. Adjust from measured progress.

Measure accepted connection reduction after 30-60 minutes of routing and hourly
thereafter. Report actual routing time separately from research, tool work,
rework, and validation. Reassess engineering scope every two hours. A complete
857-edge reduction in 18 hours needs about 48 per wall-clock hour; this is a
feasibility reference, not an acceptance waiver. Update the forecast early if
critical constraints or measured throughput make completion unlikely.

Preserve concise notes, tools, and complete verified checkpoints at useful
milestones. Keep progress records current. Recorder liveness does not establish
routing progress or automatic agent continuation.

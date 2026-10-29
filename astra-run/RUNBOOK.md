# Runbook

These procedures describe the routing experiment and how to work from its saved
files. The [notes](notes/STATUS.md) record the original run. Read the repository
[contribution rules](../AGENTS.md) before changing or publishing files. A listed
component is not running or qualified until the current environment proves it.

Use `astra-run/` as the working directory for the relative operational paths
below. From the repository root, enter it with `Set-Location .\astra-run`.
The original input is `../speedrun-input/`; the saved result is
`../astra-output/`. Bootstrap creates the local tool directories. Create each
run's `runs/<run-id>/`, `work/`, `trials/`, and optional `results/` directories
as needed; these ignored runtime artifacts are not part of the checkout.
Keep new run records under `runs/<run-id>/notes/` so the historical `notes/`
remain a record of the original experiment.

## Routing tool limits

Situs and the built-in **Route > Auto Route** commands are prohibited for both
trials and the full run. This includes connection, net, net-class, component,
area, and whole-board scopes, whether invoked through the UI or a script.
Do not use `PCB:Autoroute` or another process call to invoke these commands.

Allowed routing tools are **Interactive Routing**, **Interactive Multi-Routing**,
and **ActiveRoute**. Scripts may support inspection, exact selection, and
validation within the authorized scope. Aim for human-quality routes with
deliberate paths, clean pad entries, and rule compliance. A completed connection
count alone does not establish acceptable routing quality. Technical references
to Situs describe software behavior; they do not authorize its use.

## Control Altium

Use computer-use tools supported in your current environment and follow their
public documentation. Qualify window discovery, screenshots, and input before
editing. Select the current Altium window and inspect fresh state after each
action. Use accessibility elements when available; the PCB canvas may provide
no accessibility text, so screenshots are required for geometry and visual checks.

If capture reports that Altium is minimized, activate it and refresh the window
object. Restoration in this session sometimes produced a small window. After
dismissing its modal, `Alt+Space` followed by `x` in a separate call recovered
the maximized view. Verify screenshot dimensions as well as image contents:
the tool sometimes showed an old large image for a 129 by 77 window. A screenshot can
show an occluded window while input still requires the target to be active.
Recover focus and inspect again if an input reports a different foreground app.
Do not reuse coordinates across these transitions.

Altium can return several transient images, including menu shadows. Match the
visible menu or dialog to its screenshot ID and dimensions before clicking;
the second image is not always the intended control. The qualified restart and
saved-layout repair are documented in [Views](notes/altium/VIEWS.md).

RDP connection changes can replace the display adapter and change DPI. Read
[persistent desktop setup](quickstart/DESKTOP.md), verify the current console
layout and recovery task, and take a new window snapshot before further input.
The configured console display is 3364 by 1924. The recorder captures physical
window pixels through Windows.Graphics.Capture and rejects frames if bounds or
DPI change during capture. Check the actual saved image after each transition;
pixel dimensions alone did not detect the earlier PrintWindow crop.

For PCB pad and track clicks, use the tool's supported pointer-move action first,
then capture and inspect the pad/net or routing preview. Click those coordinates
in a separate call and inspect again. In the
trial, movement and clicking together sometimes used the previous canvas cursor
position and created a `No Net` track. Cancel an uncertain command and inspect
the result before undoing; never repeat a click blindly. `Ctrl+W` started
Interactive Routing in the tested PCB canvas. `Page_Up` and `Page_Down` zoomed
about the cursor; a normal wheel scroll panned the canvas.

Use PowerShell for copying, hashing, process inspection, and Git. Python media
helpers are isolated under `quickstart/`; they are not a second desktop input
system. Introduce Altium scripts only for a concrete need, such as exporting
board rules or checking object counts. Verify installed API behavior and observe
the result; do not assume scripting can drive the whole interactive router.
See [the script guide](scripts/README.md) for tested inventory access and
[the Altium reference](notes/altium/README.md) for view and routing procedures.

## Copy and open a project

1. Identify the exact input `.PrjPcb` and `.PcbDoc` paths. Inspect Altium for an
   active command or unsaved changes before copying; reconcile any such state.
2. Hash every file in `../speedrun-input/` with SHA-256. Compare relative
   paths, byte lengths, and hashes with the supplied
   [input manifest](notes/input-manifest.json). Preserve that manifest and
   record the fresh verification under `runs/<run-id>/`. Retrieve any missing
   LFS content before hashing; a pointer file is not the native design.
3. Read each `DocumentPath` in the `.PrjPcb`. Verify the referenced file exists
   and resolves inside the input directory. Resolve external dependencies before
   declaring the copy complete. These checks cover project documents, not all
   possible managed-library or account dependencies.
4. Copy the whole directory to a new `work/<board>/` with PowerShell
   `Copy-Item -LiteralPath ... -Destination ... -Recurse`. Check that the
   destination is under this workspace and does not already exist. Preserve
   schematics, libraries, variants, output jobs, and supporting timing/stackup
   files. Compare the complete copied file list and hashes with the manifest.
5. In Altium, use the input project's context menu to **Close Project**. Inspect
   any save dialog before proceeding. Use **File > Open** and enter the absolute
   path to the copied `.PrjPcb`. Open its `.PcbDoc` from the Projects panel.
6. Verify the working path in Altium, not just the matching project name. Inspect
   the loaded board and confirm that original file hashes still match. Record
   the verified path and result in status. Do not edit the original project.

## Qualify for unattended routing

These steps belong to routing preparation after the plan defines the objective.
Exploration and project copying do not establish unattended readiness.

1. Record Windows, GPU/driver, Altium, agent, and dependency versions. Use
   `quickstart/bootstrap.ps1` for a fresh installation. Verify the intended model
   and effort in the actual agent session; a CLI launcher does not configure the
   desktop app's current chat.
2. Prove a reversible edit, save, reopen, and fresh observation on a disposable
   working copy with the installed tools. Keep one writer to the document and
   desktop. Verify checkpoints before relying on them for recovery.
3. Record the input project and objective in status: board identity, fixed versus
   editable placement, stackup, constraints, and completion criteria. Hash the
   original inputs. Missing design requirements must not become guessed facts.
4. Verify the independent screenshot recorder described below. Inspect
   actual frames with Altium open, covered, minimized, and after viewer disconnect.
   Choose a capture method based on those results. A successful API return does
   not establish that a DirectX window was captured correctly.
5. Agree on reporting in the routing plan. A separate notifier needs a designated
   destination and authorization to send messages. Verify delivery if configured.
6. Choose continuation and supervision for the actual agent session. Use existing
   runtime facilities where sufficient; add an SDK supervisor only for a verified
   gap. Persist session identity, process outcomes, and the last checkpoint. Do
   not infer completion from an exited process or blindly repeat an edit.
7. Test controller interruption and recovery. Then test VM reboot recovery in the
   actual desktop/session configuration. GUI tools need the interactive user
   session; a background Windows service or a scheduled task in a noninteractive
   session is not sufficient evidence of desktop access.
8. Keep the agent and recorder running after the user's viewer disconnects.
   Verify input, new frames, save/reopen, and a delivered update. Record the
   evidence. Disable sleep and schedule maintenance outside the run as needed.

Altium installation, account sign-in, the actual GPU driver, desktop persistence,
the recorder, notifier, and supervisor need instance qualification. Do not report
the run as ready based only on package installation.

## Work and checkpoint

- Keep `runs/<run-id>/notes/STATUS.md` short: objective, actual state, current
  session, latest checkpoint, best verified checkpoint, active task, next actions,
  and blockers.
- Put decisions and experiment outcomes in `runs/<run-id>/notes/DECISIONS.md`.
  Add focused notes by net or region only when needed; index them from status. Avoid a growing
  transcript in the working context. Distinguish observations from hypotheses.
- At a meaningful checkpoint, finish or cancel the active interactive command,
  save the project, and create a complete project snapshot with its dependencies.
  Confirm saving finished before hashing. Associate its UTC checkpoint ID with
  file hashes, reports, notes, and the Git commit. An incomplete checkpoint is
  not eligible for recovery.
- Use local `runs/<run-id>/` for frequent snapshots, raw reports, screenshots,
  and tool logs. Keep selected local snapshots under `results/`; these runtime
  directories are ignored. Review artifacts before explicitly adding them to a
  publication commit. Commit concise notes that explain verified work.
- Keep the best verified board independently of ongoing experiments. Reopen and
  inspect a restored checkpoint; do not assume an undo stack survives a restart.
- On context compaction, reread status and relevant notes, then inspect live
  state. On process or VM failure, resume the recorded session and reconcile
  unsaved work before modifying the board. Never blindly replay timed-out edits.

## Timelapse

Run capture outside the agent's reasoning loop. Default to one Altium-window
frame every five minutes; adjust the interval for the actual run.
Retain UTC timestamps, window identity, capture errors, and an explicit gap
record. Do not change foreground focus or move the viewport merely to capture.

Keep source frames in `runs/<run-id>/frames/` and encode a local video with the
installed FFmpeg binary. Include elapsed time in the output. Missing, blank, or
stale captures require investigation and visible status. Do not substitute
captures of another application or silently fill missing frames. A static board
can legitimately produce identical frames; repeated pixels alone are not proof
of a frozen recorder. The recorder must expose a recent heartbeat independently
of frame content.

The implemented recorder is in `recording/`; its README documents capture,
resume, graceful stop, limits, and tests. It captures only the verified Altium
window, writes the manifest atomically, and rebuilds the cumulative MP4. WGC
capture passed an RDP scaling/disconnect test. Covered capture and recovery after
minimization were checked with the earlier backend and need WGC qualification.
Keep Altium restored during recording; minimized windows produce explicit gaps.

## Recorder checks

Use the commands in [the recorder guide](recording/README.md) to start capture,
inspect its manifest and heartbeat, and stop it gracefully. Inspect the first
saved frame and cumulative MP4, then confirm a later frame and heartbeat arrive.
Keep process receipts under `.runtime/` and capture files under `runs/`.

Record routing progress separately in working notes: capture activity does not
establish routing progress. Verify desktop persistence and recovery on the actual
Windows VM before relying on unattended recording.

## Updates and completion

The proposed routing-run default is a concise update every two hours: checkpoint, verified progress,
current activity, remaining issues, and usage/budget status when available.
Notify immediately on completion, a required user action, or an unrecoverable
failure. Avoid including credentials or design attachments in messages.

If a separate monitor is configured, use it to report stale agent or recorder
heartbeats.
If the VM itself stops, an in-VM notifier cannot report that failure: arrange
provider-side monitoring through an explicitly configured destination. Do not
claim this is covered by an in-VM supervisor.

Use judgment about continuing while productive. When stopping, preserve the best
verified result and report remaining connections/violations, validation limits,
approaches tried, and why further work is unlikely to help. Save and notify on
quota exhaustion; treat it as an interruption, not completion. Never make
unbounded automatic retries of a repeated failure.

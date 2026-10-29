# Altium timelapse recorder

This process records only Altium's main window. It does not activate, restore,
move, resize, or send input to any window. Every capture checks the current
window title and `X2.EXE` process, then targets that exact HWND with
Windows.Graphics.Capture through pinned `windows-capture` 2.0.1.
It never substitutes a desktop screenshot when capture fails.

Every fresh capture worker sets per-monitor DPI awareness before reading window
bounds or starting capture. It copies the native BGRA pixels before stopping
capture, uses their physical size without scaling, and checks that size against
DWM's visible window bounds. A display, bounds, or DPI change during capture
rejects that frame. Each later worker reads the current display state again.

Run commands from `astra-run/` after completing the
[Windows quickstart](../quickstart/README.md) and loading the isolated tools:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
. .\quickstart\enter.ps1
uv run --locked --project .\quickstart python .\recording\recorder.py --run-id capture-qualification --once
```

`--once` captures and encodes one frame, appends it when resuming the same run,
and returns a nonzero exit code if capture or encoding fails. Inspect the PNG
and MP4 before starting a long run. Use the interactive Windows user session
that owns Altium; the tool sandbox may not see that session's windows.

For recording outside the agent's reasoning loop, start a hidden process:

```powershell
$AstraRun = 'setup-2026-09-29'
$AstraRunDirectory = Join-Path (Get-Location) "runs\$AstraRun"
New-Item -ItemType Directory -Path $AstraRunDirectory -Force | Out-Null
Start-Process -FilePath (Get-Command uv).Source -WindowStyle Hidden -WorkingDirectory (Get-Location).Path -ArgumentList "run --locked --project .\quickstart python .\recording\recorder.py --run-id $AstraRun" -RedirectStandardOutput (Join-Path $AstraRunDirectory 'recorder.stdout.log') -RedirectStandardError (Join-Path $AstraRunDirectory 'recorder.stderr.log') -PassThru
```

The default interval is 300 seconds, with an immediate first capture. A separate
thread updates `heartbeat_utc` every 15 seconds while capture and encoding run.
The capture subprocess has a 30-second timeout; FFmpeg has a 180-second timeout.
The recorder keeps trying on the capture interval after a failure and records
each failed capture as a gap. It does not change Altium to recover it.

Stop after the current capture and encode with:

```powershell
uv run --locked --project .\quickstart python .\recording\recorder.py --run-id setup-2026-09-29 --stop
```

Resume with the same run ID and interval. An OS file lock prevents two recorders
from writing the same run. Existing frame files remain intact. Resuming verifies
their paths and byte sizes, and records a gap if the prior heartbeat is older
than 30 seconds. A new Altium process is discovered on each capture; use `--hwnd`
only to require a particular currently verified handle. Multiple Altium main
windows cause a visible error instead of guessing which to record.

## Output and limits

The recorder creates its run directory and `frames/` subdirectory under
`astra-run/runs/<run-id>/`. These ignored local outputs are not bundled in the
checkout. Choose a new run ID for a new capture, or an existing local ID to
resume its verified manifest. Table entries are relative to that run directory:

| File | Content |
|---|---|
| `manifest.json` | Run identity, liveness, frames, window identity/geometry, errors, gaps, video status |
| `frames/<UTC>-<unique suffix>.png` | Window screenshot with a separate UTC/elapsed-time label band |
| `timelapse.mp4` | Cumulative 1600 x 900 H.264 video at 4 frames per second |
| `recorder.lock` | OS lock; the file can remain after the process stops |
| `stop.request` | Graceful stop request; removed when a new recorder starts |

Manifest and video updates use atomic replacement. Encoding failure preserves
the prior complete video. `timelapse_source_frame_count` records the capture
count used by the last successful encode; `timelapse_frame_count` records its
included frames, and `timelapse_omitted_frame_count` records explicit exclusions.
Without exclusions, the video includes every capture. Every included frame has equal playback
duration. UTC and elapsed labels preserve the real timing across interruptions;
the recorder does not create frames to fill a gap.

## Omit a reviewed interval from playback

Stop the recorder and confirm its process has exited before editing playback.
The same OS lock rejects an active recorder. The edit does not capture, change
heartbeat/status history, remove frame records, delete PNGs, or edit controller
progress. It creates a verified backup of the exact original manifest and MP4
under `playback-backups/<unique-id>/` before persisting an omission. A missing
prior MP4 is recorded by its absence from the backup hash map.

Use exact relative frame filenames from the manifest. Both endpoints are
included; keep useful before/after frames outside the reviewed interval.
Set these variables to the existing local run and exact `frames/...png` values
from its manifest before running the example:

```powershell
$AstraRun = '<existing-local-run-id>'
$FirstIdleFrame = 'frames/<first-reviewed-frame>.png'
$LastIdleFrame = 'frames/<last-reviewed-frame>.png'
uv run --locked --project .\quickstart python .\recording\recorder.py --run-id $AstraRun --omit-playback $FirstIdleFrame $LastIdleFrame --omission-reason 'Reviewed static interval; raw captures retained'
```

`playback_omissions` stores the two fixed frame identities, capture UTC bounds,
reason, edit time, and backup paths/hashes. Every later encode and resume honors
these exclusions. New captures are appended normally. Unknown/reversed ranges,
overlapping omissions, blank reasons, and exclusion of every frame are rejected.
UTC labels still show the actual elapsed time across an omitted interval.

The omission is durable before encoding starts. `playback_pending: true` means
the requested playback edit is not yet confirmed in the MP4; `playback_error`
records a rebuild failure. A failed encode preserves the prior complete MP4.
Retry without taking another screenshot or adding a duplicate omission:

```powershell
uv run --locked --project .\quickstart python .\recording\recorder.py --run-id $AstraRun --reencode-only
```

The raw frame collection remains the complete capture record. Keep the backup
and disclosed omission metadata with any edited playback. The recorder never
infers idle periods or discards repeated screenshots automatically.

Manifest and video replacement retry Windows access, sharing, and lock denials up to
five times over 1.55 seconds. The prior complete file stays available until
replacement succeeds. The recorder logs the first denial and recovery to stderr;
an exhausted retry or another error still fails visibly. A failed video update
preserves capture and heartbeat activity; a heartbeat write failure stops recording.
This retry does not identify which process denied access or repair permissions.

Each new frame and the latest manifest carry `capture_metadata`: monitor size,
visible window size, raw capture size, saved PNG size, window DPI, and capture
method. All sizes use physical pixels. Raw capture size excludes the UTC label;
the saved PNG includes it. Monitor size includes space used by the taskbar and
need not equal window size. Older frames omit this metadata. Geometry checks
cannot establish that the intended board view is visible; inspect the image.

`status: running` is only a last reported status. Check the heartbeat age as well:
more than 45 seconds without an update is stale. `last_capture_utc` is independent
of the heartbeat. Identical screenshots can be valid when the board is static.
Blank-image detection rejects nearly uniform images and an almost all-black
center, but it cannot prove that every region of a graphics canvas rendered
correctly. Inspect frames after display/session changes.

The default source-frame budget is 4 GiB (`--max-frame-gib`), and capture stops
adding frames when less than 5 GiB remains free (`--min-free-gib`). No frames are
automatically deleted. These limits apply to source frames and available space,
not to a hard filesystem quota. Video encoding temporarily needs both the old
and new MP4. At five-minute intervals, 36 hours produces about 432 frames; at the
first observed 1.83 MB capture size, source frames use about 0.79 GB. Actual size
depends on the board view. The manifest and logs remain small at this interval.

Minimized/hidden windows, missing windows, blank output, low disk space, and
capture timeouts create explicit errors. This recorder has no login, reboot, or
disconnect recovery service. Qualify those cases in the real Windows session
before relying on a long unattended recording.

## Validation

From `astra-run/`, run the repository's pinned checks in the isolated tool
environment:

```powershell
. .\quickstart\enter.ps1
uv run --locked --project .\quickstart --with black==22.3.0 black --preview --check .\recording
uv run --locked --project .\quickstart --with isort==5.12.0 isort --profile black --check-only .\recording
uv run --locked --project .\quickstart --with ruff==0.15.11 ruff check --no-fix --output-format full .\recording
```

To apply formatting, run isort without `--check-only`, then Black without
`--check`, and rerun all three checks. These commands install temporary tool
environments without changing the project's dependencies or lockfile.

Tests generate synthetic frames in the system temporary directory, outside the
repository. They exercise resume and file integrity, safe paths, duplicate
writers, blank capture rejection, timeout and disk errors, atomic video failure,
bounded manifest and video replacement retries, and actual MP4 decoding with different
source window sizes. Playback tests cover inclusive boundaries, invalid ranges,
verified backups, unchanged raw history, writer exclusion, failed rebuilds,
resume persistence, and decoded frame order after omission.

```powershell
uv run --locked --project .\quickstart python -m unittest discover -s .\recording -p 'test_*.py' -v
```

File and media tests also run on macOS and Linux. Native capture-adapter and
Windows file-lock tests report explicit skips on those platforms. Live Altium
capture requires Windows. From the repository root:

```sh
uv run --locked --project astra-run/quickstart python -m unittest discover -s astra-run/recording -p 'test_*.py' -v
```

The following qualification record describes the original VM and earlier tool
revisions. Its named `runs/` directories are relative to `astra-run/` on that
VM and are not included here. Historical test counts and captured frames do
not qualify the maintained recorder on a new Windows session.

The initial PrintWindow capture qualification on 2026-09-29 used Pillow 12.3.0 and verified
the Altium window and `X2.EXE` process immediately before capture. The 3364 x 1828 PNG contained the PCB canvas and Altium panels.
The full recorder then captured a labeled frame at 23:46:12 UTC and encoded an
H.264 MP4 that decoded successfully. A resume preserved that frame and added a
second at 23:47:31 UTC. Its heartbeat advanced to 23:47:46 UTC while the capture
time remained unchanged. A stop request ended that qualification cleanly.
All 11 synthetic tests passed. Evidence was saved in `runs/capture-qualification/`.

With Explorer visibly covering Altium, the frame at 2026-09-29 23:59:50.876 UTC
reported `is_foreground: false` and contained the correct PCB without Explorer.
Evidence: `runs/capture-covered/`. Minimizing Altium made `--once` exit with code
1, no frame, and an explicit error and gap at 2026-09-30 00:00:28.727 UTC.
Restoring and maximizing Altium allowed the same `capture-minimized` run to
resume at 00:01:04.892 UTC; it cleared `last_error` and preserved the gaps.
Those checks describe the earlier backend. After an RDP/console display change,
PrintWindow produced an enlarged, clipped board at the expected image size;
forcing per-monitor DPI awareness did not correct it. The recorder therefore
uses only Windows.Graphics.Capture, with no PrintWindow or desktop fallback.

On 2026-09-30, the WGC probe in `runs/capture-wgc/` showed the whole board and both
Altium side panels at 3363 x 1875. The integrated recorder completed a capture
and MP4 in `runs/capture-wgc-qualified/` at 01:27:38 UTC. Its monitor was
3364 x 1924, DWM and raw capture were 3363 x 1875, and the labeled PNG was
3363 x 1947. All 15 synthetic tests passed. After the user changed RDP scaling
and disconnected at 01:34 UTC, the separate `rdp-dpi-transition-2026-09-30` run
captured the complete board and both panels at 01:34:38 with the same physical
dimensions. Native mouse and keyboard input also passed. WGC capture during
occlusion and minimize/recover needs separate qualification; reboot remains
untested. Session recovery belongs to the workstation setup, not this capture
process.

API references: [windows-capture source](https://github.com/NiiightmareXD/windows-capture/blob/main/windows-capture-python/windows_capture/__init__.py),
[pinned release](https://pypi.org/project/windows-capture/2.0.1/),
[Windows Graphics Capture](https://learn.microsoft.com/en-us/windows/apps/develop/media-authoring-processing/screen-capture),
[thread DPI awareness](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setthreaddpiawarenesscontext),
and [physical window bounds](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowrect).

# Historical recording observations

This public summary records capture behavior and interruptions during the
September 30–October 2, 2026 routing experiment. Raw monitoring logs, task
configuration, and recording archives are not included in this package.
The [recording guide](../recording/README.md) describes the maintained local
recorder. The [final report](../../astra-output/FINAL_ROUTING_REPORT.md)
separates routing results from monitoring activity.

## Scope and ownership

Engineering work started at 04:33:43 UTC on September 30. The main controller
alone operated the live Altium document and desktop. A monitoring agent
maintained progress observations. Recorder heartbeat, image freshness, agent
activity, and routed-connection counts were separate measures; none implied
that another was advancing.

The original capture interval was 300 seconds, with independent heartbeat
updates. Windows.Graphics.Capture targeted the Altium window. The first
full-run capture at 04:37:09 UTC included the whole window, PCB canvas,
Projects panel, and side panels. Its raw capture was 3364 × 1876 pixels at
DPI 96; the labeled PNG was 3364 × 1948. An actual MP4 decode was inspected.
The next scheduled capture arrived at 04:42:09 UTC. These image checks did
not establish the full active PCB path or a new electrical result.

## Observed interruptions

| September 30 gap, UTC | Recorded observation |
|---|---|
| 06:52:12.682–06:56:08.310 | Windows denied an atomic manifest replacement; the recorder exited and then resumed with all 28 earlier frames intact |
| 07:05:23.996–07:05:57.107 | A bounded replacement-retry update required a recorder restart; the prior 30 frames and video were preserved |
| 16:22:17.614–17:07:47.542 | Both recording/serving processes were absent; the exit cause was not established |
| 17:15:25.351–17:17:03.253 | A controlled restart followed the verified duplicate-playback edit |

Later scheduled frames were inspected after each recovery. Captures are not
claimed inside those intervals. The initial access-denied condition was not
explained by a missing directory permission: 20 atomic-replacement probes
passed. The exact cause of the transient denial remained unproven.

A service restart was recorded close to the later paired-process loss. That
timing did not directly establish why those processes ended. Display/session
recovery observations did not prove automatic reasoning-agent continuation,
reboot survival, license availability, or correct board state.

## Duplicate frames and playback omissions

At the September 30 afternoon recovery, all 142 existing PNGs matched their
recorded byte lengths. Excluding the 72-pixel UTC label band for comparison,
frames 64–99 had identical content from 09:55:57.878 to 12:50:58.116 UTC.
Frames 100–141 had identical content from 12:55:58.123 to 16:20:58.480 UTC.
The transition changed 3,994 pixels within the top 110 pixels: the window title
added `No License` and toolbar options became unavailable, while the PCB
canvas remained identical.

Playback retained frames 64 and 100 as distinct states and omitted duplicate
frames 65–99 and 101–141, totaling 76 exclusions. Raw source-image records were
retained; the omitted intervals were not new routing progress. Both playback
edits created hash-verified manifest/video backups. The pre-resume MP4 decoded
to 68 frames, and a subsequent resumed version to 69 frames. At 17:18:12 UTC,
the recording had 145 raw frames, 69 playback/video frames, and no pending edit.
These are dated verification results, not the contents of a supplied public
recording archive.

## Capture and interpretation limits

After the later display transition, inspected raw capture dimensions were
3362 × 1874 with a 3362 × 1946 labeled PNG at DPI 96. Image contents and the
complete intended canvas were checked alongside metadata. Matching dimensions
alone would not establish correct capture.

The historical monitor recorded recovery, decode, and file-integrity checks.
It did not perform electrical acceptance. A current heartbeat, an HTTP response,
a playable timelapse, or a running process is not evidence that routing was
active or that a connection was correctly completed. Preserve real capture
gaps and explain playback omissions when presenting a derived timelapse.

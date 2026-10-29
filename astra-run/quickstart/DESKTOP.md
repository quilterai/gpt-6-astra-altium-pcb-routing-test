# Persistent Windows desktop

The Altium desktop needs a display even when no RDP client is connected. The
VM and its processes continue after RDP disconnects, but a disconnected Windows
session can lose usable capture and input. Keeping a process alive does not
establish desktop availability.

The installation and qualification below describe the original 2026 VM.
Its local `runs/` captures and `.runtime/` receipts are not included in this
checkout. Run PowerShell examples from `astra-run/`; script-created output
paths below are relative to that directory. Requalify the current VM before
relying on these historical measurements.

## Installed configuration

On the recorded Windows Server 2025 VM, Amazon DCV 2025.0-20103 supplied an AWS
Indirect Display Device with a fixed **3364 x 1924** console layout. The installer uses
the core server and display driver. DCV listens on `127.0.0.1:8443`, QUIC is
disabled, and the installer does not add a firewall rule. RDP remains the user's
remote access method. DCV's console session owner is local Administrator; this
setting does not configure Windows automatic sign-in.

`AstraRouter-ConsoleRecovery` runs after Administrator's `RemoteDisconnect`
notification. It uses that user's existing interactive token at the highest
available privilege level. It requires no stored password. The task calls
`session-guard.ps1`, checks the current process's session, and uses `tscon` to
transfer it to the console only if it is still disconnected. If the user has
already reconnected, it skips recovery. It does not log off or restart Altium.

RDP can change the display adapter and DPI. Always take a fresh native window
snapshot after a session change; discard earlier coordinates, element indexes,
and screenshot IDs. Fixed console resolution does not establish a fixed DPI.
Inspect a saved recorder frame after each new session/display configuration.

## Awake settings

Inspect the active plan separately from session recovery:

```powershell
powercfg /GETACTIVESCHEME
powercfg /QUERY SCHEME_CURRENT SUB_SLEEP
powercfg /QH SCHEME_CURRENT SUB_SLEEP
powercfg /QUERY SCHEME_CURRENT SUB_VIDEO
powercfg /A
```

On September 30 at 17:23 UTC, AC sleep, unattended sleep, hibernate, and
display-off timeouts were all `0` (Never). The VM exposed no supported standby
state, and hibernation was disabled. No power setting change was needed. If a
fresh dedicated VM has nonzero AC timeouts, set only the required AC values:

```powershell
powercfg /CHANGE standby-timeout-ac 0
powercfg /CHANGE hibernate-timeout-ac 0
powercfg /CHANGE monitor-timeout-ac 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_SLEEP UNATTENDSLEEP 0
powercfg /SETACTIVE SCHEME_CURRENT
```

Requery the settings and preserve before/after output. These settings do not
prevent logoff, reboot, process failure, or service restarts. They do not change
authentication, session lock, or remote-access policy. Agent usage limits do
not drive the recorder's independent capture loop; a current heartbeat and
fresh image establish recorder health, while routing activity needs a separate
controller update.

## Setup and inspection

Run these commands from `astra-run/` in elevated PowerShell as the user who owns
Altium. The display installer is for a fresh DCV installation and refuses to
replace an existing service. It checks a pinned SHA-256 and AWS signature before
installation. A required reboot is reported; the script never requests one.

```powershell
.\quickstart\install-console-display.ps1 -Width 3364 -Height 1924
.\quickstart\session-guard.ps1 -Action Install
.\quickstart\session-guard.ps1 -Action Status
& "$env:ProgramFiles\NICE\DCV\Server\bin\dcv.exe" describe-session console
Get-CimInstance Win32_VideoController |
    Select-Object Name, CurrentHorizontalResolution, CurrentVerticalResolution
```

Task installation can be repeated by the same owner. If the checkout moves,
install the task again so its action points to the new script path. Keep the
script available while the task is enabled. The runtime task XML and recovery
JSONL are created in `.runtime/desktop/`; the display installer creates its log in
`.runtime/console-display/`. A successful task result does not prove capture:
inspect `result`, `session_id`, `state_after`, and `console_after` in its log.

To remove automatic handoff without removing DCV:

```powershell
.\quickstart\session-guard.ps1 -Action Remove
```

DCV display settings are under
`HKEY_USERS\S-1-5-18\Software\GSettings\com\nicesoftware\dcv\display`.
`console-session-default-layout` is
`[{'w':<3364>, 'h':<1924>, 'x':<0>, 'y':<0>}]` and
`enable-client-resize` is `0`. That resize setting governs DCV clients, not RDP.
Preserve the current registry values before changing them; restarting DCV can
change the active display and must be followed by capture/control checks.

## Qualification

On September 30, transferring the interactive user's disconnected RDP session
to the console succeeded while the same Altium process remained running. Its original
Microsoft Basic Display Adapter was limited to 800 x 600; changing the mode to
1920 x 1080 failed. Installing DCV required no reboot. DCV and Windows then
reported an AWS display at 3364 x 1924. Native window capture showed the full
PCB, and mouse input opened Altium's View menu; Escape dismissed it.

The recovery task's manual invocation on an already active console session
returned `already-console`, exit code 0. Its same-owner reinstall passed.
The first high-resolution recorder frame was incorrectly scaled and
cropped by PrintWindow after the display transition. Setting per-monitor DPI
awareness did not correct it. An HWND-targeted Windows.Graphics.Capture test
returned a complete 3363 x 1875 Altium window, matching DWM's visible bounds.
The monitor was 3364 x 1924, with 48 pixels used by the taskbar. The recorder's
timestamp band is separate from the captured pixels. Do not infer a passing
capture from image dimensions alone.

At 01:31 UTC, the live recorder resumed its existing run with WGC. A fresh
frame and MP4 showed the whole board with the monitor/window/DPI readout.
The recorder's 15 tests passed. Per-frame metadata prevents earlier images
from inheriting measurements from a later display configuration.

The user reconnected through RDP, changed scaling, and closed the client.
Windows recorded the session disconnecting at 01:34:02 UTC and reconnecting
locally at 01:34:03. The recovery task returned `recovered-console`, exit code 0;
the same Altium process remained running. Windows and DCV still reported 3364 x 1924. The frame at
01:34:38 in `runs/rdp-dpi-transition-2026-09-30/` showed the complete board and
both panels at 3363 x 1875 raw pixels (3363 x 1947 with the timestamp band).
Native mouse input opened the View menu and keyboard Escape dismissed it.
This qualifies the tested scaling/disconnect transition, with a brief automatic
session handoff; it does not establish zero interruption during a transition.

To repeat the end-to-end test, connect through RDP, observe a fresh window snapshot,
then close the client without signing out. Verify automatic console recovery,
3364 x 1924 console layout, a fresh complete recorder frame, and both native
mouse and keyboard input. Repeat with a different RDP scaling setting. Logging
off and rebooting end the interactive applications and are separate recovery
cases; neither is qualified by this test.

### Altium saved window bounds

A process restart and saved-layout repair resolved the small-window modal
failure in the tested console session. After a clean Altium shutdown, run:

```powershell
.\quickstart\repair-window-layout.ps1 -LayoutPath '<live profile>\UserTools.TLT'
```

Use the live profile path described in [Views](../notes/altium/VIEWS.md).
The script requires Altium to be closed, preserves a byte-for-byte backup under
`.runtime/altium-layout/`, and changes only the main form's normal bounds and
maximized state. Its percentage rectangle is specific to the measured
3364 x 1924 console with a 48-pixel taskbar. It does not change Windows DPI.
Relaunch and verify actual bounds, complete capture, and modal input afterward.

## References

- [Microsoft tscon](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tscon)
- [Microsoft session change triggers](https://learn.microsoft.com/en-us/windows/win32/taskschd/sessionstatechangetrigger)
- [AWS Windows installation](https://docs.aws.amazon.com/dcv/latest/adminguide/setting-up-installing-windows-installation.html)
- [AWS display prerequisites](https://docs.aws.amazon.com/dcv/latest/adminguide/setting-up-installing-windows-prerequisites.html)
- [AWS DCV configuration](https://docs.aws.amazon.com/dcv/latest/adminguide/config-param-ref.html)

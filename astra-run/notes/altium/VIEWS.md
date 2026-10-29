# Views and selection

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

## VM verified

The [routing control trial](../ROUTING_TRIAL.md) establishes these behaviors:

- `Page_Up` / `Page_Down` zoom around the cursor; normal wheel input pans.
- Pointer movement needs qualification before routing. A separate pointer-move
  operation, fresh observation, and a separate click worked in the first trial,
  but failed during the later trial described below. Do not commit
  geometry unless Altium's crosshair and pad/net readout agree with the target.
- A track click selected it and showed Properties. Double-clicking overlapping
  objects opened a selection popup.
- After restoring Altium, maximize the observed window and refresh its state
  before using screen coordinates.

### Modal input and window recovery (2026-09-30)

The desktop controller observed modal input restore Altium's main window to a
tiny normal size. Capture metadata reported width `129`, height `77`, and
`originX=311`, while the returned bitmap could still show an earlier full-board
view. Treat a bitmap that disagrees with the window dimensions as stale. Do not
use its canvas coordinates for another action.

After dismissing the modal, `Alt+Space`, followed by `x` in a separate tool call,
reliably maximized the window in this trial. Clicking the small maximize button
was unreliable. Refresh window state and capture after recovery, and confirm
the dimensions before using coordinates. Input to Preferences also triggered
this behavior, so its layout Save/Load controls were not practical during the
trial. This recovery does not establish why the normal size was small.

At 01:49 UTC, that process could no longer complete a modal or close normally.
The saved trial PCB still matched the original hash, and no geometry edits were
pending. A controlled restart restored modal operation at DPI 96. Altium then
closed normally and wrote a fresh live `UserTools.TLT`. The restart changed both
process and DPI state, so the exact cause of the old failure is not established.

With Altium closed,
[repair-window-layout.ps1](../../quickstart/repair-window-layout.ps1) backed up that
live file and changed only `FormNormalRect` and `FormMaximized`. The normal bounds
fill this console's 3364 x 1876 work area on its 3364 x 1924 display. Relaunch,
configuration-dialog input, Board Information, Design Rule Checker, and file
dialog input passed at full size. A later RDP scaling transition with this new
process remains a separate test.

Native captures can include tiny menu-shadow windows before the actual menu.
Inspect every screenshot's ID and dimensions; do not assume `screenshots[1]`
is the dialog or menu. A 4 x 17 shadow is not evidence that the main window
shrunk. On this session, the File menu was `screenshots[4]` at 254 x 654.

The bottom-right Panels menu produced `window crop is outside captured monitor`
when its shadow extended past the desktop edge. A text-only UIA observation
confirmed the menu was open; `Esc` dismissed it and full-window capture resumed.
Use **View > Panels** and keep floating windows inside the work area. This
capture error did not indicate a display disconnect or a smaller main window.

From the idle PCB canvas, numpad `*` switched from a mechanical layer to
`L1_PS`. The layer tabs updated before the heads-up label; moving the cursor
back into the canvas refreshed that label. `Page Up` zoomed around the cursor.
An immediate capture sometimes showed the preceding zoom level; take a fresh
observation before choosing the next pad coordinates.

Other controls below are documented, not VM verified by this research.

### Routing cursor qualification (2026-09-30, 02:47 UTC)

During an active route, the controller's pointer overlay moved while Altium's
crosshair and coordinate readout remained at an earlier position. Zero-delta
scroll and drag did not reliably correct it. An empty `No Net` preview started
at the old location and was canceled. An inventory after canceling all previews
matched the saved first batch exactly: 2,827 tracks, 372 vias, and 856 remaining
connections. The cause of this input mismatch is unresolved.

Arrow keys moved the routing crosshair by the 5 mil snap grid. Numpad multiply
and subtract changed the active routing layer and displayed a via preview.
Neither action establishes a committed via. `Ctrl+L` did not open its documented
layer dialog in these attempts. `Shift+F1` displayed the routing shortcut list.

From the idle PCB canvas, **Jump > New Location** accepted exact user-coordinate
values and the status bar identified the intended pad. Launching routing from
the menu afterward caused edge scrolling; this is not yet a qualified routing
workflow. `Ctrl+Page Down` restored the whole-board view. Use inventory and saved
checkpoints to distinguish canceled previews from persistent copper.

## Documented: navigation from an idle PCB canvas

| Control | Result |
|---|---|
| `2` / `3` | 2D / 3D view |
| `PgUp` / `PgDn` | Zoom around pointer |
| `Ctrl+PgDn` | Fit all document objects |
| `Ctrl+wheel` | Zoom with default mouse settings |
| Wheel / `Shift+wheel` | Vertical / horizontal pan |
| Hold right button and drag | Pan |
| `Home` | Center the current pointer location |
| `End` | Redraw |
| `Shift+S` | Cycle enabled single-layer modes |
| `L` / `Ctrl+D` | View Configuration: Layers & Colors / View Options |
| `Ctrl+F` | Toggle viewing from the bottom |
| `Shift+H` | Toggle routing heads-up display |

Mouse assignments are configurable. Shortcuts can change meaning during an
interactive command; inspect the current mode first.
[PCB shortcut reference](https://www.altium.com/documentation/altium-designer/shortcut-keys/pcb-editors)

## Documented: reduce visual clutter

Select the intended copper layer using its bottom tab. `Shift+S` cycles through
the enabled hide, grayscale, and monochrome modes, then returns to the full
view. Configure the cycle under **Preferences > PCB Editor > Board Insight
Display**. This preference applies across designs.

In **View Configuration > View Options**, use **Object Visibility** to hide
rooms or show objects as outlines. **Mask and Dim Settings** adjusts contrast:
dimmed objects remain editable; masked objects cannot be edited. `Shift+C`
removes applied masking and dimming.

Save a custom configuration in **View Options > General Settings** after finding
a useful view. Named layer sets retain a chosen set of visible layers and can
be exported as `.layerset` files. Their visibility does not change which layers
the routing rules permit.
[View configuration](https://www.altium.com/documentation/altium-designer/pcb/your-view-of-the-board)

Object transparency can also vary by object type and layer through **View
Options > Object Visibility > Advanced**. Use transparency to inspect pad/track
overlap without hiding the pad entirely.
[Transparency controls](https://www.altium.com/documentation/altium-designer/pcb/object-layer-transparency)

## Documented: locate nets and select exact objects

Open the **PCB** panel in **Nets** mode. Choose **Dim** or **Mask**, enable
**Select** and **Zoom**, then choose a net; `Ctrl+click` adds nets in the panel.
Use its **Clear** button or `Shift+C` afterward. The panel can show the
**Unrouted (Manhattan)** length. A nonzero routed length alone does not mean a
net is complete.

For explicit airwire selection, use the **PCB Filter** query:

```text
IsConnection And InNet('exact net name')
```

`IsConnection` targets all connection lines. Inspect the resulting selection
before invoking a routing tool.
[Connectivity and the PCB panel](https://www.altium.com/documentation/altium-designer/pcb/understanding-connectivity)

With nothing selected, `F11` opens **Properties**, including **Selection
Filter**. Enable only the intended object types, such as pads or tracks, to
avoid selecting a component or room. This filter limits what may be selected;
it does not select objects. The post-selection filter narrows which selected
types appear in Properties.
[Selection filter](https://www.altium.com/documentation/altium-designer/selection-filter)

## Documented: desktop layout persistence

**Preferences > System > View > Desktop > Layouts** provides Save, Load, and
Reset controls for desktop layouts (`.TLT`). This Save control differs from the
dialog's bottom Save button, which exports preferences. A layout includes the
main application window and panel positions and sizes. Altium writes
`UserTools.TLT` on shutdown and reads it on the next launch; a running instance
can overwrite a disk edit when it exits.
[Desktop layouts](https://www.altium.com/documentation/altium-designer/working-with-panels)
[Preferences](https://www.altium.com/documentation/altium-designer/preferences)

### VM file inspection (2026-09-30)

The only Roaming Altium instance directory was:

```text
%APPDATA%\Altium\Altium Designer <profile-id>
```

The running executable was `C:\Program Files\Altium\AD26\X2.exe`, with no
command-line arguments. The documented live layout path is `UserTools.TLT`
directly inside that profile directory. That file was absent during the first inspection.
An older `ExportPreferences\UserTools.TLT`, dated 2025-07-24, contained one
`FormNormalRect='9.25, 0.00, 16.88, 8.00'`. Its role as a current layout source
was not established; it is not the documented live path.

The installed `System\Desktop Layouts\EDP Single Monitor.tlt` contained
`FormNormalRect='1.25, 1.67, 62.50, 70.83'`. Interpreting these as percentage
edges is an inference, not a documented field schema. For the VM's measured
3364-pixel display width, 9.25% is about 311 pixels and the difference between
16.88% and 9.25% is about 257 pixels, consistent with the observed position and
approximately 129 logical-pixel width under a 2:1 conversion. This correspondence
supports investigating the field; it does not establish its units or the cause
of resizing.

The clean shutdown at 01:54 UTC wrote a live rectangle of
`1.25, 1.66, 62.49, 70.84`, matching the observed 2060 x 1331 normal window.
The repair at 01:55 UTC set `0.00, 0.00, 100.00, 97.51` and maximized state.
Only those two lines changed. The backup is under
`astra-run/.runtime/altium-layout/20260930T015541663Z/` (not included here).
Do not substitute the old exported file for the live layout or reset unrelated preferences. The repair script
refuses a running Altium process and ambiguous layout fields.

## Trial guidance: repeatable views

Qualify three views: whole-board orientation, a single copper layer with pads
and tracks visible, and a selected-net view with surrounding objects dimmed.
Record the layer, display mode, filter, and zoom target beside each useful
screenshot. After any panel or display change, recheck the pad/net under the
pointer before committing geometry.

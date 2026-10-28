# Eclipse keyboard map

## Review status

The owner accepted this entire map as the initial implementation baseline,
including rows originally labeled Proposed below, no-default actions, and
hardware bindings. Those labels record the review stage, not pending approval.
This is not installed configuration. All bindings remain subject to comfort
testing, especially the monitor-transfer chord the owner finds awkward.
`Super` means the keyboard's Windows/Meta key; `Number` is 1–9 or 0 for 10.
The detailed behavior and acceptance criteria remain in `DESIGN.md`.

## Applications and personal tools

| Action | Binding | Status |
| --- | --- | --- |
| Kitty | Super + Enter | Accepted |
| Strata | Super + Shift + F | Accepted |
| Zen with Sine | Super + Shift + B | Accepted |
| OMP, general session in ~/Work | Super + Shift + A | Proposed |
| Neovim/LazyVim in Kitty | Super + Shift + E | Proposed |
| Notes in the island | Super + Shift + N | Proposed |
| Task board | Super + Shift + K | Proposed |
| Spotify | Super + Shift + M | Proposed |
| Telegram | Super + Shift + T | Proposed |
| Virtual machines | Super + Shift + V | Proposed |
| Development servers | Super + Shift + D | Proposed |
| Screen-time panel | Super + Shift + Y | Proposed |
| Webcam-effects panel | Super + Shift + W | Proposed |

Application launch shortcuts do not introduce unrequested focus-or-launch,
new-window, private-browser, or project-picker behavior. OMP invocation from a
project-aware command preserves its working directory; the desktop shortcut
uses the accepted general ~/Work entry point. Editor path selection remains
an implementation detail to document, not a reason to add a file-picker feature.

## Windows, workspaces, and monitors

| Action | Binding | Status |
| --- | --- | --- |
| Close focused window normally | Super + W | Accepted |
| Toggle floating/tiling | Super + T | Accepted |
| Toggle fullscreen | Super + F | Accepted |
| Focus window in direction | Super + Arrow | Accepted |
| Move window in direction | Super + Shift + Arrow | Accepted |
| Switch to local workspace | Super + Number | Accepted |
| Move window to local workspace and follow | Super + Shift + Number | Accepted |
| Workspace overview in island | Super + Tab | Accepted |
| Focus monitor in direction | Super + Alt + Arrow | Accepted |
| Send one window to destination monitor's active workspace and follow | Super + Alt + Shift + Arrow | Accepted; comfort concern |
| Show/hide shared scratchpad | Super + S | Accepted |
| Send focused window to scratchpad without following | Super + Shift + S | Accepted |
| Maximize while keeping the bar | Super + Alt + F | Proposed |
| Cycle Dwindle / Master / Scrolling | Super + L | Proposed |
| Flip split / rotate Master orientation where supported | Super + J | Proposed |
| Toggle pseudo-tiling where supported | Super + P | Proposed |
| Next window | Alt + Tab | Proposed; retain inherited behavior |
| Previous window | Alt + Shift + Tab | Proposed; retain inherited behavior |
| Drag window | Super + Left mouse drag | Proposed; retain inherited behavior |
| Resize window | Super + Right mouse drag | Proposed; retain inherited behavior |
| Next local workspace | Super + Mouse wheel down | Proposed; retain and verify local scope |
| Previous local workspace | Super + Mouse wheel up | Proposed; retain and verify local scope |

Independent 1–10 sets on each monitor are accepted. The four Arrow directions
are Left, Right, Up, and Down. Adding Shift to a monitor-focus chord moves only
the focused window, not the workspace or all its windows. If no destination
monitor exists, it must not move the window elsewhere.

Retrieve a focused scratchpad window with the accepted move-to-local-workspace
binding. Hiding the scratchpad keeps its applications alive. Ordinary workspace
changes hide it. Do not add a second workspace-trading action on monitor keys.

## System, shell, and clipboard

| Action | Binding | Status |
| --- | --- | --- |
| Launcher | Super + Space | Accepted |
| Session menu | Super + Escape | Accepted |
| Lock | Super + Ctrl + L | Accepted |
| Universal copy | Super + C | Accepted |
| Universal paste | Super + V | Accepted |
| Universal cut where applicable | Super + X | Accepted |
| Clipboard history in island | Super + Ctrl + V | Accepted |
| Settings | Super + Ctrl + S | Proposed |
| Control centre | Super + Ctrl + A | Proposed |
| Appearance / wallpaper | Super + Ctrl + W | Proposed |
| Fixed palette picker | Super + Ctrl + T | Proposed |
| System statistics | Super + Ctrl + U | Proposed |
| Package panel | Super + Ctrl + P | Proposed |
| Shortcut reference sheet | Super + Ctrl + K | Proposed |
| Hide/show bar | Super + Ctrl + B | Proposed; retain inherited behavior |
| Reduced-effects Game mode | Super + Ctrl + G | Proposed |
| Capture surface | Super + Ctrl + C | Proposed |
| Start/stop screen recording | Super + Ctrl + R | Proposed |
| Color picker | Super + Ctrl + I | Proposed |
| Emoji picker | Super + Ctrl + E | Proposed |
| Turn screen off/on manually | Super + Ctrl + D | Proposed |
| Switch English/Persian | Caps Lock | Accepted default |

The layout-switch settings retain Alt + Shift and None alternatives; the
Super + Space option is removed. Preserve native app shortcuts. Universal cut
in terminals requires explicit safe handling, not blind Ctrl + X forwarding.
Opening the session menu must not execute a session action. Keep the existing
power-action confirmations.

### Target-test refinement: Settings

The owner reports the exercised keybindings work, but prefers **Super + comma**
for Settings instead of **Super + Ctrl + S**. This preference is recorded for
implementation; the table above still describes the deployed initial binding.
Update the shared defaults, saved-profile migration and this reference together,
and verify the comma key in both English and Persian. No shortcut change was
deployed when recording this feedback.


## No dedicated keyboard shortcut by default (proposed)

- GitHub panel: control-centre entry and launcher's `>` shell-action search.
- OMP usage/session panel: control-centre entry and `>` search, distinct from
  launching OMP. Its selectable-session behavior remains as agreed.
- VPN management: Settings; connect/disconnect in the network/Wi-Fi panel.
- Individual network/audio/Bluetooth/brightness/night-light details: existing
  bar/control-centre navigation, not a new hotkey for every panel.
- Individual capture modes (region/window/screen/annotation/OCR): retained capture
  UI and editable shortcut entries, unbound by default as in the inherited map.
- Force-kill window, direct logout, and shell restart: no default key chord.
  Preserve the underlying actions where appropriate and document manual access;
  do not silently drop functionality merely to remove an accidental hotkey.

These defaults avoid assigning a shortcut to every capability. Retained
shortcut settings should still allow owner customization. Confirm actual
entry points for no-default actions during implementation.

## Hardware bindings (proposed: retain)

Keep distinct volume up/down/mute, microphone mute (including the inherited
Acer microphone-key mapping), display brightness up/down, media play/pause,
next/previous keys, and power-button-to-session-menu behavior. Keep lid events
as hardware events, not profile hotkeys. Print Screen retains Capture as a
hardware convenience alongside Super + Ctrl + C. Remove Ctrl + Alt + Delete
as a redundant default session-menu chord; do not replace it with close-all.

## Conflict resolution and integration

- Notes moves off Super + S; Capture moves off Super + Shift + S for scratchpad.
- Appearance moves off Super + T for window floating/tiling.
- Browser/file-manager old bindings are replaced by accepted application keys.
- Layout cycling moves off Super + Shift + L; locking moves off Super + L.
- Recording takes Super + Ctrl + R, replacing the inherited shell-restart key.
- The grid-widget toggle disappears, freeing Super + Ctrl + W for Appearance.
- Music takes the inherited VM chord; VM access moves to Super + Shift + V.
- No retained aliases should continue to trigger old/displaced actions. Inspect
  profile overrides, generated keys.tsv, key-reference descriptions, and defaults
  as one migration. Never apply the table only to Lua fallback bindings.
- Preserve unrelated user-customized bindings unless a concrete collision needs
  an explained migration. Verify effective bindings, not just this proposal.
- Test English and Persian (Windows), Caps Lock switching, and the optional
  Alt + Shift choice alongside monitor-transfer chords.
- A collision-free table is only a design check, not runtime verification.

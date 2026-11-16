# Eclipse verification record

This records observed development-environment checks, not acceptance of a
complete laptop installation. No host packages, login services, boot settings,
network profiles, or live desktop configuration were changed for these checks.
Disposable fixtures and a private nested Hyprland session were used.

## Checks exercised

| Area | Observed evidence | Limits |
| --- | --- | --- |
| Repository syntax | `./setup check`: Python, Lua, Bash, JSON and TOML passed | Does not validate QML, TypeScript, external app setup or hardware |
| Backend regression | `/usr/bin/python3 -m unittest discover -s tests -v`: 18 tests passed (GitHub, VPN import, app-service preservation, login rollback, OMP snapshot boundaries) | Controlled boundary tests, not full laptop acceptance |
| Keyboard migration | `lua tests/test_keymap.lua` passed: inherited defaults, explicit unbound, custom precedence, retired actions, version and first-boot TSV | Saved QML profiles and effective key comfort also require runtime testing |
| Keyboard/workspaces | Real nested Hyprland 0.56.2: two disposable Kitty windows; transfer moved one window to destination's active workspace, other stayed; local workspace 3 on monitor two was internal 13; scratchpad send/show and retrieval to local 2/internal 12 worked | Callbacks dispatched in private compositor; not every physical shortcut/layout/monitor arrangement tested |
| Bash/ble.sh/Starship | Isolated interactive PTY loaded ble.sh `0.4.0-devel4+d81fd54f` and rendered Starship; `y` and zoxide functions present; noninteractive source emitted no UI | fnm not installed in development PATH; full helper interaction and Kitty glyph appearance still need target testing |
| LazyVim | Fresh temporary HOME downloaded real lazy.nvim/LazyVim plugins. Actual Neovim loaded LazyVim, wrote/reopened sample text including Persian and emitted `LAZYVIM_EDIT_PASS` | First-launch asynchronous Mason installs were interrupted on exit (stylua); not a completed LazyHealth or language tooling check |
| GitHub API and UI | Actual panel/backend returned paginated repos/orgs including private access; keyboard Down/Return drill-down and Escape/back worked; filters/empty/permission errors and rapid view changes passed. Selecting public PR opened exact GitHub URL in real isolated Zen, confirmed through Marionette URL/title | No private names/content published. Auth expiry/rate-limit/network-fault injection and laptop integration remain unverified |
| GitHub/VPN/Input QML | Actual components loaded in isolated Qt/Quickshell; Input showed US + Persian Windows and Caps Lock/AltShift/None; rendered panel screenshots inspected | Offscreen run, not portal/authentication or real input typing proof |
| OMP | Actual isolated OMP 18.12.6 extension loaded after fixing compiled-runtime import. Collector read a real idle session snapshot; shutdown produced ended. Generated named custom theme appeared in active isolated theme directory. Native `/skill:eclipse-` autocomplete showed both Eclipse skills | No provider prompt/paid request. Token/cost changes during a model turn, full session selector/UI theme comparison remain to test. Unknown context capacity is now null rather than misleading 0% |
| WireGuard | Private user/network/mount/PID namespaces with private D-Bus/NM 1.58.1: imported WG profile and manually constructed libnm profile activated and pinged a controlled kernel peer; status/list/disconnect/delete passed | Graphical manual editor not exercised; DNS and real laptop transitions remain unverified |
| OpenVPN | Same private environment imported inline CA/cert/private key and saved manual-equivalent libnm profile; extracted key/cert files checked at 0600 | Actual activation blocked by namespace supplementary-group/tun restrictions, not passed; no host restrictions weakened |
| Edge surfaces/profiles | Real QML services: three note bodies, pin/select/reorder/merge/move/unpin, spectrum config/move/duplicate rejection, legacy filtering, malformed profile guard, profile switch/duplicate/export and process restart passed (`RESULT failures=0`, `RESTART RESULT failures=0`) | Mutation/drop geometry APIs rather than physical drag gestures; software rendering; no real audio animation because cava unavailable in verification environment |
| SDDM | `sddm-greeter-qt6 --test-mode` rendered Eclipse SVG wordmark on private compositor; screenshot inspected | Not PAM login, session startup, Ly cutover, or boot verification |
| Plymouth | Actual `plymouthd` + script.so/X11 software renderer in private namespaces exercised boot, status/diagnostics, dummy password masking/backspace/Return/normal, shutdown and quit. Actual screenshots stored under `.github/assets/eclipse-plymouth-*.png`; no script/image errors observed | Not actual boot/SDDM handoff, hardware/HiDPI or real encrypted-root verification; final artwork not approved |
| Sine staging | Actual pinned archives downloaded and checksums matched; all installed archive bytes matched upstream in disposable program/profile trees; existing prefs/styles/mod and backups/repeat merged prefs preserved | Process-presence check mocked only for disposable fake Zen because actual host Zen was running; no real browser Sine activation claimed |
| Telegram theme export | Native ZIP generated with 478 palette entries and valid 1280×800 JPEG wallpaper; official Telegram 7.3.3 launched isolated with networking off | Unauthenticated welcome screen cannot preview an account theme; actual import/Keep Changes/reapplication unverified |
| Strata chooser | Actual AUR 1.1.0 release verified against package SHA; supported portal installer exited 0 in isolated filesystem/DBus preserving Hyprland ScreenCast/Screenshot and GTK fallback; packaged FileManager1 path corrected; native FileChooser.OpenFile dialog visibly rendered | Systemd frontend reload warning in isolation; cancellation return, Zen/Telegram app integration, Save/multi/filter and real screen sharing still need target checks |
| Clipboard | Real graphical Copy/Paste/Cut transferred exact sample text. Kitty selected-text Copy and clipboard Paste worked using Ctrl+Shift+C/V even with a different primary selection; terminal Cut left selection intact and no SIGINT delivered | Graphical probe isolated from host Fcitx; application-specific and physical keyboard verification still required |
| Keyboard layouts | Real libxkbcommon compiled US + ir(winkeys), verified digits/punctuation/yeh/keheh/ZWNJ and Caps/AltShift/None behavior. Actual QML migration/picker/persistence checks passed in isolated processes | No claim of physical typing in every app or pre-login authentication input |
| Deployment | Full `setup sync` into disposable HOME copied configuration/skills/apps, repeat reported nothing to do; `setup system` copied SDDM/Plymouth/system files into an explicitly writable disposable root and left login manager unchanged | No real packages/services/boot changes or target installation; first missing-root attempt requested sudo and did not run |
| OMP installation | Actual pinned binary downloaded and checksum/version validated in disposable destination; mode 0755; repeat preserved binary. Dry-run preserved current mise OMP | Target install/provider setup remains explicit, no live auth or paid requests |

## Settings control-centre handoff and BUG-01

The owner's laptop report remains authoritative: Settings → Control Centre →
Panel → Edit attempted a transition and crashed. That exact laptop failure
cannot be diagnosed without its original runtime evidence.

A related failure was exercised in the full nested desktop: invoking the real
Edit handler closed Settings and immediately dismissed arrangement mode
(`settings:false, editing:false, panel:""`). This was not visible in the earlier
offscreen component-only harness.

The implementation now routes the request to persistent SettingsWindow. It
closes/unloads Settings first, then queues enabling arrangement and opening
controls from the surviving window. Actual nested-runtime checks then reported
`settings:false, editing:true, panel:"controls"`, remained stable, and passed
repeat close/open/edit. A real compositor screenshot showed the grid/catalogue.
After user-configuration deployment and a subsequent owner reboot, SSH checks
confirmed Hyprland and Quickshell running, working Eclipse status IPC and no
Hyprland configuration errors. The owner then physically exercised the requested
Settings → Control Centre → Panel → Edit path and reported: “yes I did it, and
it works well.” BUG-01's reported crash is closed by affected-laptop confirmation.
The owner then completed the requested block move/save, close/reopen persistence,
Escape exit and Settings reopening checks and reported “its works good”. These
editor acceptance checks are passed by owner observation on the target laptop.

## Concrete fixes found while verifying

- Compiled OMP runtime did not resolve a runtime package import. The extension
  now uses the supported injected coding-agent API to locate active theme dirs.
- PATH-selected Python lacked GI; VPN runtime now uses the system Python.
- GitHub remote titles/descriptions render as plain text, merged-filter state
  is normalized on Issues navigation, and keyboard focus reaches results.
- OpenVPN `ncp-disable` is explicitly preserved instead of importer omission.
- Edge profile changes cancel stale saves and flush outgoing edits before
  snapshots, preventing both incoming overwrite and outgoing edit loss.
- Neovim migration preserves checkout-backed links, rejects unsupported config
  roots before mutation, and simulates actual replacement in dry-run output.
- Imported edge-layout objects/numbers are ignored safely rather than throwing.
- Strata FileManager1 template path now matches actual strata-bin packaging
  under `/usr/share/dbus-1/services/`; competing per-user providers are backed
  up while unrelated service files and repeat setup are preserved.

## Dedicated laptop: initial SSH inspection

Password-authenticated SSH to `arsalan@192.168.4.74` succeeded. The credential
is not recorded here or in project configuration. Read-only inspection found:

- Arch Linux, kernel `7.2.11-arch1-1`; Hyprland `0.56.2`, Quickshell `0.3.2`
  (Arch build), NetworkManager `1.58.1`.
- SDDM is already active and enabled. Ly remains installed; a service cutover
  must not be performed merely because the historical plan mentioned Ly.
- Running Hyprland and Quickshell use the installed Impasto configuration.
  `~/impasto` remains at starting commit
  `1a2ce200f4494aca9b5d3e17ea00f807c6086231`; its README has local edits.
  Preserve that checkout rather than repurpose it as Eclipse.
- Installed SettingsWindow matches the original Impasto source, not the new
  deferred-handoff implementation. No Quickshell/qs core dumps were returned
  by coredumpctl; this does not invalidate the owner's crash report.
- AC power connected; approximately 838 GiB available on root and 848 MiB on
  `/boot`. Bash, Git, Kitty, Neovim, Zen, gh, OMP, Lua and yay are available.
  Strata and Telegram were not found in the inspected command PATH.

No deployment, package installation, service change, desktop reload, or remote
credential persistence was performed during this inspection. Next agree the
backup/staging scope before modifying the installed desktop. SSH access is now
available; target acceptance checks remain pending.

## Dedicated laptop: user-configuration deployment

Following the owner's instruction to continue, Eclipse was staged in
`~/Projects/eclipse` from the fork plus a checksum-verified snapshot of the
current development tree. The existing `~/impasto` checkout was left intact.

- Verified rollback archives are in
  `~/eclipse-backups/pre-eclipse-20261028-153701/`: `desktop.tar.gz`,
  `user-config-complete.tar.gz`, and `managed-data.tar.gz`. The directory is
  private; archives cover configuration, managed app data, and editor state.
- Target `./setup check`, all 18 Python regressions, and Lua keyboard-migration
  checks passed before deployment. `setup sync --dry-run` was reviewed first.
- `setup sync` deployed user files; it preserved the locally edited Kitty file
  and wrote the candidate as `.new`. Existing Neovim config/data/state/cache
  were preserved under the installer's timestamped `backups/.../lazyvim` tree.
  Repeated sync reported `nothing to do`.
- Hyprland reload succeeded and `hyprctl configerrors` returned empty.
  Live IPC status answered; screenshots showed the control centre and branded
  Settings window. File-copy reloads briefly logged unavailable QML types;
  subsequent full reloads reported `Configuration Loaded`.
- Installed `bash-completion` 2.18.0, Telegram Desktop 7.3.3, Strata 1.1.0 and
  ble.sh `0.4.0-devel4+cb9c2c37`. A real interactive SSH PTY rendered Starship,
  reported that ble.sh version and `EDITOR=nvim`, and resolved fnm/zoxide.
- Strata launched and was visually inspected. `setup strata` completed;
  `inode/directory` selects `io.github.lgse.Strata.desktop`; per-user portal
  configuration selects Strata for FileChooser without overriding other APIs.
  Actual app chooser and screen-sharing flows remain unverified.
- Target packaging exposed a Telegram executable mismatch: Arch ships
  `/usr/bin/Telegram`. Corrected the setup preflight and Hyprland messenger
  command to use it, reran syntax checks and sync, generated the native theme,
  and visually observed Telegram's welcome screen. Account theme import is not
  yet verified.
- SDDM remains active/enabled. No system deployment, PAM modification,
  Plymouth activation, bootloader change, plugin build, or reboot occurred.

The owner subsequently confirmed the original Edit transition works on the
affected laptop after reboot; see BUG-01 above. The runtime has inherited
IPC-property warnings; an empty Hyprland error list is not a claim of a
warning-free shell or full desktop acceptance.

## Owner feedback: physical shortcut check

The owner completed the requested shortcut/input batch and reported that every
keybinding works as expected. Record the exercised shortcut batch as passed,
not blanket acceptance of every hardware/multi-monitor binding. Additional
observations and preferences are tracked in DESIGN's target follow-up table:
Strata does not dynamically follow the palette, Dolphin theming should be tried,
the Persian layout differs from the development laptop, and Settings should
prefer Super + comma. No live changes were made for this feedback. The Persian
layout is not accepted merely because switching layouts works.

## Owner acceptance: single-display workspaces and scratchpad

Read-only SSH inspection found one active built-in display (`eDP-1`) and no
Hyprland configuration errors. The owner completed the seven-step physical
workspace/scratchpad batch and reported “works correctly”: open Kitty on local
workspace 1; move it to 2 and follow; switch away/back with placement preserved;
send to scratchpad; show/hide/show with the same window alive; switch workspace
to hide it; show and retrieve onto normal workspace 1, where scratchpad toggling
no longer hides that window. These single-display behaviors pass by owner
observation. Multi-monitor independence and transfer remain untested on target.

## Owner acceptance: lock and password unlock

The owner completed the requested physical lock/unlock batch and reported “it
works correctly”: Super + Ctrl + L renders the lock screen, the desktop beneath
cannot be interacted with, an incorrect password leaves the session locked and
permits retry, the correct password restores the existing session/windows, and
a second lock/unlock succeeds. These checks pass by owner observation. This
does not verify face authentication, suspend/resume, or login-manager PAM.

## Owner acceptance: explicit suspend and resume

With AC connected and the lid open, the owner completed the requested session
menu Suspend test and reported “it works correctly”: suspend, wake after about
15 seconds, return to a protected lock screen, successful password unlock,
existing windows intact, Wi-Fi recovery and responsive bar/control centre.
These checks pass by owner observation. Before the test, read-only inspection
found the shell's lock-before-sleep delay inhibitor active; CanSuspend returned
`challenge`. No conclusion about whether authorization was actually prompted
is inferred. Lid-triggered behavior was subsequently checked below; battery
operation remains unverified.

## Owner acceptance: lid-close sleep and wake

The owner completed the requested AC-powered lid-close test with no external
display and reported “it works correctly”: close the lid, wait about 15 seconds,
open/wake, return to the lock screen, unlock successfully, normal display
resolution, preserved window, recovered Wi-Fi and responsive bar. These checks
pass by owner observation. Whether lid opening alone woke the machine or a
brief power-button press was needed is not separately established. Battery
operation and external-monitor lid policy remain unverified.

## Owner acceptance: audio controls and playback

After the sleep/wake checks, read-only SSH inspection found PipeWire,
pipewire-pulse and WirePlumber active and a default output at 43% volume. The
owner completed the requested audio-control/playback batch and reported “it
works good”: volume-key level changes and indicator, mute/unmute and indicator,
control-centre volume agreement, and pause/resume playback. These checks pass
by owner observation. Optional wired-headphone switching was not separately
confirmed and remains unverified; microphone/Bluetooth audio and edge spectrum
animation are not covered by this result.

## Owner acceptance: display brightness

The owner completed the requested brightness-key and control-centre slider
batch and reported “it works well”: physical screen brightness changes and
on-screen indicators/percentage agree. This passes by owner observation; the
latest remote brightness query timed out, so no fresh device reading is claimed.

## Session handoff — owner stopping for the day

The owner plans to shut down and continue tomorrow. Do not interpret the
expected SSH loss as a crash or reconnect/deploy while the laptop is off.
Local records are current; the latest audio/brightness entries have not been
confirmed copied to the target because the last remote command timed out.

Resume by re-establishing the target's LAN address and authenticated SSH, then
continue remaining acceptance checks. Completed target batches: control-centre
Edit/save/persistence/Escape/reopen, exercised launch shortcuts, single-display
workspaces/scratchpad, lock/password retry/repeated unlock, AC explicit suspend
and lid sleep/wake, audio controls/playback, and display brightness.

Deferred GitHub follow-ups: [Settings shortcut #1](https://github.com/Arsalan-Namvar/eclipse/issues/1),
[Dolphin theming #2](https://github.com/Arsalan-Namvar/eclipse/issues/2),
[Persian layout #3](https://github.com/Arsalan-Namvar/eclipse/issues/3), and
[Strata dynamic theme #4](https://github.com/Arsalan-Namvar/eclipse/issues/4).
Next suggested physical batch: retained notes/task board and edge surfaces,
before account-dependent app flows and controlled VPN checks. No further live
change, shutdown command or deployment was performed for this handoff.

## Resumed target testing: notes persistence

The owner reports the laptop is back online at the same LAN address with sshd
active. SSH initially answered but the authentication attempt stalled; later
connection attempts timed out, so no resumed authenticated runtime inspection
or deployment is claimed. Network reachability remains unresolved.

The owner completed the physical Notes batch and reported “notes work well”:
create the `Eclipse acceptance` note with title and two body lines, leave and
reopen with content intact, edit a line and reopen with the edit preserved.
These checks pass by owner observation. Edge pinning/deck behavior and task
board acceptance are separate checks, not implied by note persistence.

## Screen-edge Edit handoff: issue #6

Owner report: Screen edges → Edit crashes/closes Settings like the former
control-centre issue. Accept this as target evidence; no request to repeat the
crash merely for confirmation. The owner also reported the separate inherited
empty-workspace bounce, tracked in [#5](https://github.com/Arsalan-Namvar/eclipse/issues/5).

In a disposable HOME with a full Eclipse shell on nested Hyprland 0.56.2 and
Quickshell 0.3.2 (Omarchy build), a temporary probe navigated the actual
SettingsPanel and invoked the actual Edit button handler. Before the fix,
settled state was `shown:false, editing:false, screen:""`. No native crash
was reproduced locally. The patch removes editor activation from the transient
WidgetsSection, forwards its request through SettingsPanel and lets surviving
SettingsWindow close first and activate the edge focus grab via Qt.callLater.

After the fix, the same full-runtime probe reported
`shown:false, editing:true, screen:"WAYLAND-1"`; repeated entry stayed active.
Injected Escape exited (`editing:false`). The actual edge configuration surface
was captured via grabToImage and visually inspected, showing its edge choices,
Notes/Spectrum actions and Done button. The unchanged control-centre handler
also passed (`controls:true`, Settings hidden). `./setup check` passed.

No permanent source-text/wiring test was added; temporary instrumentation was
confined to the disposable tree. Nested screencopy timed out before a separate
syntax-check invocation; the successful visual capture used the real QML
surface instead. SSH initially timed out, but LAN reachability subsequently
returned (no causal attribution to VPN/router changes is established).

After authenticated reconnection, created and verified the target rollback
archive `~/eclipse-backups/edge-edit-20261029-104936/settings.tar.gz`, containing
the three live Settings files and home manifest. Confirmed target source/live
files matched before staging. Transferred only SettingsPanel.qml,
SettingsWindow.qml and WidgetsSection.qml to the target checkout. Dry-run and
actual `setup sync` each listed exactly those three updates; target
`./setup check` passed and the shell logged Configuration Loaded. Initial IPC
queried during reload reported not ready; settled status subsequently returned
`ok:true`, including the owner's persisted note. Repeat sync preview reported
nothing to do. No system, network, workspace or keyboard configuration changed.

The owner then physically tested Screen edges → Edit, confirmed that Settings
closes while the configuration card stays visible, exited with Escape and
reopened/reentered successfully, reporting “it works well”. Target acceptance
of the entry/exit handoff passes by owner observation. Subsequent deck/spectrum
checks below also passed; issue
[#6](https://github.com/Arsalan-Namvar/eclipse/issues/6) is resolved on the target.
The patch is deployed, but not yet pushed to GitHub.

The owner subsequently completed the physical note-deck batch and reported “it
works well”: set notes visibility to Over the windows to avoid inherited empty
workspace bounce; add a right-edge deck; exit editing; hover to reveal tabs and
preview; click to open the note in the island; reenter editing and move the
deck to the left; exit with content intact. These checks pass by owner
observation. Physical tab dragging and multi-note ordering are not implied by
this result.

The owner then completed the physical spectrum batch and reported “it works
well”: add a bottom spectrum during playback, observe audio-responsive bars,
change Look/Fill and size controls, move to the right edge, pause/resume with
bars settling/reacting, exit and reopen with placement/appearance preserved.
These checks pass by owner observation. Together with editor entry/reentry and
note-deck checks, this completes issue #6's target acceptance. Empty-workspace
stability remains the separate inherited issue #5; no drag-gesture, multi-monitor
or every-style-combination acceptance is inferred.

## Owner acceptance: task board

The owner completed the disposable-task batch and reported “it works well”:
open via Super + Shift + K, create `Eclipse acceptance task` with a note, return
to the board, drag To do → Doing → Done, close/reopen with lane/text/note intact,
use the task editor's lane selector to return to To do, reopen with that change
preserved, then delete only the test task. These checks pass by owner observation.
No acceptance of due-date/calendar behavior or restart persistence is inferred.

## Owner acceptance: clipboard cut, history and terminal safety

The owner completed all four requested disposable-text checks and reported “it
works well”: graphical Super + X removes selected text and Super + V restores
it exactly; clipboard history can select the older of two copied entries for
subsequent paste; Kitty selected-output Super + C / Super + V transfers the
selection; Super + X at a typed, unexecuted terminal prompt leaves text intact
without executing it. These checks pass by owner observation. Clipboard images,
lock-time history wiping and every application-specific path remain unverified.

## Owner acceptance: Zen local file selection

The initial instructions incorrectly assumed the browser launch binding and
Zen's Ctrl + O shortcut. Live Hyprland inspection found the effective browser
binding was Super + Shift + Enter, not the shared map's default. The owner also
reported the in-Zen shortcut incorrect; no browser shortcut change was made.

A temporary local HTML page used a file input and File.text() to display only
the selected disposable text file, with no network requests or uploads. It was
opened through eclipse-browser; the actual Zen window title was observed as
Eclipse file chooser check. The owner completed the cancel/reopen/select/display
batch and reported “it works well”, then explicitly confirmed “it was strata”.
Zen → Strata single-file selection, cancellation, reopening and selected-file
delivery pass by owner observation. Save/multiple-file/filter and screen-sharing
flows are not covered. Temporary fixture files were removed after this check;
no browser preferences were changed.

## Owner acceptance: Zen Strata Save dialog

The owner completed the browser-menu Save Page As batch and reported “it works
well”: Strata Save dialog, cancel/reopen, save a harmless public page under a
recognizable name in Downloads, and confirm the resulting file in Strata.
These checks pass by owner observation. Overwrite handling and every save-format
option are not covered by this result.

## Owner acceptance: Zen Strata multiple-file selection and filtering

The owner completed the local multiple-file batch and reported “it works well”:
the text filter permits first.txt/second.txt and hides or disables excluded.csv,
both text files can be selected together, and the local page receives/displays
both filenames and their expected contents. These checks pass by owner
observation. No uploads/network requests were made by the fixture; temporary
files were removed afterward. This does not establish every MIME/filter case.

## Owner acceptance: Zen screen-sharing portal

The owner completed the local getDisplayMedia preview batch and reported “it
works well”: cancel screen/window selection, reopen and select a harmless
source, observe a live updating preview, stop with the preview cleared and
active-sharing indicator gone, then start/stop again successfully. These checks
pass by owner observation. The page made no uploads, recordings or network
requests and requested video only (no microphone/audio). The exact selected
source type was not separately identified; neither every source type nor actual
call-app transmission is inferred. Temporary page files were removed afterward.

## Owner acceptance: reduced-effects Game mode

The owner completed the Appearance → Motion Game mode batch and reported “it
works well”: enabling makes motion immediate, the island solid without shadows,
and spectrum animation stop; launcher/control centre remain usable; disabling
restores the previous appearance, animations and spectrum response. These checks
pass by owner observation. Subsequent read-only SSH confirmed `game:false`,
animations and blur enabled, and no Hyprland configuration errors. No game
performance, frame-rate or every material combination acceptance is inferred.

## Owner acceptance: notifications and Focus

After clarifying that Focus means Do Not Disturb (Notifying = off, Silenced =
on), the owner completed the notification batch and reported “it works well”:
normal notification appears in the island and history; with Focus enabled a
normal notification is retained in history without interrupting; a critical
notification bypasses Focus and can be dismissed manually. The requested final
state was Focus off. These checks pass by owner observation; action buttons,
history persistence across restart and every sender/urgency combination remain
unverified. Existing notification history was not requested to be cleared.

## Owner acceptance: graphical Night light controls

The owner initially could not find Night light or its small dim toggle. Remote
inspection found hyprsunset installed, Night light off and a saved temperature
of 4000 K; opening the existing detail panel via IPC rendered it correctly.
The owner confirmed warmth changes worked, but required a graphical access
path rather than terminal commands. After instructions to select Night light
in the control-centre toggle block's editor and use the tile/expansion arrow,
the owner reported “ok found it it works as it should”. Graphical discovery,
toggle and temperature controls pass by owner observation. The exact final
temperature/on-off state was not independently checked. No automatic schedule,
external-display or restart acceptance is inferred.

## Owner acceptance: region screenshot capture

Live Hyprland bindings were inspected before the test: Print Screen and
Super + Ctrl + C open capture. The owner completed the physical capture batch
and reported “it works well”: Escape cancels without saving; Photo → Region →
Save captures on drag release; a filename notification appears; the saved image
can be found/opened in Strata and contains the selected region rather than the
whole screen or capture controls. These checks pass by owner observation.
Window/full-screen modes, image clipboard, annotation/OCR and recording are
not covered by this result.

## Owner acceptance: silent region recording

The owner completed the short recording batch and reported “it works well”:
Video → Region → No sound starts on selection, the island recording indicator
appears, stopping removes it, and the saved video opens/plays the changing
selected region without audio. These checks pass by owner observation. The
active Super + Ctrl + R recording binding and wf-recorder/ffprobe availability
were inspected beforehand. Whether the island control or shortcut stopped this
take was not separately identified. Audio recording, long takes and other
capture geometries remain unverified.

## Owner acceptance: OMP desktop lifecycle; visual refinement pending

Target OMP 18.12.6 was observed installed, and the desktop Oh My Pi panel was
opened via IPC. The owner completed the no-model-request lifecycle batch and
reported functionality works: launch in ~/Work without extension error, refresh
and explicitly select the idle session, then exit and observe ended/disconnected
rather than live status. These checks pass by owner observation. No paid turn,
provider authentication change or live token/cost progression is claimed.

Visual acceptance is not passed: the owner reports excessive empty space and
an overall design that is not sleek. This is tracked in
[#7](https://github.com/Arsalan-Namvar/eclipse/issues/7) for focused layout and
hierarchy refinement with actual-state visual review. No redesign was applied
while recording this feedback; preserve working lifecycle/selection semantics.

## GitHub navigator revision after owner feedback

Owner decisions: remove the unwanted contribution page (not implement private
contribution retrieval), cache navigation data, update every ten minutes, retain
manual Refresh, and improve the panel design. The public contribution service,
fetcher/grid, username preference/control and unused palette/translation entries
were removed. The authenticated navigator now starts on repositories.

The service caches pages in shell memory across panel openings; filtering is
local to fetched rows. Fresh cached pages avoid API requests, stale pages remain
visible while updating, Refresh forces a fetch, and a 600000 ms timer refreshes
the current view after first use even with the panel closed. Local credential
fingerprints scope the cache; account changes or authentication/permission
failures clear it. Transient network failures retain last-good rows with an
error. No private-content disk cache or token persistence was added.

Observed smoke: actual GithubPanel and service loaded in a disposable fixture
against real authenticated GitHub API data. A wrapper counted operation names
only. Initial repository fetch returned 30 rows; reopening added an identity
check without a repository fetch, cached Back returned immediately, and local
filtering found Eclipse without another request. Public issue navigation
returned six issues; manual Refresh made another API fetch. The actual timer
was accelerated to one second in the disposable instance and produced updates;
its production interval was restored to 600000 ms. A full ten-minute wall-clock
wait was not exercised. Controlled network failure retained 30 cached rows and
an error; simulated signed-out identity cleared all rows/cache. Recovery to real
authentication loaded data again. Actual repository/issue UI captures were
visually inspected: compact rows, segmented navigation/status filters, account,
breadcrumb, update time, bounded content-dependent height and pagination.

`./setup check`, 19 Python regression tests (including credential identity
boundaries), and Lua keyboard migration checks passed. Source checks found no
remaining contribution runtime callers. The smoke fixture's missing Settings
files produced fixture-only warnings. SSH initially timed out, then access was
restored and the owner authorized deployment as recorded below. The cache is
intentionally cold after shell restart; it does not persist to disk.

### Target deployment after reconnection

Verified target rollback archive:
`~/eclipse-backups/github-revision-20261031-103122/before.tar.gz`, covering live
Quickshell, its source checkout tree and the home manifest. Staged the current
shell and removed the three retired contribution source files. Target syntax
checks passed; the reviewed preview and actual sync listed eleven GitHub-related
updates (panel, service/backend, registrations, settings and removed styling/
translations) and three contribution file removals. No packages, system services,
boot settings or other open-issue fixes were deployed.

The shell logged Configuration Loaded and status IPC returned ok. Opening the
GitHub panel through live IPC showed the real repository list, including private
access, with the contribution tab gone. An actual target screenshot was visually
inspected: compact rows, account context, update time, navigation and pagination
fit inside the island. No private screenshot/content was published to GitHub.
Repeat sync preview reported nothing to do. Existing IPC-property warnings and
transient PrivacyService warnings during reload were observed; no claim of a
warning-free desktop. Owner visual/navigation acceptance and a real ten-minute
target refresh observation remain pending; source is not pushed yet.

### Complete snapshot cutover inspired by omarchy-github

The owner rejected the first revision as still slow/incomplete and requested
the fetch/cache/presentation architecture of robzolkos/omarchy-github. Source
review found complete GraphQL cursor pagination, aggregate repository counts,
credential-scoped private disk cache and local complete-list filtering/sorting.
Eclipse adopts these patterns for the accepted read-only navigator, not the
reference's contributions, notification mutations or Omarchy-specific launchers.
Reference attribution/license is retained in `licenses/omarchy-github.txt`.

The backend now fetches every repository/organization page in two concurrent
streams, with issue/PR/star counts. Repository issue and PR streams are fetched
completely on demand. Complete snapshots are atomically cached under
`~/.cache/eclipse/github`, bound to the exact credential fingerprint and request
shape; tokens are not cached. Cache reads never wait for the network-refresh
lock. Partial/failed pagination never replaces a complete list with truncation.
This supersedes the memory-only page cache documented in the prior revision.
Shell startup loads cached data before background refresh; opening the panel
does not start a request or clear its rows. Search, state/metric filters and
sorting operate locally over every fetched item. Background TTL is ten minutes;
manual Refresh bypasses freshness. Repository data remains on-demand, not an
unbounded eager scan of every repository's history.

Observed local real-account smoke: complete snapshot fetched 32 repositories
and one organization in 2.326 seconds; persisted cache read in 0.088 seconds.
Actual QML service/panel reported all 32 rows, filtered Eclipse without a fetch,
loaded complete issue/PR snapshot and switched tabs without network work.
`./setup check`, 39 Python regressions and Lua keyboard migration checks passed;
coverage includes >100-row pagination, cursor failures, cache TTL/forced refresh,
concurrency/nonblocking reads, credential isolation and partial failure handling.

Target rollback archive:
`~/eclipse-backups/github-snapshots-20261031-105745/before.tar.gz`.
Target checks passed; preview and actual sync updated only shell.qml,
GithubBrowserService.qml, GithubPanel.qml and github_browser.py. Configuration
Loaded and status IPC succeeded; repeat preview reported nothing to do. Target
cached snapshot returned 32 repositories/one organization in 0.150 seconds;
Eclipse's complete issue/PR fetch returned eight issues/zero PRs in 2.394 seconds,
then the same cached snapshot in 0.158 seconds. Cache directory 0700 and JSON
files 0600 observed. Actual target screenshot visually inspected: all-item count,
metric/search/sort controls and scrollable rows fit the island. No private
screenshot/content published to GitHub. These are individual measurements, not
a performance guarantee. Cold network fetch remains dependent on GitHub/network.
Full ten-minute wall-clock observation and owner acceptance of responsiveness,
completeness and revised design remain pending. Source remains unpushed.

### Owner rejection and complete feature removal

The owner reports the snapshot revision is still too slow and has unusable UX.
This is failed target acceptance; backend timings above do not override it.
Source review identified remaining cold-entry costs (all issue/PR history and
bodies before display; serialized refreshes) and a drill-down flow unlike the
reference dashboard. Offered clean removal versus a new dashboard, the owner
explicitly selected Remove it. No further navigator patch is in scope.

Removed panel, service/backend, QML registrations, startup work, control-centre/
launcher/bar/IPC entry points, obsolete backend tests and now-unused reference
license (no adapted code remains). GitHub CLI stays in the package manifest for
terminal/development use. Existing saved layout filtering drops retired entries
without resetting the owner's layout. Dedicated cache removal targets only
`~/.cache/eclipse/github`; credentials and unrelated caches are preserved.

`./setup check`, the remaining 12 Python regressions and Lua migration checks
passed. Target rollback archive:
`~/eclipse-backups/github-removal-20261031-113421/before.tar.gz`. Target checks
passed; reviewed preview and actual sync showed six wiring updates/three runtime
file removals. Shell logged Configuration Loaded; status IPC works; panel list
omits GitHub; actual control-centre screenshot visually inspected. Target
dedicated cache absent, gh authentication available before/after, repeat preview
reports nothing to do. No packages/services/boot settings or repository remotes
changed. Historical backups still contain prior source, not restored active code.
Issue #8 is superseded by explicit feature removal, not a successful UX fix.

## Inherited empty-workspace bounce: issue #5

Before the fix, an actual target event-socket trace showed workspace 2 become
active, then return to occupied workspace 1 within roughly 0.1–0.7 seconds.
The note layer mapped in between, but keeping it mapped did not fix the bounce;
that experimental change was reverted. With shell execution paused, the empty
workspace stayed selected. Temporary tracing then identified MonitorService's
repeated apply/settle/rescue cycle: the saved panel rule requested VRR=1 while
hyprctl reported active VRR=false. Comparing requested policy with activity
caused repeated applications, and rescue explicitly focused an occupied
workspace whenever the current one was empty.

MonitorService now records successfully applied VRR policy separately from
reported activity, invalidating that record on reload/hotplug. Workspace rescue
only moves occupied workspaces stranded on absent/disabled outputs; it never
chooses another workspace just because the user selected an empty one. No
keyboard binding, deck visibility preference or monitor profile was changed.

Observed target after fix: empty workspace stable for eight seconds; three
switch-away/back cycles passed; compositor reload on empty workspace preserved
selection; a disposable Kitty mapped there, then closing the last window left
the workspace selected for five seconds. Hyprland configerrors was empty. A
target screenshot showed the empty desktop and bar; original workspace restored.
An isolated actual-QML MonitorService smoke additionally checked no command for
ordinary empty workspace, stranded workspace movement without focus dispatch,
VRR on/automatic accepted without reapply, changed policy and reload reassertion.
The smoke used fake command boundaries, not physical external-monitor hotplug.
No permanent source-text regression was added; this runtime harness was disposable.

Final target source/live files matched for all temporarily instrumented paths;
one shell instance remained, status IPC worked, repeat sync said nothing to do.
Local/target syntax checks, 12 existing Python regressions and Lua migration
passed. Final permanent runtime change is MonitorService.qml only. The owner
then physically confirmed “it works well”; issue #5 is resolved. Physical
external-monitor recovery remains unverified.

Diagnostic caveat: `qs kill` during isolation produced a Quickshell crash/restart
dialog (crashed pid 98800), so that stop did not isolate the shell. The diagnostic
duplicate instance and crash dialog were removed, clean services restored, and
a process-level self-restoring pause/clean restart established shell involvement.
No claim that the kill-time crash is fixed; its crash artifacts remain on target.
Initial rollback archive at `~/eclipse-backups/workspace-deck-20261031-114718/`
preserves deck/manifest; the earlier GitHub-removal full-shell backup preserves
the pre-fix monitor service. Temporary instrumentation was removed.

## Independent workspace and scratchpad animations

Owner request: Settings → Bar → Workspaces gets a separate animation selector,
also applied to scratchpad show/hide. Added a profile-scoped
workspaceAnimationPreset with Glide/Brisk/Calm/Bounce/None previews. Window and
workspace curves/leaves are generated independently; explicit workspaces/In/Out
and specialWorkspace/In/Out leaves share the workspace preset. Windows None
does not globally suppress enabled workspace animation, and workspace None does
not suppress window animation. Game mode still temporarily disables both.

Actual QML smoke loaded legacy settings with animationPreset=smooth and no new
field; both resolved to smooth. Legacy imported profile completion adopted its
old window choice; an explicit independent choice was preserved. Saving windows
off/workspaces snappy wrote both values and survived a process restart. The
actual Bar Workspaces section rendered with its five selector previews and was
visually inspected. No permanent source-text/wiring test added; disposable
actual-component smoke exercised these transitions.

Generated Lua was applied to the actual target compositor and animations JSON
inspected for four cases: windows off/workspaces Brisk; windows Calm/workspaces
off; windows Bounce/workspaces Calm; Game mode on. All six normal/special
workspace leaves matched the independent enabled state/curve; window leaves
matched their own choice. This proves configuration behavior, not subjective
physical animation comfort. Original combined Calm state restored afterward.

Verified backup: ~/eclipse-backups/workspace-animation-20261031-142150/.
Reviewed deployment updated Motion, SettingsService, CompositorService,
BarSection and MotionPreview, followed by translations/Settings search terms.
Target migrated its saved Calm preset to independent Calm/Calm. Actual Game mode
on disabled windows/workspaces/specialWorkspace; off restored separate curves
and workspace/scratchpad fade. Target reload/configerrors/status and repeat
preview passed. Local/target syntax checks and 12 Python regressions passed.
Selector visual smoke and persistence fixtures were isolated from live main
desktop settings. The owner accepted independent motion, then requested the
scratchpad enter from below instead of matching horizontal workspace slides.

### Scratchpad bottom-up refinement

Split normal workspace and special-workspace style generation while retaining
the same selected curve/speed/enabled state. Hyprland 0.56.2 source inspection
confirmed `slidevert bottom` enters from positive Y and `slidevert top` on Out
exits toward positive Y. Target accepted these explicit In/Out styles while
normal workspaces remained `slide`. None/Game mode still disable special leaves.

Verified target backup: ~/eclipse-backups/scratchpad-direction-20261031-144558/.
Preview/deployment changed only Motion.qml; target syntax/configerrors passed.
A disposable Kitty in a separately named special workspace was shown and hidden;
target monitor state and transition screenshots confirmed bottom-up entry and
downward exit. The existing user scratchpad and saved preset were not moved or
changed. Test window and screenshots were removed afterward. The owner then
physically checked show/hide and confirmed “it works well”. Scratchpad direction
and the independent workspace animation refinement are accepted on target.

## Persian layout matching and Settings shortcut version 2

Read-only main-laptop inspection found compositor US layout, with Persian
provided by Fcitx's keyboard-ir-winkeys profile. Target had us,ir with an empty
variant, so it used plain ir. Changed only the target's saved kb_variant to
,winkeys, preserving layouts, Caps Lock switching and other preferences. No
main-laptop config or input-method deployment changed. Actual libxkbcommon
comparison matched 180 alphanumeric key/level combinations between standalone
ir(winkeys) and the target's second us,ir group. Fcitx-specific composition and
physical typing comfort are not established by that comparison.

Keymap version 2 sets Settings to Super + comma and retires the previous default
Super + Ctrl + S. Lua/QML migration removes only the old Settings default from
version-1 overrides, preserves unrelated v1 customized chords, explicit unbound
and custom Settings actions, and honors comma collisions. Actual Lua regression
and isolated QML migration checks passed. Existing default ir(winkeys) already
matches the desired mapping; no broad input migration was imposed on profiles.

Verified target backup: ~/eclipse-backups/input-settings-20261031-152255/.
Saved input update was guarded by comparison to the backed-up original. Preview
and deployment updated keymap.tsv, keymap.lua, keybinds.lua and SettingsService.
Target persisted map version 2, reported kb_variant=,winkeys and an effective
modmask=64/key=comma Settings binding with no custom Settings override. Reload
and configerrors passed; status IPC and repeat sync were healthy. Local syntax,
Lua keymap regressions and 12 Python regressions passed.

Synthetic shortcut attempts were inconclusive: named sendshortcut is unavailable
with this Lua compositor configuration; transient virtual-keyboard injection did
not open Settings. This is not a verified physical-key result. The registered
Settings global action was separately invoked. The owner subsequently completed
the physical English/Persian Super + comma and familiar Persian typing/digits/
punctuation/ZWNJ batch and reported “it works well”. These checks pass by owner
observation; issues #1 and #3 are resolved. Temporary keyboard binary/settings
copy and QML fixtures were removed after verification.

## Strata live palette and Dolphin theme evaluation

Strata 1.1.0 deliberately resets generic GTK user styling above the user-provider
priority. Release-source inspection confirmed its supported custom TOML token
themes are directory-watched and the selected theme is reapplied after changes.
Eclipse now atomically writes ~/.config/strata/themes/eclipse.toml on every
palette push. Explicit prepare-strata (also invoked by setup strata) selects
mode=theme/theme=eclipse while Strata is closed, backs up the previous settings,
and preserves unrelated root/nested preferences. It does not write Omarchy state
paths, replace style.css or require a watcher process of our own.

The initial restart-only evaluation (superseded by the live-style cutover below)
used generated XDG_DATA_HOME/color-schemes/Impasto.colors and
dolphinrc [UiSettings] ColorScheme=Impasto, preserving other settings. The
internal scheme ID follows the existing Qt/KDE theme convention, not a broad
rename. qt6ct palette/config replacement now triggers its directory watcher.
Upstream inspection found a three-second debounce, but Dolphin's explicit
KColorSchemeManager palette is app-owned and is not live-managed by qt6ct.
There is no inspected supported external reload endpoint for this combination;
no invented D-Bus signal, invalid scheme workaround or automatic restart added.
Close/reopen Dolphin to apply a changed palette.

Target backup: ~/eclipse-backups/file-manager-theme-20261031-163421/.
Target already had Strata 1.1.0, Dolphin 26.08.2 and qt6ct 0.11; no packages were
installed. Generated/selected the native Strata theme while both file managers
were closed, then launched test windows. Using the real desktop palette IPC,
switched Catppuccin Mocha → Latte and restored Adaptive. Screenshots visually
confirmed Strata changed dark → light → adaptive in the same PID (165171).
Dolphin kept its previous colors live, then picked up light/adaptive after
closing/reopening the test process. Both apps' surfaces/text/selection/icon
colors were inspected; not every widget or document syntax theme is covered.

Default inode/directory remains io.github.lgse.Strata.desktop. Portal routes
were byte-compared against the backup and remained unchanged. No file-manager
association/portal setup command was run for this theme-only deployment. The
owner's adaptive palette was restored. Regression coverage checks preference
preservation, absent-Dolphin behavior, malformed KDE config protection and live
Strata token replacement without rewriting settings. Final local/target syntax,
17 Python regressions and Lua keyboard migration passed; settled shell status
and repeat preview were healthy. Owner visual acceptance remains pending in #2/#4.

## Native file-manager live style and materials — 2026-11-01

Focused target backup: `~/eclipse-backups/native-material-final-20261101/before.tar.gz`;
earlier material backup: `~/eclipse-backups/native-material-20261031-173352/`.
Backed up user shell/input/application config, Strata config, Dolphin preferences,
activation files and compiled style before staging the focused changes. No
system packages, boot files or development-workstation desktop config changed.

Built and installed the Qt6 Widgets style through `setup dolphin` on the dedicated
Arch laptop (Dolphin 26.08.2, Strata 1.1.0, GTK 4.24.1, Hyprland 0.56.2).
The build completed; optional Vulkan headers were absent, not required by this
Widgets plugin. Removed temporary style diagnostic code before the final build.
Repaired and exercised both installed desktop entries through gtk-launch;
GLib's key-file escaping had previously rejected them and used the packaged
unstyled entries instead. One initial reopen loaded the plugin.

Actual desktop palette IPC switched Mocha → Latte in the same Dolphin PID 4206
and Strata PID 4227. Captures showed live dark/light surfaces, text/selection and
accent-following rounded Dolphin folders, with inherited document/device icons.
Atomic state replacements were consumed by the already running style.
No application restart was used for these transitions.

Rendered the actual AppearanceSection files tab in a disposable QML window using
the repository's relative-import scanner. Its actual SettingsService changed
Classic → Liquid → Classic → Glass, with saved material state and the main shell
propagating it to both running apps. Settled captures showed opaque Classic and
blurred Liquid backgrounds with opaque content; Glass was also visually inspected.
Game mode on kept effective material Classic despite selecting Glass; off restored
Glass. Restored Adaptive palette, Glass material and Game mode off. Strata remains
the inode/directory default. Portal provider selection was not changed; only its
per-user activation environment was scoped to the GTK blur opt-out. Existing
chooser flows were not repeated in this pass, so their material appearance is not
claimed as verified. Optical refraction and every Dolphin dialog are not covered.

During direct file deployment, executable modes were initially lost on two scripts;
restored source modes before successful end-to-end palette checks. Production
setup's atomic put already preserves source modes. Removed the disposable QML
smoke after use. Local and target `setup check` passed. System Python ran all 19
Python regressions successfully; Lua keymap migration passed. The mise Python
test run lacked PyGObject (`gi`), so that environment cannot run the VPN tests.
Owner visual acceptance is still pending; these observations do not close the
unrelated full-desktop/hardware gates below.

## Dolphin removed by owner decision — 2026-11-01

The owner rejected Dolphin after the live-style trial and selected removal,
not optional support. Removed its Qt plugin sources/metadata, state writer,
launcher/desktop entry, setup verb/extras build and generated icon dependency.
Removed Dolphin-only scheme generation and regression cases while retaining
shared KDE/qt6ct palette generation and preference-preservation coverage.
Settings now says File manager and describes Strata only; saved Ground values
and Strata's native theme, CSS and GTK blur opt-out are unchanged.

Target recovery archive: `~/eclipse-backups/dolphin-removal-20261101/before.tar.gz`.
The package-removal preview contained only Dolphin. Noninteractive polkit
authorization was unavailable, so a visible sudo/pacman terminal was opened on
the target. Subsequent pacman query confirmed Dolphin absent; no recursive
dependency removal was requested. Removed the dedicated compiled style, build
cache, generated soft icon themes, named scheme, style state, Dolphin preferences
and application cache/data after backing them up. Shared KDE/Qt packages remain.

Deployed the focused Strata-only changes to the target checkout and user shell.
Strata remained running as PID 4227, changed to Latte through actual desktop IPC,
and was visually inspected with blur and opaque text/icons after removal.
Restored Adaptive afterward. Local and target `setup check` passed, as did all
16 remaining Python regressions under system Python. Prior Dolphin trial
sections above are historical evidence, not current support requirements.

## Plugin source download refinement — 2026-11-01

Owner's plugin retry remained at 0/5 cloning Hyprland. Inspected actual Kitty
surface and Git children: about 42 MB received, with 112 KiB growth over a ten
second sample, not compilation or a password prompt. The original clone later
failed with curl 56 connection reset/early EOF. The owner's command saved output
to `~/eclips-plugin-install.log` (without the second e), which was inspected.

Pinned hyprpm 0.56.2 source confirms release branches bypass its shallow-clone
optimization and subprocess output is buffered until completion. Eclipse now
prepares the exact installed/running commit with depth=1 and pinned shallow
submodules, exposing Git progress directly. The supported --hl-url points
hyprpm at that local cache; child-only Git URL mappings keep submodule copies
local. Installed/running ABI/revision mismatches stop before fetching.
No global Git changes, unchecked mirrors or disabled TLS verification.

Real local Git regression ran on both development machine and target: requested
older commit instead of newer upstream HEAD, confirmed depth=1, moved root and
module upstreams offline, reused cache and recursively cloned/reset the pinned
root/module through the same operations hyprpm uses. Invalid revision rejected
before tree creation. All 18 local Python regressions and local/target syntax
checks passed. Setup dry-run also ran. This proves source preparation/handoff,
not completed plugin compilation/loading.

Backed up target setup as `~/eclipse-backups/plugin-setup-before-20261101` and
staged the focused helper/setup/docs/tests in the target checkout. A real GitHub
shallow source download on target still failed with a TLS unexpected-EOF/curl 56
error. Reduced transfer volume and visibility do not establish repaired network
throughput. No new privileged header/plugin build was started during this check;
plugin loading and effects remain unverified.
An additional child-scoped HTTP/1.1 fetch did not complete within four minutes;
stopped that diagnostic Git process tree explicitly after the SSH timeout left
it running. No HTTP version override was adopted. This is not proof that HTTP/2
caused the failures. The exact target commit was still absent afterward.
A real exact-source preparation on the development machine also failed to
complete within five minutes. No completed upstream snapshot or plugin build
is claimed. The deterministic real-Git fixtures establish the code path's
correctness, while live GitHub throughput remains an external blocker.

### Successful installation after network change — 2026-11-02

Owner reports installation completed on a phone hotspot, then returned the
laptop to the previous network. Reconnected and observed hyprpm list with both
dynamic-cursors and HyprGlass enabled. The current Hyprland session's plugin
list shows dynamic-cursors 0.1 and hyprglass 0.11.0 loaded; configerrors is empty.
Shell status is healthy with Adaptive palette and Game mode off. Saved settings
have shakeToFind=true and windowGlass=false. No effect preference was changed.
Installation/loading now passes on target; physical shake-to-find and visual
refraction acceptance remain separate. Network change success supports a
network-path contribution but does not isolate Wi-Fi/router/ISP/GitHub cause.

The owner enabled Refraction in Settings → Windows and reported that it works
very well. Visual refraction is accepted by owner observation on the target.
This does not establish physical shake-to-find acceptance.

## Unified application and Quickshell materials — 2026-11-02

Owner selected exactly two material domains and explicitly accepted whole-window
fading for applications. Implemented two Appearance → Materials selectors and
removed terminal/file-manager/bar material controls and conflicting window
opacity/blur/refraction controls. Native Kitty background is 1; Strata root paint
is opaque; retired per-app generated state is removed on initialization.

Actual isolated SettingsService QML smoke exercised migration precedence for
explicit new values, old refraction, terminal, file manager, empty/frosted and
defaults; startup migrated legacy payload, preserved blur size, removed conflicting
opacity overrides and serialized only canonical keys. Saved Classic apps/Liquid
shell persisted without retired fields. No source-text/wiring tests added.

Target backup: `~/eclipse-backups/unified-materials-20261102/before.tar.gz`.
Focused QML/backend/Kitty/Hyprland files deployed with original modes and atomic
file replacement. Laptop's previous Liquid app preferences/refraction migrated
to windowMaterial=liquid while surfaceStyle=classic stayed unchanged. Actual
Materials section rendered with exactly two selectors. Native Settings inspected
with Liquid shell; class exclusion/tag observed in actual clients. Captures
showed opaque Classic Strata/Zen and shared Liquid Strata/Zen, plus Liquid Kitty.
Glass apps and independent Liquid shell were inspected. Native shell Liquid is
frosting, not HyprGlass refraction. Capture/deck chrome changed but full interaction
coverage of every shell overlay and arbitrary third-party app is not claimed.

With only the main shell writing settings, Game mode on disabled HyprGlass;
off restored Liquid/refraction, and compositor reload restored it again.
An early dual-process SettingsService smoke caused competing writes; removed
the extra process before the sole-shell restoration checks. Final state restored
Liquid apps/Classic shell, Adaptive palette and Game mode off. Temporary QML
harness removed after use. Local setup check and all 18 Python regressions passed.

## Image defaults and media accuracy — 2026-11-02

Owner reports images opened in the browser and requests media not be affected
by the unified material. Target imv 5.0.1 and mpv 0.41 were already installed.
Common image formats had no explicit defaults in ~/.config/mimeapps.list;
xdg-mime resolved PNG/JPEG/GIF/WebP/SVG to firefox.desktop. Set explicit imv
associations for common supported image formats on target; expanded setup's
existing imv defaults list for fresh installations. Kept browser/other defaults.

Backup: `~/eclipse-backups/media-accuracy-20261102/before.tar.gz`.
Added modules/media.lua shared by static rules and each runtime material push.
It protects imv/imv-wayland, mpv, Satty, reported photo/video and true fullscreen
windows with opacity=1, no_blur/no_dim and HyprGlass exclusion tag. No extra UI
selector, package or generic browser exemption introduced.

Reproduced imv opacity .75 before editing under Liquid. After deployment,
actual xdg-open of generated PNG launched imv; observed opacity 1, no_blur=true,
no_dim=true and hyprglass_disabled tag. Inspected color-bar capture: red, green,
blue, white centers were exactly (255,0,0), (0,255,0), (0,0,255), (255,255,255).
Actual mpv image playback also reported opacity 1 and blur/dim exclusions.
Actual fullscreen state 2 transitioned to opacity 1/tag and returned to ordinary
material afterward. Game mode on/off exercised with the media viewer open.
These prove compositor rendering of the fixture, not display calibration, every
image codec or a decoded-video playback scenario. Normal browser embedded media
and PDF tabs cannot be selectively protected by compositor rules.

## Application verification checkpoint — 2026-11-03

Owner confirmed Sine appears and works after setup/cache restart in Zen's
`3b2fnfvi.Default (release)` profile (`/opt/zen-browser-bin/zen-bin`).
Generated the native Telegram archive successfully at
`~/.local/state/quickshell/eclipse.tdesktop-theme`. Owner cannot use Telegram
on the test laptop without VPN access and explicitly deferred its checks.
Theme import/reapplication and Telegram attachment/save dialog acceptance remain
unverified; do not treat generated output as successful application. No VPN
setup or network change is authorized by this deferral.

## LazyVim optional LuaRocks health — 2026-11-03

Owner's lazy.nvim 11.17.5 health output reported missing hererocks Lua/LuaRocks,
while explicitly confirming no selected plugins require rocks. Resolved target
plugin specs also showed no rockspec build/rocks requirements. Disabled the
unused optional integration with documented rocks.enabled=false instead of
installing a redundant Lua toolchain. Future rock-dependent plugins require
deliberate re-enablement/provisioning; no required dependency failure is hidden.
Reference: https://lazy.folke.io/configuration

Focused target backup: `~/eclipse-backups/lazy-rocks-20261103/lazy.lua`.
Deployed only lua/config/lazy.lua to target checkout and installed config.
Actual target :checkhealth lazy returned all OK, including luarocks disabled.
Actual Neovim wrote/reopened English/Persian lines successfully. Local setup
check passed. Initial short smoke exit interrupted Mason's stylua download;
formatter provisioning is separate from the LuaRocks health correction.
Mason log then identified missing unzip as the StyLua extraction failure.
unzip was already in Eclipse's required editor manifest but absent on target;
installed only unzip through the target's package manager (successful transaction).
After waiting for Mason's installation lifecycle and actual executable rather
than its early installed state, StyLua 2.6.0 completed and formatted a Lua sample
successfully. Final target :checkhealth lazy remained all OK. Temporary formatter
smoke script removed. This is not a complete all-language LazyHealth acceptance.

## Kitty reference cursor trail and live accent — 2026-11-03

Compared actual parsed Kitty configs on both machines. Reference: beam/no blink,
trail 10, default threshold 2 and decay .1/.4; Eclipse: block/default blink,
threshold 0 and decay .01/.05. Matched reference settings in repo and target.
Backed up target files at `~/eclipse-backups/kitty-cursor-20261103/` and deployed
only Kitty config/theme_manager.py. Reloaded open Kitty via supported load-config.
Existing shell process may retain a prior cursor-shape escape until a new prompt
session starts; new sessions have shell_integration=no-cursor as on reference.

Generated cursor/cursor_text_color in the existing live palette push. Actual
running Kitty colors changed Adaptive #977846 → Mocha #89b4fa → Adaptive #977846
without process restart. Launched actual Kitty moving-cursor preview; capture
showed accent-colored beam/trail. Parsed target options match reference timing.
Removed disposable preview script and restored Adaptive. Local/target setup
checks passed. Owner subsequently confirmed the result is good.

## Compact OMP panel — 2026-11-03

Owner approved refining the oversized panel. Previous host reserved 560×620
even with no sessions; new shared OmpService dimensions use width 520 and grow
from 164 empty to 216 choose-one, 446 selected-one, and 566 selected with three
visible rows (additional rows scroll). Errors add a separate message allowance.
Updated island and module hosts; preserved selection/polling semantics. Grouped
context and session counters with explicit unknown/historical labeling. No new
data source, account telemetry or billing inference introduced.

Target backup: `~/eclipse-backups/omp-panel-20261103/before.tar.gz`.
Actual target OMP 18.12.6 TUI launched without prompt/tools/title/session saving,
using the installed Eclipse extension and temporary cwd. Observed real idle
snapshot with zero session counters and reported context estimate; selected it
explicitly in a disposable actual-panel QML surface. Normal Ctrl+D shutdown
published ended, and the selected detail stayed pinned. Removed only that test
instance's snapshot: panel became disconnected with the same last observation.
No provider turn or paid model request occurred.

Separate in-memory, clearly labeled visual fixtures exercised working state,
four sessions with three visible rows, long names/paths, and unavailable capacity,
tokens and cost. These are UI scenarios, not evidence of a real working turn or
usage accumulation. Captures inspected real idle, ended, disconnected, working
fixture, unknown fixture and final empty actual island. Measured content height
to keep footer visible; fixed numeric grouping to avoid decimal token counts.
Initial QML inline components failed scanner resolution; replaced them with
file-scoped OmpLabel/OmpMetric, then observed Configuration Loaded successfully.
Temporary surface/status fixture removed and no fixture data written to the
production snapshot directory. Owner subsequently confirmed the deployed panel
is good; visual layout acceptance for #7 is complete. Provider-turn usage
accumulation remains outside these checks.
Final local/target setup check and the private-snapshot lifecycle/boundary
regression passed; compositor configerrors empty and actual shell status healthy.

## Owner VPN verification — 2026-11-03

Owner reports having checked VPN while a usable configuration was available
and confirms it worked. Accept the exercised everyday VPN workflow by owner
observation; do not require repeating it solely for assistant observation.
Protocol, import/manual path, DNS and routing scenarios were not specified,
so this confirmation does not establish every protocol/path or leak protection.
No credentials, private keys or live network inspection requested.

## Rounded geometric wordmark selection — 2026-11-03

Owner kept the original celestial emblem, dark background and pale-gold colors,
and selected lettering option 1 after comparing rounded geometry and C059 Roman.
Updated canonical wordmark SVG and identical Quickshell/SDDM copies, regenerated
Plymouth wordmark.png (1200×187) with librsvg, and rebuilt the static splash
composition with rounded letters. Inspected the rendered 1920×1080 composition.
Only lettering changed; original emblem assets and Plymouth behavior untouched.
Historical Plymouth renderer captures still show angular letters and are labeled
as historical in SPLASH.md. No live boot theme/default, SDDM files, initramfs,
bootloader or running development desktop modified. Actual target boot and
login-screen acceptance remain pending.

## Login preview identity and authentication-state correction — 2026-11-03

Owner reported missing selected background/emblem, misplaced lettering and a
spinner after submitting a real password in test mode. Actual target capture
showed the inherited painting and top-pinned wordmark; no emblem existed in
the theme. This was a missing login-theme cutover, not failed image decoding.
SDDM GreeterProxy sends login to a daemon socket; test mode has no valid socket
and therefore no login success/failure reply to clear the old theme's spinner.

Replaced inherited painting with selected dark gradient; added original emblem,
grouped rounded wordmark below it and reduced/repositioned clock to avoid
collision. Fixed dark/pale-gold greeter tokens. Removed obsolete painting asset.
Test mode is detected through Qt.application.arguments: banner warns of preview,
password submission clears input with explanation and never starts authenticating
or calls SDDM login. Power controls disabled; real login remains SDDM-owned.
Socket disconnect clears busy state and password. Informational messages are
muted rather than authentication-error red.

Target checkout backup: `~/eclipse-backups/login-preview-20261103/checkout-theme.tar.gz`.
Updated only checkout theme, not installed /usr/share/sddm or any service/boot
configuration. Restarted actual sddm-greeter-qt6 --test-mode in the live laptop
desktop. Captures showed gradient/emblem/wordmark at rest and awake. Injected
dummy letter/Return through Hyprland: explanatory preview message appeared,
field cleared and no loading spinner. No real password used by assistant.
Preview logs had no QML load/missing identity errors; absent user face uses its
existing initials fallback. Local/target setup checks passed. Actual PAM login,
wrong-password behavior and session startup remain unverified by this preview.
Owner subsequently confirmed the corrected preview is good. Login visual
acceptance is complete; this is not authorization or evidence of live deployment.

## Approved login-theme-only deployment — 2026-11-03

Owner explicitly authorized only the login-theme deployment. Target SDDM already
active with /etc/sddm.conf.d/10-impasto.conf selecting Current=impasto. Preserved
that internal path and configuration. Backed up installed theme/configuration at
`~/eclipse-backups/sddm-deploy-20261103/`; `theme/` is a full copy of the previous
theme, `replaced-theme/` is the old directory moved aside, sddm-config.tar.gz
preserves config, and service-before/after record the unchanged PID/state.

Prepared a root-owned 0755 directory with 0644 theme files, replaced only
/usr/share/sddm/themes/impasto, removing obsolete painting by directory cutover.
Byte-compared every installed file to approved checkout and configuration to
backup. Both passed. Actual test-mode greeter loaded from installed path and
rendered approved gradient/emblem/rounded wordmark; closed that preview afterward.
SDDM stayed ActiveState=active/MainPID=600. No PAM, session entries, bootloader,
Plymouth/initramfs or service enablement/restart commands used; no logout/reboot.
Manual wrong-password rejection, correct login and desktop startup remain pending.

Rollback if needed: from SSH or a text console, move the deployed theme aside
and restore the backup's `theme/` to /usr/share/sddm/themes/impasto as root. No
configuration rollback is needed because its bytes were unchanged. Do not
restart SDDM while an unsaved desktop session is active.

Owner subsequently reports the login works after accidentally restarting the
laptop. Accept successful real login/session return after reboot by owner
observation. Separate wrong-password rejection was not explicitly reported.
The restart explains the dropped SSH connection; it does not verify the new
Plymouth theme, which was not deployed in this login-only change.

## Selected Plymouth deployment — 2026-11-03

Owner authorized continuing with the selected splash. Inspected target: GRUB,
unencrypted ext4 root, vfat /boot, kernel 7.2.11-arch1-1, one linux default preset,
Plymouth impasto. Existing command line already has quiet splash; existing
impasto.conf drop-in inserts plymouth after udev. No hook/cmdline changes needed.

Recovery archives in `~/eclipse-backups/plymouth-review-20261103/`: before.tar.gz
contains old theme, config, working initramfs/kernel/microcode and GRUB output;
grub-inputs.tar.gz includes grub.d/default drop-ins. Preserved working initramfs
as `/boot/initramfs-linux-before-eclipse.img` and byte-compared before proceeding.
Installed only /usr/share/plymouth/themes/eclipse and selected Theme=eclipse.
Built with mkinitcpio -k /boot/vmlinuz-linux -g /boot/initramfs-linux-eclipse.new
--nopost using existing configuration. Build completed including plymouth hook.
Extracted new image and byte-compared descriptor, script, all runtime PNGs and
Plymouth config against selected sources before replacing the normal image.
Old image remained in place until those checks passed.

Final image SHA256 e6c6f458e183fcb369e51427c77f9be638965e97a392b447374c5b58284ede0f;
recovery SHA256 cb83849bb8b0455f287ee7efdc6751308c785c46c1a96a3e0a4b5a290200c501.
Both read-back checks passed. Kernel, GRUB output/defaults/drop-in, mkinitcpio
config/drop-in/preset hashes unchanged. /boot has about 720 MB free afterward.
No kernel/package update, GRUB regeneration, PAM/SDDM change, live Plymouth
daemon or reboot performed. Real splash/boot/login handoff acceptance pending.
Build log, extraction listing and checksums retained with recovery archives.
GRUB temporary recovery-image instructions are in SPLASH.md.

## Centered identity and continuous activity refinement — 2026-11-10

Owner requested removal of the login clock, a centered emblem and continuously
playing activity animation instead of progress-driven motion. Removed SDDM
clock/date component/timer and unused clock tokens. The emblem itself is at the
screen center with the selected wordmark below; account/session controls and
preview-only authentication handling remain. This does not remove the desktop
bar clock or change the shell lock screen.

Plymouth's emblem is centered at rest, with prompt elevation retained. Outer
meridians move/fade continuously from the refresh callback, independent of boot
progress; removed percentage-fill sprites/callback and obsolete progress assets.
Images are still scaled only at initialization. Shutdown/reboot uses the same
loop and a non-overlapping mode label. Regenerated the static composition.

Actual Plymouth script module rendered in Bubblewrap private network/PID/mount
namespaces with an extracted Xvfb binary, private PTY and software X11 renderer.
Frames 1.5 seconds apart differed without any boot-progress input; emblem stayed
centered. Visually inspected boot, shutdown and dummy-password layout with status
and diagnostic text. The dummy password client was canceled by daemon quit, not
submitted; no authentication pass is claimed. No theme runtime errors observed.
Actual SDDM test-mode greeter rendered on private Xvfb at 1280×720: clock absent,
centered emblem/wordmark, account controls below; dummy submission explained
preview-only authentication and returned control. Local setup check passed.

Target SSH at 192.168.4.74 timed out after reboot; these refinements are checkout
changes only. Installed laptop login/theme/initramfs still have the previous
version until reconnection and scoped deployment. No live development desktop,
Plymouth default/daemon, bootloader or initramfs was modified. Temporary renderer
scripts/extracted display binary were removed after verification.

### Target deployment after reconnection — 2026-11-10

User demonstrated normal SSH working. A subsequent interactive Bash SSH
connection succeeded; this does not establish the cause of earlier timeouts.
No SSH, VPN, firewall or routing configuration was changed for deployment.
Confirmed kernel and previous image/recovery hashes matched the earlier rollout.
Backed up installed SDDM/Plymouth themes and the then-current initramfs under
`~/eclipse-backups/centered-activity-20261110/` (root-owned, mode 0700).

Deployed only centered SDDM Main.qml/theme tokens and continuous-activity
Plymouth script/descriptor; removed obsolete clock/progress assets. Built the
same kernel into /boot/initramfs-linux-centered.new with existing configuration
and --nopost. Extracted it and byte-compared all runtime theme assets and
Plymouth config before replacing normal image. Build and all comparisons passed.
New image SHA256: 90e563880071c869cef95fb8ace1c486e4c614200444b37d60534255421d8be5.
Original recovery image remains cb83849bb8b0455f287ee7efdc6751308c785c46c1a96a3e0a4b5a290200c501.
Kernel, GRUB, recovery image, Plymouth selection, mkinitcpio inputs/preset and
SDDM configuration hashes unchanged. SDDM PID remained 573 throughout.
Installed QML/script match staged files; clock/progress assets absent. Target
setup check passed. No SDDM restart, logout or reboot performed. Manual real
boot/activity/login handoff verification of this revision remains pending.

## Larger login emblem and depth-layered orbital bands — 2026-11-10

Owner rejected the small login emblem and drifting/pulsing ring motion. After
review, requested orbital rings moving in front of and behind the emblem.
Increased centered SDDM emblem from 120 to 256 UI-scaled pixels and lettering
from 240 to 300, preserving account/control separation. Canonical emblem stays
unchanged. Replaced the two flat ring sprites with paired front/back projections
of two inclined precessing circular bands. Depth sign splits each segment at
the emblem's plane: far halves below the opaque emblem, near halves above it.

Original deterministic render-orbits.py generates 64 paired 400×400 PNG frames
with librsvg. Plymouth caches/scales them on initialization and swaps references
every six refresh callbacks; no refresh-time image rotation/allocation. Loop
wraps continuously, without progress input, drift or pulsing. Moved lettering
below the orbit canvas and elevated password state further to preserve spacing.
Removed superseded flat-ring sources/rasters and updated static splash artwork.

Actual Plymouth and SDDM test-mode rendered in private Bubblewrap namespaces,
private Xvfb/PTY and software renderer. Inspected four orbital frames one second
apart, password layout, enlarged login rest/awake and dummy submission. Near
bands cross the central disc; far bands are occluded. Dummy login returns the
preview explanation without authenticating. Both renderer processes completed
and local setup check passed; generator syntax also checked. No live workstation
configuration, service, network or boot image changed.

Deployment attempted through previously working SSH service, but it was already
in automatic reconnect and did not execute the preflight. Stopped the stale
reconnect loop; fresh interactive-Bash SSH also timed out. No part of this
revision reached the target. Installed laptop still uses the previous centered
small-emblem/drifting-ring revision. Enlarged identity/orbital revision is ready
in checkout; target deployment and owner animation acceptance remain pending.

Owner accepted the orbital preview and explicitly requested deployment. Two new
SSH attempts (multiplexed and normal interactive Bash, without root/network
changes) timed out before authentication. Prepared a self-contained transfer
bundle at /tmp/eclipse-orbit-deploy.tar.gz containing approved themes, payload
SHA256 manifest and a guarded deploy.sh. Script syntax and unprivileged --plan
passed; --apply has NOT run. Apply requires the designated root UUID, unchanged
kernel and known current/recovery image hashes; backs up installed state,
replaces only theme directories, builds/extracts a temporary initramfs, compares
every theme payload before cutover, and verifies configuration/recovery hashes
and SDDM PID remain unchanged. It never reboots or modifies SSH/network settings.
Target deployment and actual boot rendering remain pending manual handoff.

Regenerated handoff on 2026-11-12 at
`~/.cache/eclipse/orbit-deploy-20261112.tar.gz` after /tmp bundle disappeared.
Archive SHA256: c294096a76436d131d599226110f133f0dd9604c5a2bc98496678e6d99baa0b8.
Deployment script passed Bash syntax; read-only --plan verified payload checksums
both in the source bundle and after archive extraction. These checks do not
exercise privileged --apply. No target files changed; fresh target inspection is
required if its guarded identity/kernel/image checks no longer match.

After owner moved both machines to the same network, workstation Wi-Fi became
192.168.4.157/24 and 192.168.4.74 routed directly over Wi-Fi, not the VPN.
Authenticated target preflight matched designated root UUID, kernel 7.2.11-arch1-1,
known kernel/current/recovery image hashes. SDDM active, PID 564; /boot had 720 MiB
available. Copied approved archive and verified remote --plan successfully under
`/home/arsalan/eclipse-orbit-stage-h3Pz3ULc/orbit-deploy-20261112/`.
Two fresh SSH apply connections then timed out before authentication despite
a reachable neighbor entry. Submitted apply through the earlier authenticated
session as well; its completion is not yet observed. Do not infer deployment
success or blindly repeat apply: inspect session output/backup/image state first.

Existing authenticated session subsequently accepted sudo and completed apply:
`ORBIT_DEPTH_DEPLOYED`, backup
`/home/arsalan/eclipse-backups/orbit-depth-g42MjTv7`.
mkinitcpio built successfully; script extracted the temporary image and compared
every Plymouth payload file plus Plymouth config before atomic cutover. Kernel,
GRUB, original recovery image, mkinitcpio inputs/preset, Plymouth selection and
SDDM config all passed unchanged-hash checks. SDDM PID check passed (564).
No reboot/logout/service restart occurred. Local ./setup check passed all five
syntax phases. Actual new boot/shutdown motion and login acceptance remain owner
checks; previous isolated renderer evidence is not a real-boot observation.
Postcheck compared every installed SDDM payload file successfully; SDDM remained
active with PID 564. New normal image SHA256:
36005164b2b862052e10ba4ed88fa98161710b2d459e1e59266febbc18a71edf.
Recovery hash still cb83849bb8b0455f287ee7efdc6751308c785c46c1a96a3e0a4b5a290200c501.

Owner subsequently confirmed physical acceptance of this deployed revision:
orbital motion looks correct, larger login emblem looks correct, and login
returns to the desktop. This is owner-observed boot/login evidence, not a remote
renderer claim. Separate shutdown presentation and unrelated hardware scenarios
are not implied by that confirmation. SSH session later exited 255; no new
deployment failure was reported.

## Physical screen-edge acceptance — 2026-11-12

Owner confirmed on the test laptop that the note-deck editor opens without
crashing or leaving Settings stuck, and changed note content and placement persist
after reopening. Owner also confirmed that the edge audio spectrum responds to
playing audio and its placement controls work. No problems were reported.
These are physical owner-observed checks, complementing the earlier isolated
service and target deployment evidence; no multi-monitor behavior is implied.

## Idle action investigation — 2026-11-12

Owner clarified that automatic idle actions did not activate with no video or
input; this was not a report of video interruption. Target saved timers were
lock/screen/suspend 1/2/3 minutes. Actual shell was qs 0.3.2 PID 743; no protocol
initialization error was found. A harmless two-second IdleMonitor probe received
both input-only and inhibitor-respecting events on the target compositor.
Isolated production IdleService with inert power-action stubs registered all
three configured notifications, including after asynchronous settings loading.

Temporarily added a read-only idleProbe IPC target to installed Commands.qml;
this hot-reloaded the shell. Effective values were 60/120/180 seconds, enabled.
Subsequent live snapshot observed lock/screen monitors idle and LockService.locked
true. Owner confirmed the laptop then suspended and was woken/unlocked. System
journal confirms suspend at 10:01:47 and successful resume at 10:03:02. Actual
panel DPMS state was not captured; an idle screen monitor alone does not prove it.

Restored installed Commands.qml byte-for-byte to checkout (SHA256
f812d464ea8e423bff401c9b488a30c18a49d5ad57ff0181ca1e61b8cfc6469f), confirmed temporary
IPC absent and probe directory deleted. Removed local askpass helper. No timer,
network, power policy or permanent source change was made. Initial failure cause
remains unresolved; hot reload may have altered conditions. Do not claim a fix
or a clean-start verification. Playback inhibition remains unverified.

After owner provided an awake/unlocked test window, generated a silent synthetic
640×360 local test clip and launched mpv with --no-config, Wayland GPU output,
fullscreen and --stop-screensaver=yes. During a 74-second probe with no input,
input-only IdleMonitor became idle while inhibitor-respecting monitor did not.
mpv IPC reported core-idle=false at the end; playback continued beyond the saved
one-minute lock delay and monitor eDP-1 dpmsStatus remained true. This verifies
actual mpv Wayland inhibition, not Zen/portal behavior or waiting past every
configured delay. Player exited via cleanup; temporary video/probes were deleted.
Saved timers remained 1/2/3 minutes and the local askpass helper was removed.

Owner then explicitly confirmed a fresh-login check after reboot: with no media
or input, automatic lock at one minute, screen-off at two and suspend at three
all worked; wake/unlock succeeded. No diagnostic/reload was introduced during
that clean-session check. Close the reported idle investigation as currently
working with original cause unidentified, not as a code fix. No permanent
implementation change or regression test is warranted without an identified
defect. Zen/portal-specific inhibition is outside the mpv result above.

## Isolated home-file recovery scenario — 2026-11-12

Ran actual setup sync, sync --restore, files keep and uninstall against a copy
of current home/ and setup in a disposable Bubblewrap filesystem/network/PID
namespace. Only the case directory was writable; /usr and /etc were read-only,
no host home or runtime bus was mounted, /boot was absent, and IMPASTO_ROOT
pointed to the disposable system directory. No command stubs were used.

Behavioral assertions passed: pre-existing Kitty configuration backed up on
first sync; subsequent source update preserved an edited .bashrc and offered
incoming content as .new; user deletion respected until explicit --restore;
files keep removed the pending .new without losing the personal edit; uninstall
restored original Kitty configuration, retained edited .bashrc, removed unedited
shell files and removed the home manifest. Result: RECOVERY_SCENARIO_PASSED.

This is home-file deployment/update-conflict/recovery proof, not actual setup
update fetching, package transactions, full system installation or boot recovery.
No permanent code changes or host/target deployment occurred. Disposable scenario
and case files removed after recording results.

## Disposable VM preparation on test laptop — 2026-11-12

Owner requested VM testing on the test laptop rather than daily workstation and
approved downloads, new VM files, guest-only disk formatting/install/update and
recovery. Target has 15 GiB RAM, VT-x/KVM user access, about 835 GiB free, AC online
and QEMU 11.1.2/UEFI/graphical components already installed. No host package
installation is required or performed on either machine.

Created private directory
`~/.cache/eclipse/vm-validation/arch-install-4HjukhWt/` on the target with new
64 GiB sparse arch.qcow2 and private OVMF variables. Prepared 4-vCPU/4-GiB launcher
with user-mode NAT, guest SSH forwarding only on target localhost:22222 and no
physical disks, shared home/clipboard/USB, bridge or firewall changes. Per-VM SSH
key stays in that directory; no workstation/account credentials enter the guest.
Guest installer refuses formatting without matching VM UUID, KVM/QEMU detection,
virtual disk serial ECLIPSE_VM_DISK and exact 64 GiB size. Scripts pass Bash syntax
but have not run. Captured target boot-file hashes before any guest testing.

Official Arch 2026.11.01 ISO download initially timed out at about 76 MiB; resumed
from another official mirror with SHA256 and Arch keyring signature verification
required before boot. Verification/download outcome still pending at this record.
No VM boot, guest install or Eclipse system test is yet claimed. Existing target
Eclipse files, boot images, services and saved power timers remain unchanged.

Diskless QEMU/KVM smoke test started with the proposed 4 CPUs/4 GiB, queried
QMP query-kvm and returned enabled=true, present=true, then exited cleanly.
Transferred source-only Eclipse archive to the private VM directory and verified
SHA256 82a38b3f07838ec3a79004441fc9b18e9bfaa7e597aec7712165e145437c0d75.
This establishes emulator/source prerequisites, not installed guest behavior.

Owner approved a temporary sleep-blocking process for VM/download work, without
changing saved timers. Noninteractive user inhibitor was denied by logind;
authorized sudo invocation established Eclipse-VM-validation sleep:block inhibitor
PID 4563, bounded by timeout 14400 seconds. Locking remains enabled. Remove this
inhibitor when work stops; it is not a permanent power-policy change. Rechecked
all recorded host boot files: hashes unchanged.

ISO completed: SHA256 matched official
01bcdcf01af2f7d58f2794899c834770d25c9bfc945bd092b32bb66672a4a216.
Imported packaged armored Arch keys into a VM-private GPG home and obtained
VALIDSIG for official signing fingerprint
3E80CA1A8B89F69CBA57D98A76A5EF9054449A5C. Booted verified live image with KVM;
guest reports kvm, expected UUID and only the named 64 GiB vda plus ISO devices.
Initial serial guard stopped before formatting because sysfs serial path was
absent; corrected to observed lsblk SERIAL API. Guarded installer then partitioned
only guest vda and began actual pacstrap package transaction. Installation result
pending; not a passing full-install claim. Powered-off baseline/restore scripts
prepared but not run. No baseline snapshot exists yet.

First pacstrap transaction failed retrieving systemd package signature from
fastly (low-speed timeout); signature checks were not disabled. Prepared a
guest-only resume script verifying VM UUID, virtual disk serial and both mounted
guest partitions, without partition/format commands. Selected geo/rackspace
official mirrors inside live guest and resumed using cached package downloads.
Guest base transaction outcome remains pending. No Eclipse install has run yet.

Resumed pacstrap completed with package signature checks intact. Guest kernel
7.2.15, UEFI GRUB and initramfs installed; powered guest off and saved checked
baseline.qcow2 plus firmware variables. Installed guest then booted successfully,
NetworkManager/sshd active, expected VM UUID and /dev/vda2 root confirmed through
guest SSH. Live-installer and installed-system SSH host keys are recorded in
separate VM-private known-host files. Copied current Eclipse source into guest,
initialized its validation checkout, ran real full install --dry-run preview,
then started ./setup install --noconfirm with no skip flags. Outcome pending;
do not equate clean Arch baseline completion with Eclipse install success.

First full Eclipse install stopped in official-package retrieval: geo mirror
low-speed failures and rackspace HTTP 403 for sdl3. Package transaction did not
commit. Probed osbeck/moson/kernel.org mirrors from inside guest for failed
package paths; HTTP 206 range downloads succeeded. Changed only guest mirrorlist
and resumed unmodified full install, preserving cache/signature verification.
Install outcome still pending; no skip flags or disabled security checks used.

Resumed on 2026-11-14 after owner returned. Target VM was powered off; restored
the approved bounded temporary sleep hold and booted saved installed guest.
All recorded laptop kernel/initramfs/recovery/GRUB hashes still matched baseline.
Prior full install had installed official packages and most AUR packages but
failed spicetify-cli 2.46.4 in pnpm/esbuild postinstall: node: command not found.
Its AUR recipe declares go/pnpm but no Node runtime; fnm alone supplies no node
to the noninteractive build. Added explicit nodejs prerequisite in Eclipse's
pacman manifest, copied that manifest into guest and resumed full install without
skip flags. Local ./setup check passed all phases; actual build outcome pending.

Corrected full install completed successfully in the VM (exit 0, 5m59s):
nodejs supplied the missing runtime and spicetify-cli built/installed. User and
system files deployed; cursor seed built; verified OMP 18.12.6 installed; Eclipse
Plymouth selection, initramfs and GRUB rebuild succeeded. Installer correctly left
display-manager activation explicit, deferred plugins to graphical session and
reported Strata palette, Sine profile and Spotify first-use prerequisites rather
than claiming those integrations applied. No camera/IR devices exposed.
Subsequent guest postcheck could not start because host SSH timed out before
authentication. SDDM cutover, graphical boot, update and recovery are not yet
verified. VM and bounded temporary sleep inhibitor may still be running; inspect
and release the inhibitor when access is restored. Do not rerun installation
merely because the postcheck connection failed.

Guest post-install checks passed: setup check all phases, 775 installed packages,
Plymouth selection eclipse and all 128 orbital frames present in initramfs.
Explicit ./setup login --noconfirm enabled SDDM only inside guest. Rebooted guest;
SDDM greeter started successfully and actual X11 screenshot visually confirmed
installed Eclipse identity at 1280×800. QMP screendump on EGL scanout returned
no surface; captured through guest X display instead. This is real greeter boot,
not yet authenticated guest desktop login or plugin-build verification.

Controlled file:// fast-forward update scenario was correctly refused by the
installer's origin safeguard (Git resolves insteadOf before remote get-url).
Removed VM-local rewrite; actual HTTPS fork origin restored and fetch started.
No safeguard weakened and no upstream commits published. Prepared separate
same-kernel guest recovery kernel/initramfs and GRUB entry with command-line
marker; recovery boot still pending.

Authenticated disposable guest login through actual SDDM/PAM succeeded; journal
confirmed session opened, Hyprland PID 1342 and Quickshell PID 1382 from deployed
configuration. Inspected real grim desktop screenshot with bar/wallpaper and
first-session plugin terminal visibly downloading matching Hyprland sources.
Compositor configerrors empty. Deferred Strata setup then succeeded after the
first shell palette generation; portal/FileManager1 configured in guest only.
Plugin compilation/loading remains in progress, not passed. Initial timed-out
Git fetch survived its SSH caller and owned shallow.lock; did not delete its
live lock or start another writer after identifying it. Actual fetch completion
is being awaited before real-origin update testing.

Actual HTTPS upstream fetch completed (6e5cb0a, parent a7e014c). Separate guest
checkout based on upstream parent preserved current-source edits; setup update
performed real fast-forward, detected autostash conflicts and stopped before
deployment. Resolved only conflicted documentation to current-source copies,
confirmed no unmerged files and discarded the now-applied stash. Reran protected
setup update: HTTPS pull already up to date, all 98 official/10 AUR dependencies
satisfied, home/system repeat deployment reported nothing to do, exit 0. This
exercises actual pull, conflict protection, explicit recovery and install rerun;
it is not a mock local-origin success. Node v26.13.1 and Spicetify 2.46.7 execute
successfully in guest. VM-only recovery GRUB configuration passes grub-script-check.

First-session build completed and actual hyprctl plugin list showed both
dynamic-cursors and hyprglass loaded. Explicit grub-reboot recovery entry booted:
/proc/cmdline named recovery kernel and eclipse_validation_recovery=1; SDDM active.
Following ordinary boot succeeded without marker, but GRUB's automatic kernel
discovery chose the root-level backup kernel filename too. This VM-fixture naming
needs separating before claiming distinct normal/recovery paths. Guest powered
off; preserving full installed disk/firmware before baseline rollback test.
Physical laptop boot-file hashes still all match pre-VM baseline.

## Completed VM install/update/recovery verification — 2026-11-14

Moved guest recovery pair into /boot/validation-recovery to avoid GRUB automatic
kernel discovery. Confirmed distinct normal boot BOOT_IMAGE=/vmlinuz-linux with
SDDM active, then explicit recovery boot
BOOT_IMAGE=/validation-recovery/vmlinuz-linux with eclipse_validation_recovery=1
and SDDM active. Both used guest kernel 7.3.4 after real package upgrade.
This proves the recovery entry boots; no deliberately corrupted image was tested.

Powered guest off, preserved installed image/firmware, restored original clean
baseline and booted it: kernel 7.2.15, NetworkManager/sshd active, no installed
Quickshell package or deployed shell config. Restored baseline has a distinct
SSH host key, retained in separate baseline-known-hosts. Powered baseline off and
returned the retained installed guest disk/firmware to arch.qcow2/OVMF_VARS.fd.
qemu-img check passed. Installed guest remains powered off and preserved under
the recorded VM directory; clean baseline and tested baseline copy also retained.

Released approved temporary sleep-block inhibitor; systemd-inhibit list no longer
contains Eclipse-VM-validation. Removed workstation temporary authentication
helper. Physical laptop kernel, normal/recovery initramfs and GRUB hashes all
match pre-VM baseline. No workstation VM packages/config were installed.

VM slice complete: actual full package/system install (after explicit Node.js
build-prerequisite fix), graphical PAM login/Quickshell surface, both plugins,
actual HTTPS upstream update with safe conflict handling, distinct recovery boot
and clean-image rollback/boot. Local and guest setup checks passed. First-use
account/application steps and remaining physical scenarios retain their separately
recorded limits; VM results do not substitute for those.

## Browser and everyday panel acceptance — 2026-11-14

Owner confirmed fullscreen Zen video continued without automatic lock during
at least 75 seconds without keyboard/mouse input, past the enabled one-minute
lock threshold. This adds browser-specific playback evidence to the mpv result;
it does not claim every browser media/portal mode or every timeout was tested.

Owner also confirmed launcher, control centre, notifications, notes and task board
open/close correctly; a disposable task's changed status persisted after closing
and reopening. Test-task cleanup was included in the scenario. No failures or
additional observations were reported. These are owner-observed physical checks.

Owner subsequently selected no face-unlock requirement for this personal setup;
optional support remains implemented but unverified, not an acceptance gate.
Owner confirmed normal shutdown presentation looked correct, the laptop powered
off, and subsequent startup/login worked. No failures reported. Owner subsequently
explicitly excluded external-monitor workspace/transfer/hotplug/lid acceptance
from this milestone; support remains unchanged and unverified, not passed.

## Completed milestone and verification limits

1. Approved larger-emblem/depth-orbit revision is deployed and owner-accepted for
   boot, shutdown presentation, power-off and subsequent startup/login return.
   Rollback backup is recorded above. Do not change workstation networking or
   assume target state from older backups.
2. On 2026-11-12 owner explicitly omitted Telegram checks, real OMP provider-turn
   usage verification and broader VPN scenarios from remaining acceptance scope.
   These are intentionally unverified, not passed and no longer pending gates.
   This supersedes the earlier Telegram deferral; it does not remove any installed
   functionality. Sine, Neovim and OMP launch/status/layout evidence remains valid;
   everyday VPN use passed by owner report. Integrated GitHub navigation was
   removed by owner decision. Application and GitHub/VPN integration tasks are
   closed under the revised scope without claiming omitted checks succeeded.
4. Physical Persian mapping, Settings shortcut, note-deck editor/content/placement,
   spectrum, fresh-session idle actions, mpv and fullscreen Zen inhibition passed.
   Launcher/control-centre/notifications/notes/task-board open/close and task status
   persistence also passed by owner report. Multi-monitor scenarios are explicitly
   excluded from this milestone and unverified; these results do not prove them.
5. Current SDDM login/session return and depth-orbit boot presentation passed by
   owner report. On 2026-11-12 owner reported the test laptop battery is dead and
   it only operates on AC. Battery suspend/resume, low-battery and battery-drain
   scenarios are not applicable on this target in its current condition; do not
   unplug it for testing. This is a hardware limitation, not a passing battery
   test. Earlier AC suspend/resume and AC lid-close sleep/wake checks remain valid.
   Optional face auth was not selected by owner and is not an acceptance gate.
   Owner confirmed no external monitor is available and explicitly excluded
   multi-monitor workspace, window-transfer, hotplug and external-monitor lid
   acceptance from this milestone. Functionality is retained and unverified.
6. Identity choices and orbital preview are approved. Fantasy scene artwork remains
   deferred. Home-file recovery and full VM install/update/package transactions,
   separate recovery boot and clean baseline restoration passed as recorded above.

The implementation and testing milestone is complete under the owner's revised
personal acceptance scope. This closes the current project checklist, not a claim
that every supported hardware/account scenario is verified. Telegram, real OMP
provider-turn usage, broader VPN scenarios and external-monitor acceptance were
explicitly excluded. Battery scenarios are unavailable on this AC-only target;
face unlock was not selected, and fantasy scene artwork remains deferred.

## Four additional preset palettes — 2026-11-14

Added Everforest, Jade Horse, Miasma and Last Horizon using installed Omarchy
color definitions mapped to Eclipse's existing tokens. Ran actual AppearancePanel
carousel and ThemeService in a disposable Bubblewrap namespace with private HOME,
XDG config/data/state/cache/runtime, no network/session bus/Hyprland connection,
Qt offscreen software rendering. Production palette application/export code ran;
no live workstation configuration or target deployment changed.

Each preset selected successfully through ThemeService, actual panel centered on
its ID, and captured panel screenshots were visually inspected for names, daubs,
selected border/marker and text. Logs recorded expected backgrounds/accents for
all four and PALETTE_SURFACE_PASS. Final private state persisted last_horizon;
app-palette.json contained its expected tokens. Local ./setup check passed all
five syntax phases. This is isolated actual-component verification, not target
laptop deployment, physical material rendering or owner visual acceptance. No
permanent test fixture added; disposable renderer files removed after verification.

## Fresh-install OMP launcher and skill discovery — 2026-11-16

Owner reports desktop directory launch failing and Eclipse skills missing on
this fresh Arch laptop. Installed OMP reports 18.20.2. Installed launcher and
package matched the repository, but live Hyprland/Quickshell PATH omitted
`~/.local/bin`; plain `omp skill list --json` returned an empty skills list.
The launcher now resolves setup's local executable when absent from PATH.
Registered the installed package with upstream `omp plugin link` through the
new registration helper; live skill listing reports both Eclipse skills from
`omp-plugins:user`, with no warnings. No broad setup sync/install was executed.

On this laptop's actual Wayland desktop, launched real Kitty/OMP using an
isolated HOME/runtime, PATH=/usr/bin, no credentials, no tools/title/session
saving, and no submitted prompt. Observed terminal text and extension snapshots:
general launch selected the isolated `~/Work`, home launch selected `~/Work`,
and project launch preserved a directory containing spaces. Eclipse skill
autocomplete displayed both skills. Separately registered the isolated package
and launched plain OMP without `--extension`; its real TUI completion again
displayed `eclipse-desktop` and `eclipse-development`. Closed only the disposable
terminals and removed their temporary files. Kitty logged isolated-environment
D-Bus and APC warnings but all three cwd paths and skill completion were
observed. No model/provider request or authentication change was performed.

`python3 -m unittest discover -s tests -p 'test_omp_setup.py' -v`: two tests
passed, covering graphical executable lookup, cwd/argument preservation,
registration preview, existing disabled registration, and same-name collision
refusal. `./setup check`: Python/Lua/Bash/JSON/TOML syntax passed.
`./setup omp --dry-run`: retained installed OMP and registered package.
The setup source now registers after sync and after the OMP executable step,
including an already installed executable. No physical shortcut keypress or
paid-provider-turn acceptance is claimed by these checks.


## Window focus distinction — 2026-11-16

Changed SettingsService, CompositorService, WindowsSection, SettingsPanel and
WindowsPreview. Exercised actual WindowsSection in a disposable Quickshell
FloatingWindow on this laptop's Hyprland Wayland session, with isolated state.
QtTest pointer clicks exercised dimming off/on, window shadows and shadow
emphasis; slider moved signals exercised dimming 22%, opacity multiplier 80%
and inactive shadow strength 25%. Assertions passed. Observed the rendered
controls/preview in a desktop screenshot with all rows visible; no QML load
errors. The pointer-driven test was disposable, not a permanent test fixture.

Material calculations observed via the real service: Classic/Glass/Liquid at
80% inactive multiplier produced 80%/72%/60% effective inactive opacity. Game
mode produced 100% opacity and a chunk with dimming off and zero visible shadow
alpha; leaving game mode restored saved values. Profile snapshot/adopt returned
success and retained focus fields; isolated settings.json persisted them.
Hyprland readback showed dim_inactive=true, dim_strength=0.22 and distinct
active/inactive shadow alpha 0x80/0x20; configerrors was empty. These checks
exercise configuration and the rendered settings surface, not pixel-accurate
measurement of application alpha, a fullscreen video, or an actual profile UI
switch. No such unobserved outcomes are claimed.

Deployed only the five changed QML files on this laptop, preserving originals
in `~/eclipse-backups/window-focus-20261116-111317/`; no setup sync/install run.
Live shell reloaded successfully and its Settings window opened. Final compositor
readback showed the chosen default dimming enabled at 18%; additional opacity
reduction/shadow emphasis are off. Hyprland configerrors remained empty.
`./setup check` passed Python, Lua, Bash, JSON and TOML syntax. Existing unrelated
tray-icon/IPC-property/text-input warnings remain in the shell log. Removed the
temporary verification surface/state after closing its process.


## Scratchpad workspace indicator repair — 2026-11-16

Owner's two reported disappearance cases are the reproduction. Inspected real
Hyprland 0.57.2 JSON using a disposable Kitty moved to special:scratchpad:
the special workspace has no id field. Fixed HyprlandService's workspace
ingestion to exclude overlays from numbered named/occupied state.

Deployed only services/HyprlandService.qml; original preserved at
`~/eclipse-backups/scratchpad-indicator-20261116-113357/HyprlandService.qml`.
The live shell reloaded the changed file. Captured both bars with the test
scratchpad hidden and shown on each of HDMI-A-1 and eDP-1. Also rendered real
WorkspacesWidget instances on both physical monitors in a disposable Quickshell
surface; visually inspected both strips across those cases. State readback
remained finite (span 20), with HDMI-A-1 workspace 1 and eDP-1 workspace 11
throughout. Closed only the disposable Kitty and proof surface, hid scratchpad,
and restored focus to HDMI. No user windows moved or closed.

`python3 -m unittest discover -s tests -p test_workspace_state.py -v` passed.
This isolated real-QML regression covers special workspaces without numeric ids
on either monitor, legacy negative special ids, numbered occupancy and monitor
selection preservation, visibility and finite repeater span after removal.
It clears compositor IPC identity, uses offscreen rendering and temporary state;
it skips when Quickshell is absent. Initial harness attempts did not execute
the assertions; the final runner requires an explicit success marker and uses
the complete copied QML module tree so singleton discovery is real.
`./setup check` passed all syntax sections; Hyprland configerrors was empty.


## OMP ended-session list cleanup — 2026-11-16

Updated OmpService's report ingestion to filter ended rows and clear selection
and cached details only when the selected row explicitly reports ended. Removed
obsolete ended-state UI branches; disconnected-state historical display remains.
Updated the development skill's lifecycle guidance. Collector/extension storage
and provider configuration are unchanged.

`python3 -m unittest discover -s tests -p test_omp_sessions.py -v` passed.
Real-QML isolated regression covers previously ended rows, unselected shutdown,
selected shutdown, no automatic replacement, disconnected retention and final
row removal. `./setup check` passed all syntax sections.

Launched actual OmpPanel/OmpService in a disposable Wayland Quickshell surface
with isolated runtime snapshots (clearly named Verification sessions; no model
requests). Selected first, marked its snapshot ended, and refreshed: readback
contained only second with empty selectedId/null details. Inspected the actual
rendered panel: first row/details absent, second retained, Select a session
shown. Ending second yielded empty list/null details and compact height 164.
This is controlled lifecycle evidence, not a newly launched provider session.
Closed the proof surface and removed only its temporary files.

Deployed only services/OmpService.qml and bar/island/OmpPanel.qml to the laptop;
originals preserved at `~/eclipse-backups/omp-ended-20261116-135124/`.


## Bluetooth blocked-radio repair — 2026-11-16

This laptop: BlueZ 5.88 active/enabled, Intel AX201 hci0 detected and firmware
load successful. rfkill showed ideapad_bluetooth and hci0 soft-blocked (neither
hard-blocked); bluetoothctl reported off-blocked and an explicit power-on failed.
The active user's existing /dev/rfkill ACL grants write access; no permission
or group changes were needed.

Exercised real BluetoothService/BluetoothDetail in a disposable Wayland window:
initial blocked=true/enabled=false; new explicit on cleared both software blocks
and powered /org/bluez/hci0. Fixed scan sequencing after observing the first
power-on succeeded but scanning waited incorrectly for a running process. With
onBusyChanged synchronization, observed powered/enabled true, blocked false,
discovering true, and dozens of discovered devices. Power-off/on repeated
successfully; scan followed completion. Inspected actual rendered device list.
No device paired, trusted, connected or forgotten; audio/peripheral acceptance
requires the owner's chosen device and is not claimed.

Four tests in `test_bluetooth_power.py` passed (Bluetooth-only unblock before
selected-adapter power, off without rfkill mutation, failure short-circuit and
adapter-path rejection). Final `./setup check` passed all syntax sections.
Deployed BluetoothService.qml, BluetoothDetail.qml and bluetooth_power.py only;
original QML files backed up at
`~/eclipse-backups/bluetooth-power-20261116-141851/`. Installed shell reloaded,
opened actual island Bluetooth panel and observed Discovering=yes. Closed panel
after verification; Bluetooth remains on. No full setup sync/install run.


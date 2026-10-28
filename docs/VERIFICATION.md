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

## Remaining target gates

1. SSH access and rollback archives are established; retain them throughout
   target testing. Exercise full install/update and recovery beyond the observed
   successful user sync; SDDM is already enabled, so no blind login cutover.
2. Exercise supported Strata/Zen/Telegram file dialogs and screen sharing;
   verify Sine in the selected browser profile after restart and native Telegram
   theme import/reapplication. No unsupported automatic theme application claimed.
3. Complete real OpenVPN and WireGuard manual/import UI, traffic, DNS,
   authentication/cancellation and full/split route checks.
4. Verify physical English/Persian mapping, remaining clipboard behavior,
   multi-monitor independence/transfer, retained panels, edge gestures/audio,
   effects and game mode. Single-display workspace/scratchpad checks passed.
5. Verify optional compatible face auth, external-monitor lid policy, battery
   sleep, SDDM login/session startup, and the new Plymouth theme during boot.
   Physical lock/password retry/repeat unlock, explicit AC suspend/resume and
   AC lid-close sleep/wake with Wi-Fi/session recovery passed by owner report.
6. Review the original visual candidate and finalize desired artwork/tuning.

The overall goal is still active. Passing these limited checks must not be
reported as a finished personalized desktop or a verified laptop deployment.

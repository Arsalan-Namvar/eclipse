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
This fixes the observed focus/lifetime handoff failure, **not proof that the
laptop crash is fixed**. Verify Edit, block save, Escape, reopening, and crash
logs on the affected laptop before closing BUG-01.

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

## Remaining target gates

1. Establish access to the dedicated laptop and preserve a recovery path.
2. Run installation and repeat update using the accepted fork, including
   backups/local edits and an explicit `setup login` next-boot SDDM migration.
3. Exercise supported Strata/Zen/Telegram file dialogs and screen sharing;
   verify Sine in the selected browser profile after restart and native Telegram
   theme import/reapplication. No unsupported automatic theme application claimed.
4. Complete real OpenVPN and WireGuard manual/import UI, traffic, DNS,
   authentication/cancellation and full/split route checks.
5. Verify physical English/Persian keys, switch choices, clipboard, monitors,
   scratchpad, retained panels, edge gestures/audio, effects and game mode.
6. Verify lock/password/optional compatible face auth, suspend/lid/resume, SDDM
   login/session startup, and the new Plymouth theme during actual boot.
7. Review the original visual candidate and finalize desired artwork/tuning.

The overall goal is still active. Passing these limited checks must not be
reported as a finished personalized desktop or a verified laptop deployment.

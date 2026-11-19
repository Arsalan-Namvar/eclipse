# Eclipse

<p align="center"><img src=".github/assets/eclipse-wordmark.svg" alt="Eclipse" width="360"></p>

A personal Arch Linux desktop built on [Impasto](https://github.com/andreumassanet/impasto), using Hyprland and Quickshell, with selected Omarchy-inspired workflows. Eclipse is its own Impasto-based fork—not an Impasto shell layered onto an Omarchy installation.

- [Design and feature decisions](docs/DESIGN.md)
- [Keyboard map and migration notes](docs/KEYBINDINGS.md)
- [Splash, original identity assets, and artwork direction](docs/SPLASH.md)
- [Observed verification and remaining target gates](docs/VERIFICATION.md)

## Implemented scope

The island remains the shared home for the launcher, control centre, notifications, and detail panels. The shell retains configurable bar layouts, profiles, notes and tasks, screen-edge note decks and audio spectrum, media and lyrics, weather, capture/OCR/colour picking, screen time, and VM/server/package tools. The dock, general desktop widget grid, games, pets, and Markets have been removed.

Eclipse adds independent monitor-local numbered workspaces, directional movement, a shared application-window scratchpad, and a consistent clipboard/shortcut family. Settings → Keys manages profile bindings; see the complete [accepted map](docs/KEYBINDINGS.md), including migration of inherited bindings. Common defaults:

| Action | Binding |
| --- | --- |
| Terminal | Super + Enter |
| Launcher | Super + Space |
| Strata | Super + Shift + F |
| Zen | Super + Shift + B |
| Close window | Super + W |
| Scratchpad show/hide | Super + S |
| Send window to scratchpad | Super + Shift + S |
| Lock | Super + Ctrl + L |

The integrated GitHub navigator was removed after target testing failed its responsiveness and usability requirements. GitHub CLI remains available for terminal/development use; existing credentials and browser access are preserved. OMP quick access, local session status, theme integration and Eclipse-specific skills replace legacy agent integrations. VPN Settings supports OpenVPN/WireGuard import/manual creation through NetworkManager. Actual account, VPN and hardware acceptance is recorded in docs/VERIFICATION.md.

Application configuration selects Strata and its supported chooser integration, Kitty, Zen with explicit Sine setup, Neovim/LazyVim, Telegram native theme export/import, Spotify/Spicetify, and Bash with ble.sh and Starship. Browser/profile modifications and Telegram theme application have explicit setup/application steps rather than an assumption that copying files completes them.

Strata is the sole selected file manager and follows palette changes live through its native **Eclipse** custom theme. Close Strata before the one-time `./setup strata` selection (this command also configures file-manager/portal integration), or select Eclipse in Strata's theme settings after a palette push. To select only the generated theme without changing associations, close Strata and run `python3 ~/.config/quickshell/scripts/theme_manager.py prepare-strata`. Dolphin and its experimental styling were removed by owner decision.

Both preset and wallpaper-derived palettes, retained materials, fonts, animations, game mode, animated wallpapers, input controls, idle/night light, lock/SDDM, optional face unlock, and Plymouth remain in scope. Original geometric Eclipse SVG identity assets replace the visible Settings/greeter wordmark; Plymouth uses the celestial-seal direction. Final scene artwork is not approved.

**Settings → Appearance → Materials** has exactly two choices: **Application windows** and **Quickshell**, each with Classic / Glass / Liquid. Hyprland applies one whole-window material to Kitty, Strata, Zen and other ordinary apps (including text/media): Classic is opaque, Glass uses 90% opacity and blur, Liquid uses 75% opacity and refraction when hyprglass is loaded (otherwise blur). Native app backgrounds stay opaque to avoid double fading. Quickshell's bar, island, Settings and panel surfaces use their own shared native material, keeping text/icons opaque and excluding them from application refraction. Lock authentication remains opaque. Game mode temporarily makes both domains Classic, then restores their choices. No per-app or bar material selectors remain.

Media-accuracy exceptions keep imv, mpv, screenshot editing, fullscreen and client-reported photo/video surfaces opaque, undimmed and unrefracted. Common image files open in imv. Embedded images/video and PDF tabs in a normal browser window still share its material—Hyprland cannot exempt part of a window. Open media in its viewer or use fullscreen for protected viewing.

Workspace and scratchpad animations have their own selector in **Settings → Bar → Workspaces**, independent of window animation presets. Normal sliding workspaces move horizontally; the scratchpad rises from the bottom and returns downward using the selected workspace speed/curve. Game mode temporarily disables both without changing their saved choices.

## Checkout and deployment

```bash
git clone https://github.com/Arsalan-Namvar/eclipse.git ~/Projects/eclipse
cd ~/Projects/eclipse
./setup help
```

This checkout is not a verified laptop installation. Read the [design and safety record](docs/DESIGN.md) before deploying. `./setup install` changes packages, user configuration, system files, plugins, and extras; it is not a preview. `--skip-system` still permits user configuration changes. Do not install or sync onto a development workstation as a substitute for an agreed target deployment.

The implemented setup verbs are:

| Verb | Purpose |
| --- | --- |
| `install`, `update` | Install the selected scope; update first pulls the repository |
| `packages` | Install the package manifests |
| `sync`, `system` | Copy user configuration or privileged system configuration |
| `login` | Explicit next-boot Ly/other-manager → SDDM cutover; `--restore` restores saved enablement without stopping the current session |
| `omp` | Install the verified Eclipse-supported OMP binary if absent; preserve an existing installation and register the deployed Eclipse package/skills |
| `plugins` | Build/enable the configured Hyprland plugins |
| `defaults`, `cursors` | Apply application associations/GTK defaults or build the cursor |
| `strata`, `sine`, `telegram` | Configure Strata/chooser, install Sine into a selected Zen profile, or generate a native Telegram theme for explicit import |
| `spotify`, `face`, `camera`, `splash` | Configure the corresponding optional integrations; prerequisites and privileges apply |
| `files` | List/manage tracked user-file edits with `list`, `restore`, `reset`, or `keep` |
| `uninstall` | Remove unchanged installed files and restore backed-up originals where supported |
| `check`, `help` | Run syntax checks or display current commands/options |

Use `./setup help` for current flags and prerequisites. Deployment copies files rather than symlinking them and tracks edits/backups; this does not make deployment risk-free or imply every external application can be rolled back automatically.

Run `./setup plugins` from a terminal inside the target Hyprland session, not as
root. Eclipse downloads only the installed/running Hyprland commit and shallow
pinned submodules, showing Git transfer progress. Sources are reused under
`~/.cache/eclipse/hyprland-sources/`; hyprpm still owns header validation, plugin
compatibility pins, compilation and loading. A package/session revision mismatch
requires logging out/in first. Failed downloads stop with the Git error; rerun
the same command after resolving connectivity. Git does not resume partial pack
transfers, but completed source/submodule objects are reused. No global Git
configuration or alternate download mirror is installed. This reduces transfer
size; it cannot guarantee GitHub throughput. Confirm success with
`hyprctl plugin list`—both dynamic-cursors and hyprglass must be loaded.

OMP desktop launch (`Super + Shift + A` or the island) opens Kitty in `~/Work`.
For a project launch, run `bash ~/.config/quickshell/scripts/omp-launch.sh`
from that project; invoking this launcher from home also selects `~/Work`.
Plain `omp` keeps OMP's own working-directory behavior, not the Eclipse launcher's.
The launcher resolves the setup-installed `~/.local/bin/omp` even when the
graphical session's PATH omits that directory. `setup sync` registers the deployed
Eclipse package when OMP is present; `setup omp` also registers it after checking
the executable. Registration uses upstream's local `omp plugin link` API, so plain
`omp` discovers `eclipse-desktop` and `eclipse-development` skills without extra
flags. Existing package enablement is preserved; a different same-named plugin
is not replaced. Restart OMP to refresh startup discovery. Provider login remains
separate; setup does not configure credentials or make model requests.

Settings → Windows → Focus distinction offers inactive dimming (18% by default),
material-relative inactive opacity, and optional shadow emphasis. A 100%
inactive opacity setting leaves the application material unchanged; lower values
multiply it and affect text/images too. Fullscreen retains the material's normal
opacity. Shadow emphasis requires window shadows; game mode suspends focus
effects without forgetting the profile's choices.

Bluetooth keeps BlueZ as its system service. Eclipse lists paired/bonded devices
even while disconnected, with Connect/Disconnect quick controls, connected
battery status and power/software-block recovery. **Manage Bluetooth** opens
`bluetui` in Kitty for scanning, pairing, trust, rename and removal. Setup installs
`bluetui`; Eclipse does not run a pairing agent or change discovery/pairable mode.


## Verification status

The current implementation and testing milestone is complete under the owner's revised personal acceptance scope. Physical laptop acceptance covers the single-display desktop, boot/login/shutdown, input/workspaces, notes/tasks/edge features, idle and media inhibition, capture and chooser workflows. A disposable VM on the test laptop passed full installation, authenticated graphical login, plugin loading, actual upstream update/conflict handling and boot/baseline recovery. Telegram verification, real OMP provider-turn usage, broader VPN scenarios and external-monitor acceptance were explicitly excluded—not passed or removed. Battery tests are unavailable on the AC-only target, face unlock was not selected, and fantasy scene artwork remains deferred. See [VERIFICATION](docs/VERIFICATION.md) for observed evidence and limits.

## Attribution and license

Eclipse derives from **Impasto by Andreu Massanet**. Preserve the upstream copyright notices and source headers. Impasto's original inspirations include [saneAspect](https://www.youtube.com/@saneAspect), [Tide-island](https://github.com/enhaoswen/Tide-island), [ChillPill-Shell](https://github.com/LUCKYS1NGHH/ChillPill-Shell), [k4](https://github.com/k4ditano/k4), and [diegoMalagrida/dotfiles](https://github.com/diegoMalagrida/dotfiles). Eclipse also draws selected workflow ideas from [Omarchy](https://omarchy.org).

Built on [Quickshell](https://quickshell.org) and [Hyprland](https://hypr.land). Retained assets and integrations include [Bibata](https://github.com/ful1e5/Bibata_Cursor), [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme), [Inter](https://rsms.me/inter/), [JetBrains Mono](https://www.jetbrains.com/lp/mono/), and palettes from [Catppuccin](https://catppuccin.com), [Tokyo Night](https://github.com/folke/tokyonight.nvim), [Gruvbox](https://github.com/morhetz/gruvbox), [Nord](https://www.nordtheme.com), and [Rosé Pine](https://rosepinetheme.com). Their own attribution/license requirements continue to apply.

Copyright © 2026 Andreu Massanet. Released under the [GNU GPL-3.0](LICENSE). Eclipse modifications remain GPL-covered; the original Eclipse SVG wordmark credits Eclipse contributors and is GPL-3.0-or-later. You may use, study, modify, and share the project under the license; distributed derivatives must preserve applicable notices and provide corresponding source as required by the GPL.

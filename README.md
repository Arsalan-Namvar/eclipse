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

The read-only GitHub navigator provides account, repository, organization, issue, PR, and contribution views through supported GitHub access. OMP quick access, supported local session/usage status, theme integration, and Eclipse-specific skills replace the legacy agent integrations; this is not a claim of an account-wide quota API. VPN Settings supports OpenVPN and WireGuard import/manual creation through NetworkManager, with everyday activation in the island network panel. Real endpoint traffic, DNS, and hardware behavior still require target testing.

Application configuration selects Strata and its supported chooser integration, Kitty, Zen with explicit Sine setup, Neovim/LazyVim, Telegram native theme export/import, Spotify/Spicetify, and Bash with ble.sh and Starship. Browser/profile modifications and Telegram theme application have explicit setup/application steps rather than an assumption that copying files completes them.

Both preset and wallpaper-derived palettes, retained materials, fonts, animations, game mode, animated wallpapers, input controls, idle/night light, lock/SDDM, optional face unlock, and Plymouth remain in scope. Original geometric Eclipse SVG identity assets replace the visible Settings/greeter wordmark; Plymouth uses the celestial-seal direction. Final scene artwork is not approved.

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
| `omp` | Install the verified Eclipse-supported OMP binary if absent; preserve an existing installation |
| `plugins` | Build/enable the configured Hyprland plugins |
| `defaults`, `cursors` | Apply application associations/GTK defaults or build the cursor |
| `strata`, `sine`, `telegram` | Configure Strata/chooser, install Sine into a selected Zen profile, or generate a native Telegram theme for explicit import |
| `spotify`, `face`, `camera`, `splash` | Configure the corresponding optional integrations; prerequisites and privileges apply |
| `files` | List/manage tracked user-file edits with `list`, `restore`, `reset`, or `keep` |
| `uninstall` | Remove unchanged installed files and restore backed-up originals where supported |
| `check`, `help` | Run syntax checks or display current commands/options |

Use `./setup help` for current flags and prerequisites. Deployment copies files rather than symlinking them and tracks edits/backups; this does not make deployment risk-free or imply every external application can be rolled back automatically.

## Verification status

Syntax and 18 backend regression tests passed, along with keyboard-migration checks. Real isolated workspaces/scratchpad, clipboard, Bash, LazyVim editing, OMP lifecycle/skills/theme emission, edge persistence, SDDM preview, GitHub navigation through isolated Zen, Strata chooser rendering, Sine staging, Plymouth rendering/password callbacks, and a controlled WireGuard tunnel were exercised. These do not prove laptop acceptance. OpenVPN traffic and several app/authentication/boot paths remain unverified. A related Settings Edit focus/lifetime failure was fixed in the nested runtime; **BUG-01 still requires confirmation on the affected laptop**. See [VERIFICATION](docs/VERIFICATION.md) for exact evidence and limits. No target deployment has occurred.

## Attribution and license

Eclipse derives from **Impasto by Andreu Massanet**. Preserve the upstream copyright notices and source headers. Impasto's original inspirations include [saneAspect](https://www.youtube.com/@saneAspect), [Tide-island](https://github.com/enhaoswen/Tide-island), [ChillPill-Shell](https://github.com/LUCKYS1NGHH/ChillPill-Shell), [k4](https://github.com/k4ditano/k4), and [diegoMalagrida/dotfiles](https://github.com/diegoMalagrida/dotfiles). Eclipse also draws selected workflow ideas from [Omarchy](https://omarchy.org).

Built on [Quickshell](https://quickshell.org) and [Hyprland](https://hypr.land). Retained assets and integrations include [Bibata](https://github.com/ful1e5/Bibata_Cursor), [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme), [Inter](https://rsms.me/inter/), [JetBrains Mono](https://www.jetbrains.com/lp/mono/), and palettes from [Catppuccin](https://catppuccin.com), [Tokyo Night](https://github.com/folke/tokyonight.nvim), [Gruvbox](https://github.com/morhetz/gruvbox), [Nord](https://www.nordtheme.com), and [Rosé Pine](https://rosepinetheme.com). Their own attribution/license requirements continue to apply.

Copyright © 2026 Andreu Massanet. Released under the [GNU GPL-3.0](LICENSE). Eclipse modifications remain GPL-covered; the original Eclipse SVG wordmark credits Eclipse contributors and is GPL-3.0-or-later. You may use, study, modify, and share the project under the license; distributed derivatives must preserve applicable notices and provide corresponding source as required by the GPL.

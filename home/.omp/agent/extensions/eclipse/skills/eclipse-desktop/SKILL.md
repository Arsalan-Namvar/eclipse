---
name: eclipse-desktop
description: Inspect, customize, or troubleshoot an installed Eclipse desktop (Hyprland Lua, Quickshell island/bar, palettes, Kitty, notes, tasks, capture, OMP, GitHub, VPN). Use before changing desktop configuration or services. Eclipse is an Impasto fork, not Omarchy.
---

# Establish the machine and authority first

Eclipse is a personal Impasto-based Arch desktop, not an Omarchy installation.
Do not run `omarchy` commands or assume `/usr/share/omarchy`, `~/.config/omarchy`,
or Omarchy's shell/plugins exist. This skill is guidance, not permission to edit,
sudo, deploy, read credentials, call paid models, or access another machine.

Start read-only: inspect `uname -a`, `hostname`, `pwd`, `command -v impasto`,
`command -v hyprctl`, `command -v qs`, and the relevant existing config. Establish
whether this is the development workstation, intended test laptop, or another
host before applying anything. The development checkout is normally
`~/Projects/eclipse`; `~/Work` is the general OMP workspace, not the checkout.
Never deploy to the current workstation merely because its paths exist.

# Architecture and real locations

- Installed shell source: `~/.config/quickshell/shell.qml`; services under
  `services/`, island panels under `bar/island/`, theme under `theme/`, Python
  helpers under `scripts/`. The repository counterpart is `home/.config/quickshell`.
- Installed compositor: `~/.config/hypr/hyprland.lua`, with modules under
  `~/.config/hypr/modules/`. Inspect the actual imports before editing. This is
  Lua configuration, not a guessed `hyprland.conf` or Omarchy bindings file.
- Preferences: `${XDG_STATE_HOME:-~/.local/state}/quickshell/settings.json`.
  Saved profiles may override defaults. Prefer the shell settings/IPC for live
  preferences over overwriting the JSON while Quickshell is running.
- Deployment manifests/backups: `${XDG_STATE_HOME:-~/.local/state}/impasto/`.
  The internal `impasto` paths and CLI name remain intentional.
- Kitty: `~/.config/kitty/kitty.conf`. Generated palette files are not the
  durable place for hand edits; inspect `scripts/theme_manager.py` first.
- OMP desktop package: `~/.omp/agent/extensions/eclipse/`; live local snapshots:
  `$XDG_RUNTIME_DIR/eclipse-omp/`; generated palette: `${XDG_CONFIG_HOME:-~/.config}/quickshell/omp-theme.json`.
  Never inspect OMP auth files, agent databases, transcripts, or provider APIs
  to answer a desktop status question. The island displays one explicitly
  selected extension-connected session, never account quota.

Eclipse retains the bar/island, notes, task board, screen-edge note decks and
edge spectrum, wallpaper-derived and fixed palettes, capture, media, weather,
GitHub navigator, and VPN controls. The general widget grid, dock, Markets,
arcade and pets were removed; do not recommend enabling their old settings.

# Supported inspection and actions

Read `impasto --help` first on the installed version. Read-only examples:

```bash
impasto status
impasto panels
impasto theme list
hyprctl version
hyprctl monitors -j
hyprctl clients -j
hyprctl binds -j
hyprctl configerrors
nmcli -t -f NAME,TYPE,DEVICE connection show --active
```

`impasto` returns JSON and failure exit status; inspect both. Its backend is
Quickshell IPC (`qs ipc call`), not an HTTP endpoint. Do not request `nmcli
--show-secrets`, environment dumps, credential files or private account content.
Notes/tasks/notifications can be personal: inspect only when relevant and authorized.

With authorization, existing shell actions include `impasto open <panel>`,
`impasto theme set <id>`, `impasto wallpaper set <path>`, `impasto reload`,
`impasto volume set <percent>`, `impasto brightness set <percent>`, and capture
commands listed by `impasto --help`. Quote paths; do not guess panel/theme IDs:
list them first. Capture may expose private screen content and reload can
interrupt UI: explain that before acting. Never log out/reboot/reset to diagnose
an ordinary appearance issue without an explicit need and permission.

# Safe customization

Read the current setting and its consumers; inspect active saved-profile
shortcuts as well as the Lua defaults. Back up only the affected files; make a
focused change through existing mechanisms. Explain expected effect and rollback.
Do not replace the whole preferences/config file, remove notes/tasks, disable
security, install packages, switch display managers, or alter NetworkManager
connections as a side effect of theming.

For an approved compositor edit, inspect the installed version/API and existing
binding conventions. Reload only on the intended host; check `hyprctl
configerrors` and exercise the affected key/window/monitor behavior. A clean
syntax check is not visual or hardware verification. Preserve a usable terminal
and the previous files so rollback does not require the broken launcher.

For repository changes read its `AGENTS.md` and `docs/DESIGN.md`; use the separate
`eclipse-development` skill. Never treat repository edits as installed results.

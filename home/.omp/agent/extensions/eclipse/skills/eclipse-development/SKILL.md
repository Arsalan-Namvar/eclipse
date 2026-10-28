---
name: eclipse-development
description: Develop or deploy the Eclipse desktop repository safely; distinguish source edits, syntax checks, live desktop changes, and test-laptop verification. Use for setup/install/sync/update or changes in the Eclipse checkout.
---

# Eclipse repository work

Locate the checkout (normally `~/Projects/eclipse`) and read its `AGENTS.md`,
`docs/DESIGN.md`, and relevant implementation before changing code. This is a
personal Impasto fork; preserve upstream attribution and intentional internal
`impasto` IPC/state identifiers. Do not add Omarchy dependencies or copy its
commands/paths as if they were Eclipse APIs.

Repository map: `home/` is deployed to the user's home; `system/` to privileged
locations; `packages/` holds manifests; `setup` is the deployment script;
`home/.config/quickshell/shell.qml` is the desktop shell entrypoint;
`home/.config/hypr/hyprland.lua` is compositor configuration. Read existing
services, singleton registrations (`quickshell/qmldir`), panel routing, and theme
emission rather than establishing a second mechanism.

Source edits do not authorize deployment. Establish target host and exact scope
before any deployment command. Read `setup`'s relevant command implementation:
`./setup install`, `sync`, `system`, `update`, `packages`, and `watch` may change
live files, services, authentication or packages. `watch` syncs immediately before
watching. Skip flags are not isolation: `--skip-system` still allows home changes.
Do not execute deployment commands as a harmless syntax test. Do not wipe disks,
replace unrelated user configuration, change accounts, or read credentials.

`./setup omp --dry-run` is a read-only preview. Approved `./setup omp` installs
the pinned, integration-tested OMP 18.12.6 prebuilt executable only if absent;
install/update extras also attempt it when OMP is missing. It resolves the
official build service's version/target metadata, verifies SHA-256, probes
`--version` in an empty HOME, and atomically creates `~/.local/bin/omp` without
overwriting an existing executable or symlink. It does not install Bun or
configure providers/authentication. Existing package-manager/mise installations
are retained; update those through their owner, not by overwriting their binary.
The prebuilt path supports glibc Linux x86_64/arm64. See the pinned upstream
[installer protocol](https://github.com/can1357/oh-my-pi/blob/v18.12.6/scripts/install.sh).
Shipped Bash initializes the installed OMP's supported `omp completions bash`
output only when OMP is present.

# Verification and rollback

When explicitly authorized to verify source, run `./setup check` in the checkout.
It parses Python, Lua, Bash/startup/completion files, JSON and TOML; it requires
Python 3.11+, Lua compiler and Bash. It does not validate QML, the OMP TypeScript
extension, rendered UI, runtime behavior, or laptop hardware. Check additional
new shell scripts explicitly with `bash -n <path>` if not covered by setup's
file selector. Never call an unrun check passed.

Exercise changed QML on the identified test desktop, observe actual UI and input,
and exercise component-specific behavior. Report host, versions, commands and
observed results separately from source review and inference. For a crash,
collect relevant non-secret diagnostics before proposing a cause. Keep user
content and unrelated edits; make rollback a focused restoration, not a blanket
reset. Consult deployment manifests/backups under
`${XDG_STATE_HOME:-~/.local/state}/impasto/` only as needed.

# OMP integration smoke workflow (manual, no paid prompt required)

On an approved test desktop with Kitty and OMP installed, launch
`bash ~/.config/quickshell/scripts/omp-launch.sh --general`. It should open OMP
in `~/Work`, establishing that directory without changing existing contents.
From `$HOME`, launch without `--general` and expect `~/Work`. From an existing
project and a directory containing spaces, launch without `--general` and
expect the exact caller directory. Inspect the OMP session's cwd through its UI
and the Eclipse snapshot's project field; do not ask a model to establish cwd.
Arguments are forwarded as separate argv entries; no approval flags are added.

Open the island OMP panel, choose one session, then open a second OMP terminal.
The selected identity must stay unchanged while model/status/context reflect
only that session. Change model without submitting a paid request if supported
by the installed OMP UI. Quit the selected OMP session: it should show ended;
kill a controlled disposable OMP process: it should show disconnected after ten
seconds rather than another terminal's metrics. If the shell restarts, choose a
session again explicitly. Runtime snapshots are private, volatile files and
retain ended sessions for the current login; do not infer account quotas.

For a paid-free snapshot regression, use a disposable HOME, isolated
`XDG_RUNTIME_DIR` (mode 0700), and `OMP_SKIP_SETUP=1`; do not copy authentication
or the live OMP database. Start OMP with the Eclipse extension explicitly and
inspect `python3 ~/.config/quickshell/scripts/omp_status.py` on that test install.
Without a selected model, OMP may return context tokens with capacity zero.
The published snapshot must retain finite `context.tokens` but set
`context.window` and `context.percent` to JSON null whenever capacity is zero,
negative, absent or non-finite. The panel must say capacity/percentage unavailable
and the chip must show status, not `0%`. With positive finite capacity, preserve
OMP's finite reported capacity and percent (including a real zero percent).
Undefined context stays null. Repeat lifecycle observations for live, ended and
stale snapshots, checking that the selected session never changes implicitly.

Change Eclipse's fixed palette and wallpaper-derived palette through the shell
on the test machine; within a few seconds OMP should recolor via its supported
Theme API without overwriting user config. Discover `eclipse-desktop` and
`eclipse-development` in OMP's skill list (or `skill://eclipse-desktop` using its
read tool). Exercise only the read-only inspection examples first. Current OMP
extensions are in-process code, not sandboxed. Missing/disabled extensions or
skills are honest unavailable integration, not proof OMP or authentication failed.

# Eclipse contributor instructions

## Project and intent

- The project is **Eclipse**, a personal desktop fork of
  https://github.com/andreumassanet/impasto, inspired by selected Omarchy ideas.
- Impasto is the foundation. This is not an Impasto shell layered onto Omarchy.
- The name Eclipse has personal significance to the owner. Do not impose a
  painting-related identity or rename it Haven or Orbit.
- Optimize for what the owner actually uses, not hypothetical users of the fork.
  Do not retain unwanted features solely to offer optional compatibility.
  Confirmed removals include the dock, general desktop widget grid, games, and
  pets. Explicitly retain screen-edge note decks and edge audio spectrum, with
  usable placement/configuration controls, despite shared desktop infrastructure.
  Preserve the bar, island, notes, task board, and both palette approaches.
- OMP (Oh My Pi) is the chosen AI harness: include quick access, supported
  usage/status integration, system-theme following, and Eclipse-specific
  system-aware skills inspired by Omarchy. Research actual supported interfaces;
  do not invent metrics or copy Omarchy-only paths/commands into Eclipse guidance.
- Retain Plymouth but replace the splash's Impasto/oil-painting presentation
  with the accepted mythic-celestial direction: an original astral-instrument/
  celestial-seal emblem, alignment motion, varied fantasy wallpapers, and clear
  everyday UI. Exact artwork is not yet approved. The owner can generate scene
  artwork from supplied prompts; use original vector work for precise branding.
- This is also a learning project. Explain the relevant architecture, reason for
  a change, and verification in concrete terms without assuming prior experience.
- Preserve the upstream license, copyright notices, and attribution.

## Agreed process

1. Establish the project in `~/Projects/eclipse` and maintain these instructions.
2. Review Impasto feature by feature with the owner. Document what to keep,
   remove, or change, including desired behavior and acceptance criteria.
3. Implement agreed changes in small, understandable increments.
4. Test each changed path, then verify integration on the dedicated laptop.

Use `docs/DESIGN.md` for project decisions and the feature-review record. Do not
infer preferences from silence or turn suggestions into accepted requirements.
Keep undecided items explicit. Update the record when decisions are made.

## Machines and safety

- The owner has a separate laptop running Arch Linux with Impasto installed.
  It is the intended test target; the owner is willing to break or wipe it.
- That does not authorize wiping disks or destroying unrelated data without
  explicit agreement on the specific operation.
- The development checkout is not the installed desktop. Do not install or sync
  into this workstation's live configuration as part of routine development.
- Do not assume the test laptop is connected or that local runtime results are
  results from it. Establish the test target before deploying.
- `./setup install`, `sync`, `system`, `update`, and other deployment commands
  can change live files, packages, services, or authentication. Read the relevant
  implementation before using them and agree on deployment scope with the owner.
- Skip flags are not isolation. In particular, skipping system files still
  permits user-configuration changes. An install is not a preview.

## Repository map

- `home/.config/quickshell/`: the QML desktop shell; `shell.qml` is its entry point.
  Existing directories separate bar/island, desktop, dock, lock, capture,
  settings, shared components, services, scripts, and theme code.
- `home/.config/hypr/`: Hyprland Lua configuration and modules.
- The rest of `home/`: user application configuration and supporting files.
- `system/`: files deployed outside the user's home directory.
- `packages/`: package manifests.
- `setup`: Bash installer, deployment commands, and syntax checks.
- `.github/workflows/check.yml`: existing CI, invoking `./setup check`.
- `README.md`: currently the inherited Impasto overview; do not treat it as an
  approved specification for Eclipse.

Read the relevant implementation and existing patterns before editing. Do not
rename internal `impasto` identifiers, state directories, IPC endpoints, or
installed paths merely because the fork has a new name. Handle branding and
any required migration as an explicit change, with all affected callers covered.
Do not mix a repository-wide rename into an unrelated feature change.

## Implementation and verification

- Prefer existing configuration mechanisms when they satisfy the agreed need.
- Keep each change focused on an accepted requirement; avoid speculative extras.
- Explain what changed and how the owner can exercise it.
- Run `./setup check` for code/configuration changes. It checks Python, Lua,
  Bash (including startup files and command completions), plain JSON, and TOML
  syntax. It requires Python 3.11 or newer for `tomllib`, `luac` (or `luac5.4`),
  and Bash.
- This command does not check QML or runtime behavior. Syntax success is not
  desktop verification. Exercise the changed behavior in the actual component
  or session and report the environment and result.
- Verify UI changes visually. For hardware-dependent behavior, verify on the
  target laptop; state clearly when that has not happened.
- For bugs, reproduce the failure before editing when possible, then verify the
  corrected behavior. Add focused behavioral regression coverage where useful.
- Update relevant documentation and decision status with implemented changes.
- Do not claim unrun tests, unobserved behavior, or test-laptop deployment.

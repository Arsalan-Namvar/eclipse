# Eclipse design and feature review

## Confirmed project decisions

- **Name:** Eclipse, chosen by the owner for its personal symbolism.
- **Foundation:** a personal Impasto-based desktop, inspired by Omarchy, not an
  Impasto shell integrated into an Omarchy installation.
- **Approach:** professional and educational; review features together, record
  requirements, implement agreed changes, and test them.
- **Workspace:** `~/Projects/eclipse`.
- **Fork:** https://github.com/Arsalan-Namvar/eclipse
- **Upstream:** https://github.com/andreumassanet/impasto
- **Observed starting commit:** `1a2ce200f4494aca9b5d3e17ea00f807c6086231`
  (`fix(repo): settle what the 0.6.0 review found`).
- **Test target:** a separate laptop already running Arch Linux and Impasto.
  The owner accepts breakage or reinstalling it. Connection details and the
  deployment method have not been established.
- **Reported greeter:** the owner installed Ly on the test laptop before
  Impasto. Installing Impasto did not change that greeter. The owner has since
  tested Plymouth/the splash and reports heavy Impasto/oil-painting branding.
- **Identity:** no requirement to preserve Impasto's painting reference.
- **Personal scope:** keep what the owner actually uses. Do not retain unwanted
  capabilities merely for hypothetical users cloning the fork. This supersedes
  the earlier rationale for retaining an optional dock and widget system.

The desktop should be personal, comfortable, and dependable. The owner has
finished listing requested additions and accepted the consolidated initial
keyboard map in `KEYBINDINGS.md`. Feature review is complete and the consolidated
scope has been implemented in the checkout. Runtime acceptance is not complete;
see the implementation checkpoint below. Earlier feature-review descriptions
record the original inspection/decision context, not current implementation status.

## Review method

Review one area at a time. For each feature, record:

- Current behavior, checked against the repository and, where needed, runtime.
- Decision: **keep**, **change**, **remove**, or **undecided**.
- Desired behavior and the reason for it.
- Any specific Omarchy inspiration.
- Observable acceptance criteria.
- Implementation and verification status, including the test environment.

An undecided feature remains unchanged. A decision to keep is distinct from a
feature that has not yet been discussed. Screenshots, upstream descriptions,
and suggestions are not evidence of the owner's preference.

## Review sequence

| Area | Topics | Status |
| --- | --- | --- |
| Everyday workflow | Applications, shortcuts, workspaces, window management | Complete initial map, independent per-screen workspaces, movement, clipboard, and scratchpad accepted; implementation pending |
| Shell | Island, bar, launcher, control centre, panels | Existing interaction retained; GitHub navigator, OMP integration, and VPN controls added; BUG-01 crash resolved with owner confirmation on target |
| Appearance | Palettes, materials, motion, fonts, wallpapers | Both palette approaches, three materials, animations, fonts, game mode, and animated wallpapers retained; effect research and final artwork pending |
| Desktop extras | Widgets, notes, tasks, games, pets | Remove general grid, dock, arcade, and pets; retain island notes/tasks plus edge note decks and edge spectrum |
| Applications | File manager, editor, messaging, media, shell, AI | Strata/chooser, Kitty, Zen+Sine, LazyVim, Telegram themes, Spotify/Spicetify, viewers, Bash+ble.sh+Starship, helpers, and OMP selected |
| System integration | Authentication, input, power, deployment | SDDM/lock/optional face unlock, Plymouth re-theme, input variants/Caps switching, cursor, idle/night light, inherited installer adaptation, and both VPN setup methods accepted |

## Consolidated scope checkpoint

The owner reports no further additions at this point. This closes the requested
feature inventory, not implementation or the entire goal. Do not keep asking
for approval of decisions already recorded; handle new discoveries explicitly.

- **Preserve:** island/bar/launcher/control-centre behavior, notes/tasks, edge
  note decks/spectrum, screen time, VM/server/package panels, capture/OCR/picker,
  media/lyrics, weather, all retained visual choices, profiles, input controls,
  idle/night light, SDDM/lock/optional face unlock, and Plymouth functionality.
- **Replace/adapt:** Nautilus with Strata plus supported chooser integration;
  inherited Neovim config with LazyVim; Vesktop with Telegram and native themes;
  Zsh/Oh My Zsh with Bash+ble.sh and Starship Nerd Font Symbols; legacy agent
  usage integrations with OMP; installation/update paths with the owner's fork.
- **Remove:** dock, general grid widgets (not edge exceptions), arcade, pets,
  Markets, bundled graphical editor, greeting/decorative terminal tools, and
  Super + Space language-switch option. Audit dedicated packages/assets and
  shared dependencies rather than mass-deleting a directory by name.
- **Add:** shared scratchpad; independent local monitor workspace sets and
  accepted movement rules; consistent clipboard family; read-only GitHub
  contributions/repos/orgs/issues/PRs including authorized private data; OMP
  launch/status/theme/system-aware skills; VPN Settings for OpenVPN/WireGuard
  import and manual creation with island network-panel activation.
- **Visual direction:** original mythic-celestial Eclipse identity and Plymouth
  re-theme. Owner rejected the first generated image and paused artwork iteration.
  This is deferred work, not permission to ship the inherited painting branding.

### Remaining design/research versus missing evidence

- `KEYBINDINGS.md` is the accepted initial map, including previously proposed
  assignments and displaced Notes/Capture actions. Refine ergonomics in testing.
- Research actual OMP data/theme/skills interfaces; Sine installation/palette
  coexistence; Telegram theme application; LazyVim integration; material/plugin
  compatibility; GitHub credential/API access; VPN forms/authentication/routing.
  Do not require the owner to choose APIs or pretend capability is already proven.
- Refine detailed panel layouts, numeric visual tuning, and first-use styling
  through actual implementation and test-laptop use; preserve agreed behavior.
- BUG-01's reported crash is resolved: after deployment and reboot, the owner
  physically exercised the Edit transition and confirmed it works. The owner
  also confirmed block save/persistence, Escape and reopening; see VERIFICATION.
- Test-laptop SSH access and user-configuration deployment are established.
  Do not modify the current workstation as a substitute for target testing or
  claim remaining hardware scenarios passed.

### Target feedback follow-ups — 2026-10-28

The owner reports the exercised keybindings work as intended. Keep the following
items open for focused implementation/testing; recording them is not a claim
that they have been fixed or deployed.

| Item | Owner observation / desired result | Follow-up acceptance |
| --- | --- | --- |
| Strata dynamic theme | Strata does not dynamically follow Eclipse's palette | Investigate supported theming; visually verify palette changes in the running file manager, documenting any actual limitations |
| Dolphin theming exploration | Also try theming Dolphin | Evaluate palette integration and inspect the actual application; this is not a decision to replace Strata or change default folder/portal associations |
| Persian layout mismatch | Target Persian layout is not the one on the development laptop | Compare actual compositor/input-method configuration on both laptops, match the owner's familiar character mapping, then physically verify Persian letters/punctuation and switching |
| Settings shortcut preference | Prefer Super + comma over Super + Ctrl + S | Implement the preference in the shared map/profile migration and reference sheet; verify collisions and behavior in both English and Persian before deployment |

These changes are deferred from the current feedback-recording step. Keep the
existing deployed configuration until the relevant follow-up is implemented.

### Implementation checkpoint — 2026-10-28

The checkout now implements the accepted keyboard/profile migration,
monitor-local workspace and directional movement rules, shared scratchpad,
clipboard family, retained edge notes/spectrum, and removal of the dock,
general widget grid, games, pets, and Markets. Application integration work
selects Strata/chooser, Zen/Sine, LazyVim, Telegram native themes, and Bash with
ble.sh/Starship. GitHub navigation, OMP launch/status/theme/skills integration,
and NetworkManager-backed OpenVPN/WireGuard import/manual forms and island
activation are implemented. External application setup remains explicit; these
implementation statements are not proof of target application or tunnel behavior.

The README now describes Eclipse rather than the inherited upstream product.
Settings and SDDM use the original outlined Eclipse SVG wordmark. Internal
state paths, IPC endpoints, CLI identifiers, and the installed SDDM theme path
are deliberately preserved. Plymouth identity/artwork details remain in
`SPLASH.md`; final scene artwork is not approved.

Observed verification is recorded in `VERIFICATION.md`, including isolated
runtime behavior, target user-configuration deployment, successful startup
after an owner reboot, and owner confirmation that the original Edit crash is
resolved. Complete authentication, OpenVPN traffic/DNS and hardware acceptance
are not claimed. Original artwork remains a candidate for review. Historical
status paragraphs below record earlier review stages; this checkpoint and the
verification record supersede their no-implementation/no-runtime statements
without marking every acceptance criterion passed.

## Feature decisions

Application choices and the initial shortcut grammar/map are confirmed below.

### WF-01: application shortcuts and default programs

**Decision:** change the file manager to Strata, keep Kitty, and use Zen Browser
with Sine installed and enabled. The initial shortcut grammar and first group
are accepted as the starting point, to be refined through hands-on testing.

Current repository defaults, inspected in
`home/.config/hypr/modules/programs.lua` and `modules/keybinds.lua`:

| Action | Fallback shortcut | Program |
| --- | --- | --- |
| Open terminal | Super + Return | Kitty |
| Open file manager | Super + E | Nautilus, new window |
| Open browser | Super + B | System default browser through `xdg-settings` and `gtk-launch` |

These are fallback bindings, not confirmed active bindings on the test laptop.
The Lua module reads profile overrides from
`${XDG_STATE_HOME:-$HOME/.local/state}/quickshell/keys.tsv`. An empty override
disables a binding. Changing a default alone may therefore not change an
existing profile's behavior.

#### Confirmed desired behavior

- **File manager:** [Strata](https://github.com/lgse/strata), replacing Nautilus
  as the chosen graphical file manager.
- **Terminal:** Kitty remains the chosen terminal.
- **Browser:** Zen Browser with [Sine](https://github.com/CosmoCreeper/Sine)
  installed and enabled. This requirement is not just stock Zen.
- No particular Sine mods or themes have been selected. Sine is a mod/theme
  manager integrated into browser settings and requires its bootloader; it is
  not merely a normal browser extension. A custom Zen build is not currently
  required by the stated goal.

#### Acceptance criteria

- The agreed file-manager shortcut opens Strata, not Nautilus.
- The agreed terminal shortcut opens Kitty.
- The agreed browser shortcut opens Zen; in the intended browser profile,
  Sine's settings interface is available after a full browser restart.
- Specific Sine mods are not acceptance criteria until chosen by the owner.

#### Integration questions for implementation

Strata documents folder handling, file-location handling, an optional system
file chooser, and encrypted-volume integration as distinct capabilities. The
application choice does not automatically approve every optional integration.
Its Omarchy-specific installer options must not be assumed suitable for an
Impasto-based Eclipse installation.

Check Sine's supported installation and update behavior and its interaction
with Impasto's existing Zen theming before changing browser files. Do not
overwrite the owner's browser profile to achieve this requirement.

#### Shortcut discussion

The owner wants Eclipse's own mapping combining useful ideas from both projects,
with consistency as a design priority, rather than adopting either map wholesale.
The owner accepted the grammar and first binding group below, with fine-tuning
deferred to comfort testing. Historical comparison against the checked-out
Impasto Lua bindings and installed Omarchy defaults:

| Action | Impasto fallback | Installed Omarchy default |
| --- | --- | --- |
| Terminal | Super + Return | Super + Return |
| File manager | Super + E | Super + Shift + F |
| Browser | Super + B | Super + Shift + Return, also Super + Shift + B |
| Launcher / main menu | Super + Space: launcher | Super + Space: Omarchy menu |
| Close window | Super + Q | Super + W |
| Float / tile | Super + Alt + Space | Super + T |
| Fullscreen | Super + F | Super + F |
| Super + L | Lock | Cycle workspace layout |
| Super + Tab | Workspace overview | Next workspace |

#### Accepted initial Eclipse shortcut grammar

Consistency should mean a predictable internal mapping, not mandatory parity
with another machine. Use modifier groups as a guide rather than a rigid rule
that makes frequent actions awkward:

- `Super` with a key: window management and navigation.
- `Super + Shift` with a letter: launch an application or personal tool.
- `Super + Ctrl` with a letter: system controls and desktop settings.
- Directional and workspace-number keys form a separate family: adding Shift
  changes focus/switch into move. These are not application shortcuts.
- Keep `Super + Enter` for the terminal and `Super + Space` for the launcher
  as deliberate high-frequency exceptions.
- Prefer one canonical binding per action, not multiple inherited aliases.

Accepted first group (subject to hands-on refinement):

| Action | Initial Eclipse binding |
| --- | --- |
| Kitty | Super + Enter |
| Strata | Super + Shift + F |
| Zen with Sine | Super + Shift + B |
| Launcher | Super + Space |
| Close focused window normally | Super + W |
| Toggle floating/tiling | Super + T |
| Toggle fullscreen | Super + F |
| Focus a window by direction | Super + arrow |
| Move a window by direction | Super + Shift + arrow |
| Switch workspace | Super + number |
| Move window to workspace | Super + Shift + number |
| Lock | Super + Ctrl + L |

Directional move/swap semantics, workspace follow behavior, layout cycling,
overview, clipboard, capture, shell panels, and other shortcuts still need
review. Identical modifiers must not be taken to imply identical dispatcher
semantics between the two projects.

Before implementation, audit the complete mapping and saved-profile overrides
for collisions. In particular, `Super + T` currently opens appearance;
later panel assignments must avoid the accepted browser's `Super + Shift + B`.
Move displaced actions deliberately, and document the fate of old bindings
rather than leaving accidental duplicates. The full remaining map is not yet
agreed; continue reviewing it before applying a full-map migration.

#### Shortcut verification criteria

- Each accepted binding performs its intended action in a running test session.
- No accepted combination also triggers an unrelated inherited action.
- Retained actions displaced by the new mapping remain deliberately accessible.
- Verify effective saved-profile bindings, not just repository defaults.
- During ordinary use, note awkward reaches, mistaken activations, and conflicts
  with application shortcuts or the owner's keyboard layout. Revise the map
  based on observed comfort, preserving the grouping principle unless the owner
  chooses otherwise.
- Finer behaviors still marked for review are not implicitly approved by this
  initial mapping decision.

**Status:** requirements documented; no application, installer, or shortcut
implementation changes made. No runtime check performed on the test laptop.

### SH-01: island interaction model

**Decision:** keep the island interaction model as is. The owner identifies it
as their favorite Impasto feature.

The [upstream island documentation](https://andreumassanet.github.io/impasto-docs/shell/island/)
describes a central capsule showing the time and running activity. Hover opens
a glance; click opens the control centre. Launcher, module details,
notifications, and other panels share this expanding surface rather than
independent popups. Opening a different panel replaces the current one;
Escape, clicking outside, or repeating its opening action closes it.

These are upstream descriptions to guide discussion, not runtime observations
of the test laptop or a verified specification of this checkout. Inspect the
matching implementation before changing it.

#### Accepted scope

- Preserve the island as the main shared interaction hub.
- Preserve hover-to-glance, click-to-open, and the existing closing behavior.
- Keep notifications within the island rather than moving them to a corner.
- Do not redesign these interactions as part of branding, application changes,
  or shortcut remapping. New shortcuts may open the same existing surfaces.
- This does not automatically approve every optional module or panel's contents;
  bar layout, dock behavior, and individual tools remain separate reviews.

#### Acceptance criteria

After application and shortcut changes, verify on the test laptop that hover
still opens the glance, clicking opens the control centre, notifications still
arrive within the island, and opening/replacing/closing panels still works.
Check these as preserved behavior, not as a new implementation.

**Status:** keep decision documented; no island code changes needed or made.
Runtime preservation has not yet been verified on the test laptop.

### SH-02: bar layout and visible modules

**Decision:** keep the existing bar arrangement, available styles, and visible
module choices as is. No Eclipse-specific rearrangement or removal requested.

The [upstream bar documentation](https://andreumassanet.github.io/impasto-docs/shell/bar/)
offers Grouped, Spread, One island, and Bezel styles. Its documented default
is Grouped, with workspaces on the left and Notifications, Network, Bluetooth,
Volume, and Battery on the right. These descriptions are not observations of
the owner's saved profile; do not reset that profile to the documented default.

**Acceptance criteria:** after later changes, preserve the existing layout and
style selection controls, workspace strip, and configured modules. Verify that
clicking retained modules still opens their island details. No bar code changes
are needed for this decision; runtime preservation remains to be checked.

### SH-03: dock

**Decision (revised):** remove the dock entirely. This supersedes the earlier
disabled-by-default/optional decision. Eclipse is for the owner's actual use,
not a feature collection maintained for hypothetical users.

The [upstream dock documentation](https://andreumassanet.github.io/impasto-docs/shell/dock/)
describes pinned applications followed by other running applications, with
click-to-launch/focus, middle-click for a new window, and a right-click window
menu. Existing settings cover visibility, edge, alignment, hover magnification,
and hiding until pointed at. These are upstream descriptions, not test-laptop
runtime observations.

#### Desired behavior and acceptance criteria

- Remove dock rendering, activation regions, hover logic, menus, settings,
  control-centre toggles, shortcuts/actions, and dedicated supporting code and
  assets that no retained feature uses. Do not leave an enable switch.
- Remove obsolete dock fields from shipped profiles and configuration paths.
  Existing saved profiles must not cause broken references or shell failures.
- Keep application launching through the launcher and accepted shortcuts.
- Audit launcher coupling to dock pins. Remove dock-specific pin markers and
  ranking dependencies while preserving independent application-use ranking;
  do not replace the dock with a speculative favorites system.
- Preserve existing files on user machines unless an explicit migration needs
  to update active configuration. Do not purge historical state unnecessarily.
- Verify the shell and launcher with both fresh configuration and existing
  profiles, and confirm that reaching a screen edge no longer exposes a dock.

**Status:** revised removal requirement recorded; no dock code removed yet.

### SH-04: launcher

**Decision:** keep the launcher as is, including its existing modes and
configurable sigils. Super + Space remains its accepted opening shortcut.

The [upstream launcher documentation](https://andreumassanet.github.io/impasto-docs/shell/launcher/)
describes application search plus prefix-selected calculator (`=`), window
search (`@`), countdown (`!`), clipboard history (`'`), emoji (`:`), and shell
actions (`>`). The sigils are configurable. This is documentation research,
not a runtime check of the laptop or this checkout.

**Acceptance criteria:** without the dock, Super + Space still opens the island
launcher. Verify launching for Strata, Kitty, and Zen plus calculator, window
search, countdown, clipboard, emoji, and retained shell actions. Preserve
prefix handling and independent application-use ranking; removing dock-coupled
ranking/markers and removed-feature actions are explicit exceptions to keep-as-is.

**Status:** keep decision recorded; no launcher code changes made. Runtime
preservation has not yet been checked.

### DX-01: desktop widgets

**Decision (revised):** remove the desktop widget system entirely. This
supersedes the earlier clear-desktop-with-optional-widgets decision. Screen-edge
notes and edge spectrum are explicitly retained under DX-04; no general grid
widget catalogue should remain.

The [upstream desktop documentation](https://andreumassanet.github.io/impasto-docs/shell/desktop/)
describes modules placed on a grid on the wallpaper, below application windows.
Widgets have selectable shapes and Modern, Analogue, or Sticker appearances.
Right-clicking the wallpaper offers arrangement controls. Desktop placement is
independent of bar placement, so disabling desktop widgets need not remove bar
modules. These descriptions have not been verified on the test laptop.

#### Desired behavior and acceptance criteria

- Remove general grid-widget rendering, grid placement, catalogue entries,
  widget-only styles/settings, and dedicated code/assets no retained feature
  uses. Preserve or adapt shared arrangement infrastructure needed by the
  explicitly retained edge notes/spectrum and control-centre editor.
- Remove widget entries from shipped profiles and prevent obsolete saved
  layout entries from breaking profile loading or the running shell.
- Preserve wallpaper rendering and both wallpaper/palette approaches.
- Preserve shared bar modules and island details: removing desktop views must
  not remove the underlying retained capabilities.
- Keep notes and tasks in the island. Remove note grid-widget placement but
  preserve note content and screen-edge note decks, retained under DX-04.
- Verify a grid-widget-free desktop with functional wallpaper, bar, island,
  notes, task board, and the optional retained edge surfaces. Removed widget
  controls must not remain; edge-feature configuration must stay accessible.
- Do not delete saved user content merely to remove widget infrastructure.

**Status:** revised removal requirement recorded; no widget code removed yet.

### DX-02: notes and task board

**Decision:** keep both notes and the task board, preserving their existing
functionality. Final shortcuts will follow Eclipse's accepted mapping structure.

The [upstream notes/task documentation](https://andreumassanet.github.io/impasto-docs/shell/notes-and-tasks/)
describes quick notes edited inside the island and an independent task board
with To do, Doing, and Done lanes and due dates. Notes can optionally be placed
on the wallpaper or screen edges; retaining the island tool does not require
desktop placement. These descriptions are not runtime observations.

#### Acceptance criteria

- Both tools remain accessible in the island after dock/widget removal.
- Notes can be created, edited, reopened, and archived/restored using existing
  behavior; saved content survives a shell restart.
- Tasks can be created, edited, moved between lanes, and assigned due dates;
  saved content and lane state survive a shell restart.
- No note or task grid widgets remain. Island editing, task-board functionality,
  and the explicitly retained screen-edge notes must remain intact.
- Preserve existing user data. Review final shortcuts with the remaining map
  rather than treating inherited bindings as accepted unchanged.

**Status:** keep decisions recorded; no notes or task implementation changed,
and no runtime verification performed yet.

### DX-03: games and pets

**Decision:** remove both games and virtual pets from Eclipse, not merely hide
them or disable them by default.

The [upstream games/pets documentation](https://andreumassanet.github.io/impasto-docs/shell/games-and-pets/)
describes an arcade of eleven games played in the island, with stored best
scores, and a virtual pet feature with feeding, play, and progression. Pets
can appear as a bar module. These are documentation descriptions, not runtime
observations of the test laptop.

#### Removal scope and acceptance criteria

- Remove the arcade and pet implementations, dedicated assets, and services
  that become unused. Preserve shared components needed by retained features.
- Remove their island panels, bar modules/buttons, desktop widget entries,
  control-centre blocks, launcher actions, settings, and default shortcuts.
- Update shipped profiles and configuration handling so obsolete games/pet
  entries cannot produce broken panels or widgets. Audit all actual entry
  points during implementation rather than assuming this list is exhaustive.
- Remove related timers, progression, score processing, and feature-specific
  feedback once no retained feature needs them. Do not leave running hidden
  feature logic behind a removed UI.
- Update Eclipse documentation so it does not advertise these features.
- This is an explicit exception to the earlier bar/launcher keep decisions:
  retain their interaction and layout mechanisms, but remove games/pet entries.
- Existing saved game/pet files on user machines must not be deleted as part
  of this cutover; removing support does not require purging historical data.
- Verify the shell starts, retained panels work, and loading existing profiles
  containing removed entries does not break the remaining desktop.

**Status:** removal requirements documented; no games/pet code or data deleted
during the feature-review phase. Runtime verification remains pending.

### AP-01: wallpaper and palette behavior

**Decision:** keep both wallpaper-derived colors and independently selected
fixed palettes as they are.

The [upstream wallpaper/palette documentation](https://andreumassanet.github.io/impasto-docs/theming/palettes/)
describes deriving a palette from the wallpaper and applying it to the shell
and supported applications, or choosing a fixed palette independently of the
wallpaper. These are documented capabilities, not test-laptop observations.

**Acceptance criteria:** changing wallpaper in derived mode updates retained
themed surfaces; a chosen fixed palette stays independent of wallpaper changes.
Both choices remain available after dock/widget removal. Check this on the
running test desktop, not just by inspecting configuration.

A default Eclipse theme/wallpaper remains a separate future choice. Zen/Sine
integration must respect the selected behavior without overwriting browser mods.

**Status:** keep decision recorded; no palette implementation changes made.

### AP-02: Classic, Glass, and Liquid materials

**Decision:** retain all three material choices. The owner explicitly permits
changing effect values and considering alternative packages/implementations
after research; retaining the appearance capability does not freeze its backend.

#### Research required before implementation choices

- Map each effect to its actual renderer: shell/QML drawing, native compositor
  blur, window refraction plugin, or application-specific transparency.
- Identify existing dependencies and their roles before proposing replacements.
  Do not assume Liquid shell surfaces require the same plugin as application
  window refraction.
- Evaluate supported Hyprland/Quickshell versions, maintenance and update
  compatibility, installation complexity, visual quality/readability, and
  performance on the dedicated laptop. Measure under stated conditions rather
  than inventing performance rankings.
- Prefer the existing implementation when it meets requirements. Replace a
  dependency only for a concrete benefit; explain tradeoffs before choosing.
- Research tuning and the default material separately from retaining all three
  options. No new numerical values, packages, or default look are approved yet.

#### Initial source evidence (not a completed comparison)

- `home/.config/hypr/modules/look.lua` configures native Hyprland blur with
  size 6 and two passes. These are current values, not approved Eclipse tuning.
- The same module guards `hl.plugin.hyprglass` and configures window refraction;
  its comments state layer effects stay off. The plugin starts disabled there
  and is described as controlled by the shell's compositor service.
- `setup` registers `hyprglass` from `https://github.com/hyprnux/hyprglass` and
  `dynamic-cursors` from `https://github.com/virtcode/hypr-dynamic-cursors`.
  Registration alone is not evidence that both are needed for each material.
- Further source inspection separates the retained paths: `Theme.groundOf`
  provides opaque Classic, accent-tinted Glass, and cool translucent Liquid.
  `GlassSheen.qml` draws gradients and inset bands; `LitEdge.qml` uses Qt Quick
  MultiEffect masking for directional rim light. CompositorService enables
  native Hyprland layer blur for translucent bar/island surfaces. These shell
  materials do not require hyprglass window refraction.
- Hyprglass remains the optional application-window refraction backend, guarded
  for availability and disabled in reduced-effects mode. The existing shadow
  decoration dependency is explicit. Shake-to-find is a separate cursor plugin.
- Conservative implementation choice: retain these existing renderers and
  dependency boundaries; no alternative has demonstrated a benefit or measured
  compatibility/performance improvement. Defer numerical tuning and any backend
  replacement to target-laptop visual/performance evidence rather than change
  packages to make the fork different. Actual plugin build/load and three-mode
  acceptance on the target are still unverified.

#### Acceptance criteria

Classic, Glass, and Liquid remain selectable for retained surfaces where the
material option applies. Verify distinct appearances, readable content, and
correct input on the running desktop after any implementation/tuning change.
Check compatibility and performance on the test laptop, recording versions and
conditions. Dock/widget removal must not remove shared material code needed by
the bar or island. Do not claim a plugin replacement reproduces the effect
without visual evidence.

**Status:** capability decision and research requirements recorded. No effect
values, packages, or rendering code changed. Animation preferences are recorded
separately below.

### AP-03: animations

**Decision:** retain the existing animations. The owner likes them; expect at
most small tuning during implementation/testing, not a redesign or replacement.

Preserve current motion as the baseline. Do not change durations, curves, or
dependencies simply to make Eclipse different. Any adjustment should address
a specific observed issue or owner preference and be compared visually on the
test laptop, including island transitions and window/workspace motion.

**Acceptance criteria:** retained transitions continue working after feature
removals. Any tuning remains small, preserves the feel the owner likes, and is
accepted through hands-on use. No specific numerical changes are approved yet.

**Status:** decision documented; no animation settings or code changed.

### SY-01: lock, login, and authentication

**Decision:** keep the existing Impasto lock screen and optional face-unlock
capability, and use SDDM with Impasto's graphical login theme. On the test
laptop this requires replacing the active Ly greeter. No biometric enrollment
or development-workstation authentication change is requested.

The [upstream lock/login documentation](https://andreumassanet.github.io/impasto-docs/shell/lock-and-login/)
describes a shell-drawn session lock with password authentication, an SDDM
login theme, and optional face unlock. The lock may show media and lyrics.
These are documented capabilities, not verified security/runtime properties
of this checkout or the laptop. Inspect the actual paths and dependencies
before proposing authentication changes.

**Clarified greeter choice:** the test laptop currently uses Ly. After the
distinction between login and boot splash was explained, the owner explicitly
selected Impasto's graphical SDDM login. The installer currently preserves an
existing display manager, so installing theme files alone will not complete
this migration. Inspect actual service/unit configuration before switching.

#### Acceptance criteria

- Preserve password lock/unlock and the existing lock/login appearance after
  shell feature removals. Eclipse's accepted lock shortcut remains
  Super + Ctrl + L rather than the inherited shortcut.
- On the test laptop, check incorrect-password rejection and successful unlock
  with a recovery path available. Do not claim authentication correctness from
  syntax checks or documentation alone.
- Preserve optional face-unlock setup and controls. Test actual face unlock
  only with compatible hardware and deliberate enrollment; otherwise report
  that path as unverified, not passed.
- Do not weaken password authentication or auto-enable biometric enrollment
  merely to demonstrate the retained feature. Hardware support remains unknown.
- Prepare console access and a rollback path before switching the test laptop
  from Ly to SDDM. Do not stop the running display manager mid-session as a
  routine deployment step or enable competing greeters.
- Verify the installed SDDM theme visually and then exercise actual login into
  the intended desktop session on the test laptop. A greeter preview alone
  does not prove PAM authentication or session startup.
- Preserve Ly configuration for rollback until the SDDM login works. Do not
  assume which Ly service unit or display-manager alias is active.
- Plymouth is separately retained under SY-03; verify its boot-to-SDDM handoff.

**Status:** keep decisions recorded; no lock, login, or authentication code or
machine configuration changed. Runtime verification remains pending.

### SY-02: idle, display power, and suspend

**Decision:** keep the existing idle timers, display-power controls, and
suspend/lid behavior. No new timeout values requested; any comfort tuning can
be considered during testing.

The [upstream idle description](https://andreumassanet.github.io/impasto-docs/shell/lock-and-login/#when-you-leave-it-alone)
provides separate lock, screen-off, and suspend timers; its documented defaults
are all Never. It describes locking before sleep and different lid behavior
when an external monitor is connected. These are not verified runtime results
or established settings on the owner's laptop.

#### Acceptance criteria

- Preserve independently configurable lock, screen-off, and suspend waits;
  do not impose new timeout defaults or overwrite existing saved preferences.
- Verify locking before suspend and locked resume on the test laptop with a
  recovery path available. Exercise lid behavior with and without an external
  monitor where available, recording the actual conditions.
- Verify display wake and manual screen-power controls remain usable after
  shortcut migration. Test idle inhibition during media playback separately
  from ordinary inactivity; documentation alone is not proof.
- Inspect the actual implementation and effective configuration before running
  these scenarios. Report unavailable hardware scenarios as unverified.

**Status:** keep decision documented; no idle/power implementation or live
configuration changed, and no suspend scenario run yet.

### APP-02: editors

**Decision:** no bundled graphical editor. Use Neovim with the LazyVim
distribution, replacing Impasto's custom Neovim configuration. The owner may
want customizations, but none have been specified yet.

The checkout's `packages/pacman.txt` includes Neovim and editor tooling, and
`packages/aur.txt` includes VSCodium. The inherited README describes both a
terminal editor and a graphical editor. These are source observations, not
confirmation of installed applications or owner preferences.

#### Implementation scope and acceptance criteria

- Remove bundled VSCodium installation, setup commands, extensions/settings,
  palette integration, and any editor-specific entry points made obsolete.
  Do not uninstall or delete an independently installed editor or its user data.
- Keep Neovim and establish LazyVim as the single configuration baseline, not
  a second plugin/configuration stack layered over the inherited setup.
- Consult current official LazyVim installation requirements and conventions
  before selecting versions, dependencies, extras, and installation strategy.
- Review each inherited editor dependency against the selected LazyVim setup;
  preserve shared dependencies used elsewhere, and remove editor-only leftovers.
- Do not assume programming languages, optional extras, plugins, key overrides,
  or theme customizations from the word "customization". Discuss those needs
  separately. Inspect how existing palette pushes interact with the new config.
- Configure default terminal-editor launch paths and any agreed editor shortcut
  to use Neovim in Kitty. Final shortcut assignment remains part of map review.
- Prove first launch/plugin installation and actual file editing in a temporary
  isolated environment, then verify the target-laptop experience. Syntax checks
  alone do not establish that LazyVim initialized or works.
- Preserve existing user editor files through the deployment backup process;
  do not silently replace the development workstation's Neovim configuration.

**Status:** requirements recorded; no editor files or packages changed. LazyVim
installation, customization research, and runtime verification remain pending.

### APP-03: chat and music applications

**Decision:** keep Spotify and Spicetify as is. Replace the Discord/Vesktop
bundle and integration with Telegram. The owner wants matching Eclipse colors
and background, not deeper layout/behavior modifications. Use official Telegram
Desktop with native theming as the implementation starting point; a fork is
not required by the stated customization goal.

The inherited package manifest includes Vesktop, Spotify, and Spicetify. The
owner uses Telegram rather than Discord. Remove Vesktop-specific installation,
configuration, setup, and palette integration during implementation, preserving
shared desktop/media functionality and independently installed user data.

#### Telegram research findings

| Candidate | Relevant capability | Tradeoff for Eclipse |
| --- | --- | --- |
| Official Telegram Desktop | Native custom themes, colors/backgrounds, in-app theme editor | No client fork needed for palette theming; deeper UI changes may exceed theme scope |
| AyuGram Desktop | Documents enhanced appearance, font customization, and additional behavior such as ghost mode/history/anti-recall | Extra behavior and a fork to trust/update; not simply a theming layer |
| 64Gram | Documents interface options such as hiding stories, disabling Premium animation, and showing avatars | Useful for specific UI preferences; not a general CSS/plugin theming framework |

Sources inspected: [official theme documentation](https://core.telegram.org/themes),
its linked [desktop theme editor guide](https://telegra.ph/Create-Theme-Desktop-FAQ),
[AyuGram README](https://github.com/AyuGram/AyuGramDesktop/blob/dev/README.md),
and [64Gram features](https://github.com/TDesktop-x64/tdesktop/blob/dev/features.md).
Arch packages the official client as
[`telegram-desktop` in Extra](https://archlinux.org/packages/extra/x86_64/telegram-desktop/).
AyuGram's README offers an AUR source package and warns that its referenced
AUR binary packages are not officially maintained by the project.

**Client approach:** official Telegram Desktop with native theming, chosen to
meet the confirmed appearance-only requirement without adding a fork. No
font overrides, ghost mode, history/anti-recall behavior, or custom UI layout
are requested. The candidate comparison above is research context, not a
request to ship multiple Telegram clients.

Native theming support does not establish automatic live synchronization with
Eclipse. Research local theme generation/import/reapplication behavior before
promising palette-following automation. Do not use cloud theme publishing or
automated account login as an assumed requirement. Theme file workflows and
their behavior in a running client have not been tested.

#### Acceptance criteria and implementation research

- Spotify and Spicetify retain the existing setup and palette behavior; verify
  playback/media controls and actual theme application after integration changes.
- Replace Vesktop entries with official Telegram Desktop and verify launch,
  notifications, links, and theme application on the target desktop.
- Telegram colors should match Eclipse's selected palette, and its chat
  background should match the selected desktop wallpaper, with readable text.
  Investigate supported wallpaper formats and how local themes are applied;
  establish actual update behavior before promising automatic synchronization.
- Keep the native client layout/behavior; no additional mods are requested.
- Do not install, authenticate, or modify a live messaging account during review.

**Status:** appearance scope confirmed and official-client approach recorded.
Theme generation/application research and runtime checks remain pending;
no application packages, account data, or runtime configuration changed.

### SH-05: screenshots, recording, OCR, and color picker

**Decision:** keep all reviewed capture capabilities: screenshots and annotation,
screen recording, OCR/text extraction, and the color picker.

No replacement tools or new defaults are selected. Preserve the existing
implementation unless research or testing gives a concrete reason to change it.
Final shortcuts belong to the Eclipse map review, not inherited assignments.

#### Acceptance criteria

- Capture a real screenshot and annotate/save it; open the saved image to verify
  the intended content and annotation.
- Record and stop a short screen capture, then play the saved output to verify
  video and any selected audio source. Cancellation must not start a recording.
- Extract known visible text through OCR and check the actual clipboard result.
  Additional OCR languages have not been selected.
- Pick a known on-screen color and check the resulting value in the clipboard.
- Verify retained capture entry points after dock/widget removal and shortcut
  remapping. Use deliberate, non-sensitive sample content in capture tests.

**Status:** keep decision documented; no capture implementation changed and
no capture scenario exercised yet.

### SH-06: virtual machines and development servers

**Decision:** keep both the virtual-machines panel and the development-servers
panel, preserving their existing capabilities. Final shortcuts follow the
Eclipse map review.

The [upstream machines documentation](https://andreumassanet.github.io/impasto-docs/shell/machines/)
describes a quickemu-backed island panel for downloading and managing VMs.
The [servers documentation](https://andreumassanet.github.io/impasto-docs/shell/servers/)
describes listing local development-server ports with open/copy/stop actions.
These are documented capabilities, not runtime observations.

#### Acceptance criteria

- Both panels remain reachable in the island after removal of dock, widgets,
  games, and pets, including retained menu/launcher entry points.
- On a disposable test VM, verify creation/start, opening its window, and
  shutdown with the retained backend. Exercise other retained VM operations
  against disposable data before claiming full management verification.
- Start a temporary local project server and verify its port appears, the
  browser action opens its page, copy yields the right address, and Stop ends
  that server without affecting unrelated processes.
- Preserve existing VM images/configuration and unrelated development servers;
  testing must not download or destroy user VMs without agreement.

**Status:** both keep decisions documented; no integration code changed and
neither runtime path exercised yet.

### SH-07: screen time

**Decision:** keep application-usage tracking, its island summaries, and the
optional bar module. Desktop widget views remain removed.

The [upstream screen-time documentation](https://andreumassanet.github.io/impasto-docs/shell/screen-time/)
describes local application-usage tracking with day/week/month views, a bar
module, and an island panel. It says tracking stores window classes rather
than titles and pauses while locked. These are upstream descriptions, not a
verified privacy/runtime audit. Desktop widget views remain removed regardless
of this feature's decision.

#### Acceptance criteria

- Verify that usage in a known application appears in the retained summary
  and persists across a shell restart without altering existing history.
- Exercise a lock/unlock interval and inspect recorded behavior against the
  existing tracking policy. Check the actual storage fields before claiming
  window titles are excluded or data stays local.
- Preserve island/bar entry points while removing screen-time desktop widgets
  and widget-specific configuration. Final shortcuts follow Eclipse's map.

**Status:** keep decision documented; no tracking code or stored history changed.
Runtime and privacy properties have not yet been verified.

### SH-08: webcam effects and virtual camera

**Decision:** keep the webcam-effects and virtual-camera feature as a whole,
including preview, effects, gesture reactions, and snapshots.

The [upstream camera documentation](https://andreumassanet.github.io/impasto-docs/shell/camera/)
describes an island webcam preview, a virtual-camera output for calling apps,
background blur, face-following and decorative effects, gesture reactions, and
a snapshot action. This is separate from face-unlock authentication, already
retained. These are documented capabilities, not measured hardware behavior.

#### Acceptance criteria

- With supported test-laptop hardware, verify preview, selected effects,
  gesture reactions, and a saved snapshot against real camera input.
- Select the virtual camera from a calling application and verify that the
  output matches the chosen effect. Check stopping/releasing the camera and
  the retained privacy indicators; do not infer device inactivity from a
  closed panel alone.
- Preserve ordinary webcam access and the separately retained face-unlock
  path. Shared camera dependencies must not be removed during other cutovers.
- Use deliberate test scenes and do not capture or publish personal images
  without the owner's agreement. Mark hardware-dependent checks unavailable
  when no test device is accessible.

**Status:** keep decision documented; no camera code/configuration changed and
no hardware scenario exercised yet.

### SH-09: package-management panel

**Decision:** keep the package-management panel and its existing capabilities.

The [upstream packages documentation](https://andreumassanet.github.io/impasto-docs/shell/keys-and-packages/#the-packages)
describes repository/AUR search, installed-package browsing, and updates.
Install/remove/full-upgrade actions open a terminal rather than running a
transaction inside the island. These are documented capabilities, not tested
package-manager behavior on the target.

#### Acceptance criteria

- Preserve repository/AUR search, installed-package browsing, update listing,
  and terminal handoff for install/remove/full-upgrade actions.
- Verify search and installed/update views against the target environment.
  Exercise package transactions only on the disposable test target with a
  deliberately selected package; do not change the development workstation
  merely to verify this panel.
- Verify cancellation and failed transactions report their outcome without
  falsely claiming success. Preserve full-upgrade semantics rather than adding
  unsupported partial system upgrades.
- Keep retained island/menu entry points and assign final shortcuts through
  Eclipse's map review.

**Status:** keep decision documented; no package transaction or panel code
change performed. Eclipse installation/update strategy remains a separate review.

### APP-04: interactive shell and prompt

**Decision:** replace Zsh and Oh My Zsh with Bash plus ble.sh. Kitty remains
the terminal application. Use Starship with the official Nerd Font Symbols
preset as the starting prompt, with possible small tweaks later.

The inherited Zsh startup used Oh My Zsh, autosuggestions, syntax highlighting,
Starship, and the helpers below. Eclipse now ships Bash startup instead; the
development workstation's installed shell and files are not changed.

#### Migration requirements

- Use Bash for the interactive terminal workflow, with ble.sh providing line
  editing, syntax highlighting, completion, and suggestions. See the
  [ble.sh upstream documentation](https://github.com/akinomyoga/ble.sh).
- Remove Zsh from Eclipse's package manifests and CI dependencies, along with
  Oh My Zsh bootstrap, plugins, configuration, completions, and obsolete checks
  and integrations. Migrate retained helpers to Bash instead of keeping Zsh as
  a hidden dependency. Do not blindly source `.zshrc` from Bash.
- Do not automatically purge an existing Zsh package, erase user startup files,
  or remove a shell while an account still uses it. Test-laptop account-shell
  migration must establish Bash first and check remaining dependencies before
  any package removal. No live workstation changes during this review.
- Audit login/interactive startup, aliases, completions, launcher terminal
  commands, setup checks, and documentation for the migration. Keep scripts
  using other interpreters only where a retained feature actually requires them.
- Review ble.sh initialization order and integration with any chosen prompt,
  fzf, and other helpers before implementation. No helper selection or ble.sh
  version/install method is implied by the shell choice.
- Verify an actual interactive Kitty/Bash session: editing, suggestions,
  completion, history, command execution, and clean startup. Noninteractive
  Bash scripts must not emit prompt UI or initialize interactive line editing.
- Do not change this workstation's login shell or overwrite its startup files
  during development. Apply and verify the intended shell on the test laptop.

**Prompt decision:** Starship with the
[Nerd Font Symbols preset](https://starship.rs/presets/nerd-font). The official
preset identifier is `nerd-font-symbols`. It changes module symbols; it does
not by itself define a new overall prompt layout or enable every module.
Use it as the baseline rather than the earlier suggested minimal custom prompt.

Install and enable a suitable Nerd Font in Kitty so glyphs render correctly;
the preset's example font is not a mandatory font selection. Integrate the
generated configuration in the repository rather than overwriting the live
`~/.config/starship.toml` during development. Verify real prompt rendering,
Bash/ble.sh integration, and palette compatibility. Specific later tweaks,
including format and module selection, remain undecided.

**Status:** repository cutover implemented; runtime verification remains pending.
`home/.bashrc` returns immediately for noninteractive shells, loads
`/usr/share/blesh/ble.sh --attach=none` first, initializes Bash completion and
retained helpers, then Starship, sources `~/.bashrc.local`, and calls
`ble-attach` last. Login Bash sources `.bashrc` through `.bash_profile`; Kitty
explicitly launches Bash irrespective of the account's current login shell.
`blesh-git` is the upstream-maintained AUR package, chosen for the 0.4/contrib
integrations rather than the older stable 0.3 release. Its installation and
updates use the existing AUR-helper package path, not a second clone/bootstrap.
See the [upstream two-phase startup instructions](https://github.com/akinomyoga/ble.sh#13-set-up-bashrc).

The vendored `starship.toml` is the official
[`nerd-font-symbols` preset](https://github.com/starship/starship/blob/master/docs/public/presets/toml/nerd-font-symbols.toml),
without additional module/layout overrides. The existing JetBrains Mono Nerd
Font package and Kitty font selection are retained. `./setup check` and CI now
check Bash startup/completions instead of requiring Zsh. No installer step runs
`chsh`, purges packages, removes Oh My Zsh from an existing home, or erases the
retired `.zshrc`: sync stops managing that startup file but leaves it in place.

On the test laptop, establish the Bash session and retained helpers first, then
inspect `getent passwd "$USER"`, `/etc/shells`, other accounts and Zsh package
reverse dependencies before an explicitly approved account-shell change or
package removal. Existing login startup customizations and `.zshrc.local`
must be translated manually into Bash syntax in `.bashrc.local`; never source
Zsh files from Bash. Development does not perform this deployment/migration.

### APP-05: terminal helpers

**Decision:** keep fzf, zoxide, Yazi, and fnm.

- Integrate fzf and zoxide with Bash/ble.sh rather than retaining their Zsh
  initialization. Preserve fuzzy selection and `z` directory navigation.
- Keep Yazi alongside Strata: Yazi is the terminal file manager, while Strata
  is the selected graphical file manager. Migrate the `y` helper so exiting
  Yazi can change the calling Bash session's working directory.
- Keep fnm and Node.js version switching, including directory-change integration
  where supported by the chosen Bash setup.
- Verify these interactions in a real interactive Bash session, checking that
  fzf keybindings, ble.sh editing, and Starship do not overwrite each other's
  hooks or produce duplicate prompts. Exercise Yazi directory handoff and fnm
  switching with temporary directories/projects.

**Status:** repository integrations migrated; runtime verification pending.
fzf uses [ble.sh's contrib integrations](https://github.com/akinomyoga/blesh-contrib/blob/master/integration/fzf.md)
after Bash completion, not competing Readline bindings. Without ble.sh, a
guarded `fzf --bash` initialization remains usable. zoxide uses `init bash`;
fnm uses `env --use-on-cd --shell bash`. `y` preserves cwd handoff via a
temporary file (including spaces) and cleans it after Yazi exits. EDITOR/VISUAL
still select Neovim or Vim, and machine-local overrides live in `.bashrc.local`.
The `impasto` dynamic CLI completion now uses Bash's completion framework.

#### Test-laptop smoke recipe (not run during implementation)

1. After an explicitly scoped deployment to the laptop, open a new Kitty and
   a login `bash -l`. Check `printf '%s / %s\n' "$BASH_VERSION" "$BLE_VERSION"`,
   one clean Starship prompt, readable Nerd Font glyphs, and no greeting/tool
   errors. Confirm noninteractive `bash -c 'printf "script only\n"'` and
   `bash -lc 'printf "login script only\n"'` emit only their requested output.
2. Exercise line editing, syntax highlighting, a history suggestion, Tab
   completion, Ctrl-R/Ctrl-T/Alt-C fzf selection and cancellation. Complete an
   `impasto` subcommand and a wallpaper filename. Execute successful/failing
   commands and interrupt one; verify a single prompt with working hooks.
3. In temporary directories, visit a path then use `z`/`zi` to return. Run `y`,
   move to a directory containing spaces and quit; check `pwd`. Repeat with
   ordinary exit/cancel. In two disposable fnm projects using already installed
   Node versions, change directories and check `node --version` switches.
4. Add a harmless temporary alias to the laptop's `.bashrc.local`, open a new
   terminal and confirm it is loaded. Check EDITOR/VISUAL and history after
   reopening. Change palette and verify Kitty/Starship remain legible; confirm
   btop, Yazi and cava still receive theme updates. Do not use workstation live
   configuration or package installation as a substitute for laptop results.

### APP-06: terminal greetings and decorative tools

**Decision:** remove the reviewed terminal greeting and decorative tools; the
owner does not need them.

The inherited `.zshrc` offered a Fastfetch greeting helper (`fa`) with animated
scenes and Matrix rain, bonsai, clock, and lava-lamp aliases/functions. These
were on-demand tools, not an automatic terminal-start sequence.
Remove the animated Fastfetch greeting/scene generator and `fa` helper, Matrix
rain, bonsai, terminal clock, and lava-lamp tools, including their dedicated
aliases, settings, assets, installer seeding, and package entries. Do not carry
them into Bash as optional extras.

Audit remaining callers before dropping any shared dependency. This decision
does not authorize removing functional tools such as btop, Yazi, fzf, zoxide,
or fnm, nor system-information displays used elsewhere. Retain shared image
processing or theme code needed by wallpaper/palette behavior.

**Acceptance criteria:** a new terminal reaches the Bash/ble.sh/Starship prompt
without a greeting animation or missing-tool errors; removed decorations have
no leftover settings/actions or background work. Preserve normal interactive
startup and the retained helpers. Do not uninstall independently installed
packages or delete user files on the development workstation.

**Status:** repository removal implemented; runtime verification pending.
Removed Fastfetch configuration, the scene generator and preview, appearance
tiles/search/translations, the settings field and shipped profile values,
theme-service processes/stamp watching, palette-render callbacks, installer
seeding, aliases, and dedicated packages (including the terminal aquarium).
Shared palette/image processing, machine information, btop, Yazi and cava are
retained. Existing installed user files/packages and previously generated state
are not destructively purged; the new desktop no longer schedules scene work.
Exercise the APP-05 smoke recipe and confirm Appearance has no greeting controls
and a palette change does not launch a greeting renderer.

### SH-10: saved desktop profiles

**Decision:** keep named desktop profiles and the existing profile-management
capability. Do not simplify Eclipse to a single configuration.

The [upstream settings documentation](https://andreumassanet.github.io/impasto-docs/shell/settings/#profiles)
describes named profiles containing appearance, bar layout, launcher/control
centre settings, and shortcuts, saved as changes are made. Some settings are
machine-wide, while note/task content is independent. This is documentation
research, not verified behavior of the target laptop.

#### Acceptance criteria

- Create and switch between named profiles, preserving distinct appearance,
  bar/control-centre/launcher settings, and configured shortcuts across restart.
- Keep machine-wide settings and note/task content independent according to
  the existing design; switching profiles must not lose user content.
- Remove dock/widget/game/pet fields and entry points from shipped profiles and
  profile summaries. Loading older profiles must not resurrect removed features
  or break retained settings.
- Shipped profile names, the initial Eclipse look, and whether shortcuts should
  vary between the owner's profiles remain separate decisions. Keeping profile
  capability does not require inventing new example setups.

**Status:** keep decision documented; profile implementation unchanged and
runtime create/switch/persistence checks not yet performed.

### WF-02: window layouts

**Decision:** keep Dwindle, Master, and Scrolling. No new default layout selected.

The [upstream window-layout documentation](https://andreumassanet.github.io/impasto-docs/shell/settings/#window-layouts)
describes Dwindle, Master, and Scrolling layouts. The checkout's keybinding
module also distinguishes layout behavior when flipping splits. These are
source/documentation observations, not tested runtime behavior.

#### Acceptance criteria

- All three remain selectable through the retained settings and layout-cycle
  action, with final shortcuts following Eclipse's accepted grammar.
- Exercise each layout with multiple real application windows, checking focus,
  movement, resizing, fullscreen, and switching back to another layout.
- Preserve layout-dependent behavior rather than forcing split commands onto
  layouts that do not support them. Choose any new default during testing.

**Status:** keep decision recorded; no layout implementation or default changed,
and no runtime layout scenarios exercised yet.

### SY-03: boot splash

**Decision (updated after owner testing):** retain Plymouth and boot-splash
functionality, but redesign its visual theme for Eclipse. The owner tested the
current splash and reports that it is heavily Impasto/oil-painting themed;
keeping that presentation is no longer the desired baseline.

The inherited `packages/pacman.txt` includes Plymouth, and the upstream
[installation documentation](https://andreumassanet.github.io/impasto-docs/start/install/)
describes a boot-splash theme and setup that can rebuild the initramfs. This is
the display during system startup, distinct from the retained login/lock screens.

#### Acceptance criteria

- Inspect the target's actual bootloader, initramfs tooling, and existing
  Plymouth configuration before deployment; prepare a recovery path.
- Verify the splash during an actual test-laptop boot and its handoff to the
  selected graphical SDDM login. A theme preview alone is not boot verification.
- Preserve diagnostic access and any existing early-boot authentication prompts;
  check encrypted-root prompting if the test target uses it.
- Replace the painting/palette-board imagery and Impasto wordmark with an
  agreed Eclipse visual identity. Logo, colors, animation, and exact layout
  remain design choices; do not infer them solely from the name Eclipse.
- Preserve progress indication and any password/error/status presentation
  while changing theme assets. Retain upstream attribution in source/license
  notices; user-facing rebranding does not authorize removing legal credit.
- No boot configuration changes or initramfs operations on the development
  workstation during review.

**Status:** the inherited splash was replaced in the checkout by an original
Eclipse conjunction-seal candidate, quiet gradient, progress-led ring alignment
and outlined wordmark. Password, status/message and shutdown presentation remain
implemented; setup selects the `eclipse` theme. See [splash provenance and safe
target-preview instructions](SPLASH.md). The actual Plymouth script module was
rendered with Xvfb in private filesystem/network/PID namespaces: status/message,
masked dummy entry with backspace/return, return-to-normal and shutdown were
exercised, with real captures retained. Final owner approval and actual target
boot/SDDM-handoff verification remain pending. No live host daemon, boot
configuration or initramfs operation was performed.

**Earlier observation:** Ly remained after Impasto installation, and the owner
initially had not seen a splash. Subsequent owner testing confirms the current
splash was seen and needs re-theming. Ly/SDDM and Plymouth remain independent
stages; the initial observation is not an unresolved installation failure.

The checkout's `setup` function `display_manager()` checks for an existing
`/etc/systemd/system/display-manager.service` link and leaves it in place
instead of enabling SDDM. This is consistent with respecting an existing
manager, but the laptop's actual service configuration has not been inspected.
Plymouth setup follows a separate `verb_splash()` path, including checks for
Plymouth, mkinitcpio, and installed theme/drop-in files. The owner-reported
visual test does not establish bootloader details or a new Eclipse theme's
correctness; those checks remain part of implementation verification.

### SY-04: Eclipse installation and updates

**Decision:** adapt the inherited installer, backup, and deployed-file tracking
instead of introducing a second deployment system. Keep Arch package updates,
Eclipse fork deployment, and reviewed upstream imports conceptually distinct.

The inherited installer copies repository files into the home/system, tracks
deployed files and backups, and offers deployment commands. Its update command
pulls Git changes and then installs again. These mechanisms must be adapted to
Eclipse's accepted feature/package changes, not blindly used against the live
development workstation.

Eclipse deployment/update commands must use the owner's fork. Import original
Impasto changes deliberately in development, reviewing conflicts with accepted
removals and customizations; never automatically deploy upstream changes as
though they were an Eclipse release.

#### Acceptance criteria

- Adapt manifests, setup steps, references, and documentation to the agreed
  application choices and removed features.
- Verify fresh deployment and repeat deployment on an isolated/test target,
  including backup behavior and preservation of locally edited files.
- Check migration from the existing Impasto installation, including obsolete
  deployed files and state paths; renaming must not discard backups or user data.
- Verify the update path obtains the intended fork changes and reports failures
  accurately. No unreviewed upstream imports or deployment on this workstation.
- Explain the concrete commands and recovery steps before test-laptop rollout.

**Status:** strategy accepted; implementation and deployment verification pending.

### SH-11: remaining optional data modules

**Decisions:** retain weather; remove Markets; use OMP (Oh My Pi) as the chosen
AI harness with modest customization to be specified; retain GitHub contribution
data and expose it in the dynamic island like notes/tasks instead of a widget.

The [upstream module catalogue](https://andreumassanet.github.io/impasto-docs/shell/bar/#the-module-catalogue)
describes weather and market data from external services, Claude account usage
using local transcripts plus authenticated API requests, Codex usage from local
logs, and a GitHub contribution view associated with desktop widgets. This is
documentation research, not a privacy audit or proof of this checkout's behavior.

#### Weather

Keep the existing weather capability and its retained bar/island views. Verify
location configuration, updates, and unavailable-network behavior during testing.
No new weather provider or default location has been selected.

#### Markets removal

Remove the Markets feature, including bar/detail/catalogue entries, settings,
polling/backend logic, shipped-profile references, and feature-only dependencies.
This is an explicit exception to earlier bar keep-as-is decisions. Preserve
shared networking/chart components still used by retained features. Verify no
market requests continue after removal; do not merely hide the module.

#### OMP harness and AI integration

The owner uses OMP (Oh My Pi), not Claude Code/Codex as the chosen harness.
Research OMP's supported installation, configuration, and data interfaces before
adapting the current AI modules. Do not substitute other similarly named tools
or assume Claude/Codex transcript formats apply to OMP.

The owner explicitly wants both quick access and a usage/status display, plus
system-theme following and Omarchy-inspired system-aware skills.

- **Quick access:** launch OMP in Kitty through the agreed navigation/shortcut
  scheme. Working-directory/session selection behavior remains to be designed.
- **Usage/status:** provide an island integration using supported OMP data.
  Research model/provider, session token/context and cost fields, session
  selection, and update/lifecycle behavior before finalizing the UI. Do not
  invent unavailable metrics or conflate provider account limits with usage.
- **Theme:** OMP's own interface should follow Eclipse's active system palette,
  in both wallpaper-derived and fixed-palette modes. Research supported theme
  generation/application and whether live reload or restart is needed. Do not
  overwrite unrelated OMP configuration to apply a theme.
- **System-aware skills:** ship Eclipse-specific guidance inspired by Omarchy's
  skills, accurately documenting retained features, configuration/source/state
  locations, commands, safe change/deployment workflows, and verification.
  Teach the harness to inspect actual system state rather than assume defaults.
  Adapt the content to Eclipse; do not copy Omarchy paths/commands as though
  installed here or promise that guidance alone grants machine access.
- Check OMP's actual skill/configuration discovery conventions before choosing
  installation paths. Keep repository development instructions separate from
  installed-desktop guidance and distinguish development/test machines.
- Do not read account credentials, query account APIs, change the live OMP
  settings, or make paid requests as part of this review. Research supported
  interfaces and exercise controlled data before any live integration test.
- Remove obsolete Claude/Codex-specific displays and backends once the OMP
  integration replaces them; preserve shared components used elsewhere.

**Verification requirements:** observe OMP launching in Kitty, show real status
data with defined session selection, and check theme changes in both palette
modes. Verify skill discovery and exercise a non-destructive system-inspection
workflow to confirm it refers to the actual Eclipse system. Do not claim that
skills make the assistant infallible or automatically authorize system changes.

#### GitHub contribution island panel

Create a first-class GitHub contribution panel in the island, reachable like
notes and the task board through retained shell navigation. The owner suggested
possibly using Markets' former place; final button/bar placement and shortcuts
remain undecided, not a requirement to repurpose Markets code.

Initial source inspection found `services/GithubService.qml`,
`bar/modules/GithubModule.qml`, and `components/ContributionGrid` usage in the
module. The module is explicitly desktop-only in its comments despite its path.
It already renders yearly total, streak, data age, and a contribution grid;
reuse suitable data/rendering components rather than building a second backend.
The service describes public-profile data and subscription-driven polling.
These paths have been inspected, not runtime-tested; final data fields and
panel layout need design before implementation.

Preserve GitHub username configuration and reusable contribution code during
widget removal; remove obsolete widget faces/placement controls only. Verify
the island panel with a configured public profile, including missing username,
unknown user, and failed fetch behavior, without restoring desktop widgets or
Markets. No private-contribution authentication is requested.

**Status:** weather/Markets/GitHub choices and OMP integration requirements
recorded. Supported OMP data/theme/skill interfaces, final UI, and final GitHub
panel presentation require research/design. No module implementation, account
credentials, or live OMP configuration changed.


### ID-01: Eclipse visual identity references

**Decision:** the owner accepts the mythic-celestial recommendation: an original
astral-instrument emblem with celestial-seal character and restrained alignment
motion, varied fantasy wallpapers/palettes, and a clear functional everyday UI.
They are a gamer and TTRPG game master. Exact artwork, typography, and motion
are still to be designed and visually approved.

Four research directions, with original-source pages and images inspected:

- **A — Celestial / corona:** [Diamonds in the Sky, NASA APOD](https://science.nasa.gov/image-article/apod-2024-april-20-diamonds-in-the-sky/).
  Reference: dark disc, narrow bright edge/corona, occasional diamond-ring flare.
  Possible Eclipse translation: a restrained halo mark and subtle boot reveal,
  not necessarily a photographic background or a space-themed entire desktop.
- **B — Minimal geometry / negative space:** [Warner Records, Pentagram](https://www.pentagram.com/work/warner-records/story).
  Reference: simple circular mark with a cut edge and a strong wordmark.
  Possible translation: an original occlusion/cut-disc symbol, readable in one
  color and at small sizes. Do not reproduce Warner's actual logo.
- **C — Orbital / motion-led:** [EDP, Pentagram](https://www.pentagram.com/work/edp/story).
  Reference: circular spiral geometry developed through motion.
  Possible translation: original arcs that converge during boot; color/geometry
  should adapt to Eclipse rather than copy EDP's spiral or palette.
- **D — Typography-led:** [Nothing Personal, Pentagram](https://www.pentagram.com/work/nothing-personal)
  and [Geist type specimens](https://vercel.com/font).
  Reference: identity carried by distinctive type and disciplined layout rather
  than a pictorial logo. Possible translation: an Eclipse wordmark and minimal
  progress treatment; not a requirement to adopt the references' colors/fonts.

These are inspiration, not licensed implementation assets or final designs.
Do not copy brand marks or assume all imagery hosted by NASA is public domain;
the APOD example is a credited photograph. Choosing a direction still requires
original Eclipse artwork and an applicable asset/font license review.

#### Owner-supplied reference set

- https://i.redd.it/ebw1520zex5d1.jpeg
- https://i.redd.it/2xq9a54hzkv81.png
- https://wallhaven.cc/w/1jglz3
- https://wallhaven.cc/w/3kzqy3
- https://wallhaven.cc/w/ne3zjw
- https://wallhaven.cc/w/6o1zp7
- https://wallhaven.cc/w/3zj9wy
- https://wallhaven.cc/w/dp3733
- https://i.ebayimg.com/images/g/kcMAAOSwjlNjNjk4/s-l1200.jpg
- https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnCu_3mmeznil9k0wnKf5F3bmr43qkd9K7laFWNgNcU_aPxCDxNhvpFnju&s=10
- https://c8.alamy.com/comp/KW7KEK/decorative-vector-black-sun-symbol-with-long-rays-KW7KEK.jpg

The Wallhaven pages identify Dark Souls/Elden Ring references; the inspected
images include an ember-lit knight under an eclipse, an isolated weathered
crown, an enormous blue moon, a burning sky over fantasy architecture, and
an interlocking fiery sigil. These establish reference material, not a request
to copy a game's logo or make all desktop UI imitate its HUD.

**Accepted interpretation:** mythic celestial imagery rather than scientific
astronomy or corporate orbit graphics. Use a recognizable original emblem;
motion should suggest conjunction/alignment rather than an endless spinner.
Keep the identity stable while fantasy scenery and extracted palettes vary.
Keep ornament at branding moments rather than reducing everyday UI readability.
An astral instrument combined with an eclipsed-sun seal is the starting design
direction, not permission to reproduce a game sigil.

Wallpaper variety does not imply automatic timed rotation or random boot art;
those behaviors have not been requested. Publicly accessible reference images
are not automatically redistributable under Eclipse's GPL license. Review
individual artwork rights before bundling; original branding remains preferable.

#### Original artwork workflow

The owner can generate artwork with image models from prompts supplied during
design. Use generation for scene/background exploration; prefer deterministic
vector construction for the final small emblem and wordmark. Do not make
runtime boot rendering depend on generating images or contacting a model.

Recommended first wallpaper studies (not selected final artwork):

- **Lunar sanctuary:** immense silver-blue moon above a quiet ruined
  observatory, dark water, sparse astral architecture, mist, restrained violet
  light; cool and contemplative rather than a recreation of an existing game.
- **Ember conjunction:** eclipsed sun above a distant ruined citadel, narrow
  amber corona, charcoal sky, ash and weathered stone; warm and ominous without
  recognizable game characters, emblems, or locations.
- **Astral reliquary:** an original weathered brass celestial instrument in an
  abandoned sanctuary, incomplete intersecting rings surrounding a dark centre,
  restrained gold/violet illumination; artifact-like rather than futuristic.

For wallpaper prompts, request wide landscape composition, substantial quiet
space, no lettering/logos/interface, and no copied franchise marks. Keep any
Eclipse emblem/text as separate overlays rather than baked into every scene.
Generate at a supported wide aspect ratio, then crop/export after confirming
the test laptop's screen size; do not claim native resolution from prompt text.

Review generated outputs for artifacts, accidental recognizable copying,
readability/cropping, and extraction of a usable palette. Retain provenance
(model/version, prompt, date, source references, and applicable use terms)
before distributing selected files. Generation alone does not guarantee unique
artwork or legally unrestricted redistribution.

**Status (scene artwork deferred by owner):** the owner generated a candidate at
https://chatgpt.com/s/m_6adf17479cbc8191bf092daaaa59bc9d and is unhappy with it.
It is not approved for use. No visual critique of the image has been performed
here; record the owner's judgment without inventing a reason for rejection.
Scene/wallpaper generation remains paused; the rejected image is not bundled.
Original deterministic Eclipse seal/wordmark SVGs and a matching Plymouth theme
are now implemented as a visual-review candidate, not approved final artwork.
The seal combines a dark disc, broken meridians, sparse rays and a northern
index; progress brings surrounding rings into alignment rather than spinning.
Canonical vectors, a static splash composition, provenance and outstanding
runtime acceptance are documented in [SPLASH.md](SPLASH.md). No new generated
wallpaper or desktop-scene replacement is required for this implementation.

### WF-03: universal clipboard shortcuts

**Decision:** adopt Omarchy-style consistent clipboard shortcuts, retaining
clipboard history inside the island. Move the session menu to Super + Escape.

The inherited keybindings use Super + V to open clipboard history and Super + X
for the session menu. Omarchy's installed defaults use Super + C/V/X for
copy/paste/cut and Super + Ctrl + V for history, translating copy/paste for
terminal windows. This is source inspection, not a runtime test of Eclipse.

#### Accepted bindings

| Action | Eclipse binding |
| --- | --- |
| Copy | Super + C |
| Paste | Super + V |
| Cut where applicable | Super + X |
| Clipboard history | Super + Ctrl + V |
| Session menu | Super + Escape |

This familiar clipboard family is an accepted exception to the general
Super-for-window-management grammar. It replaces Super + V for history and
Super + X for the session menu; do not retain those old actions on those keys.

#### Acceptance criteria

- Preserve existing native application shortcuts. Verify copy/paste with actual
  text in graphical apps and Kitty, including Bash/ble.sh and LazyVim contexts.
  Terminal selection copying is not necessarily the same as an editor yank;
  do not promise identical semantics without testing the focused program.
- Design terminal cut behavior explicitly so Super + X does not accidentally
  trigger unrelated shell editing. Do not confuse shell Ctrl + C with copy.
- Super + Ctrl + V opens existing island history; selecting an entry retains
  its established behavior. Do not add unrequested automatic paste behavior.
- Super + Escape opens/closes the session menu; verify normal dismissal without
  executing a power action. Preserve confirmation behavior for destructive
  session actions and retained hardware power-button handling.
- Check effective saved-profile bindings and the complete map for conflicts.

**Status:** bindings accepted and documented; no shortcut configuration changed
or interactive clipboard/session scenario exercised yet.

### WF-04: workspace movement and overview

**Decision:** follow the window when Super + Shift + number moves it to another
workspace. Keep Super + Tab for the island workspace overview, not sequential
workspace cycling. Super + number remains direct workspace switching.

#### Acceptance criteria

- Moving a focused window to another workspace also switches to that workspace
  and leaves the moved window available for continued work.
- Direct switching does not move windows. Verify using at least two workspaces
  and real application windows, with effective profile bindings applied.
- Super + Tab opens the island overview; selection and dismissal retain their
  existing behavior. It must not also cycle workspaces.
- Confirm behavior on the active monitor and in each retained workspace mode;
  record multi-monitor limits when only one screen is available.
- Fine-tune comfort during testing. No additional silent-move shortcut or new
  cycling bindings are requested by this decision.

**Status:** both recommendations accepted; no workspace code/bindings changed
and no runtime movement/overview scenario exercised yet.

### SH-12: control-centre layout and controls

**Decision:** keep the control centre's existing design and arrangement behavior.
Do not redesign it. Earlier explicit feature removals still require cleaning
their entries out of the catalogue, settings, and shipped layouts.

The [upstream control-centre documentation](https://andreumassanet.github.io/impasto-docs/shell/control-centre/)
describes an editable grid of controls, sliders, media/weather/calendar,
notifications, and shortcuts, with a configurable top button row. It includes
entries for removed games, pets, dock, and the Impasto greeting; remove those
as part of their accepted cutovers, without deleting retained shared controls.
These descriptions are not runtime observations of the test laptop.

Retain the layout editor and remaining controls. New GitHub/OMP entry points
must fit the existing interaction model. Fix the reported Edit crash without
removing the editor or replacing the control centre's design.

#### BUG-01: Settings → Control Centre → Panel → Edit crashes

**Owner report:** pressing Edit attempts to open another window and crashes on
the test laptop. Accept this report as observed; do not ask for reproduction
merely to confirm it. The exact crashed process, signal, runtime versions,
installed commit, and logs are not yet available.

**Source findings:** `ControlsSection.qml` enables `ControlsService.edit(true)`
and emits `arranging`. `SettingsPanel.qml` requests the controls panel and
closes Settings. `SettingsWindow.qml` unloads its page on close. `Bar.qml`
loads arrangement controls/catalogue on the existing bar surface. Opening
arrangement mode is intended; neither this call chain nor the report alone
identifies the crash cause.

**Local investigation:** no QML language server is configured. In an isolated
copy, a temporary QML harness opened the real Settings window, navigated to
Control Centre, invoked the real Edit button's clicked handler, and loaded the
real ControlsPanel and ControlsTray in a separate smoke-test window. On local
Quickshell 0.3.2 (Omarchy build), the run exited 0 and reported Settings hidden,
editing true, and both panel/tray loaded. A screenshot confirmed the grid and
catalogue rendered, with offscreen/software-rendering artifacts. This checks
the QML handoff/components, not actual pointer input, the full DynamicIsland,
Hyprland focus/layer surfaces, GPU rendering, or the test laptop's environment.
Earlier harness import errors were harness errors, not evidence of this bug.

**Status:** reported crash resolved. The persistent SettingsWindow now defers
arrangement until Settings has closed/unloaded. Full nested-runtime checks
exercised this handoff, and after target deployment and an owner reboot the
owner physically tried Edit and confirmed it works well, then confirmed the
block save/persistence, Escape and reopening checks. Target editor acceptance
is passed; the original native crash cause is not retrospectively proven.

**Fix acceptance:** actual Edit interaction enters arrangement mode without
crashing; blocks can be edited and saved; Escape exits; reopening Settings and
repeating the handoff works. Verify on the affected runtime and keep the
existing control-centre design. The isolated smoke result is not a passing
regression check for the reported crash.

### DX-04: screen-edge notes and desktop audio spectrum

**Decision:** keep screen-edge note decks and the desktop edge audio spectrum.
This is an explicit exception to removing general desktop widgets, not a
reinstatement of grid-based widgets. The owner finds these two features useful.

Screen-edge note decks are separate from grid widgets: note tabs sit along an
edge and expand on hover. The desktop audio spectrum is another separate
surface. The inherited `settings/WidgetsSection.qml` has independent controls
for whether edge notes and spectrum make way for application windows. These
are source observations, not proof of effective test-laptop settings.

#### Integration scope and acceptance criteria

- Preserve note hover/peek, opening a note in the island, edge selection,
  ordering, note selection, and existing visibility behavior/settings.
- Preserve edge spectrum playback response, appearance controls, edge placement,
  and existing hide/listening behavior. Grid-spectrum placement remains removed.
- Both features currently use shared desktop arrangement infrastructure. Keep
  or adapt only what is needed to add, configure, move, and remove the retained
  edge surfaces; do not delete their only configuration route or silently
  restore the full widget grid/catalogue.
- Preserve saved edge placements and notes across shell restart and profile
  switching according to the retained persistence model. Remove only obsolete
  grid-widget records; do not discard edge records during migration.
- Verify hover/click with real notes, spectrum response during audio playback,
  and fullscreen/window visibility behavior on the test laptop.
- Keeping capabilities does not choose new default edge placements, auto-pin
  every new note, or change the existing visibility preferences.

**Status:** keep decisions recorded after the owner requested preview steps.
No edge-feature or grid-removal implementation has been changed; detailed
runtime preservation checks remain pending. BUG-01 remains queued separately.

### APP-07: Strata folder and file-chooser integration

**Decision:** use Strata both as the graphical file manager and as the handler
for supported application file-selection dialogs through its portal integration.

Opening folders and selecting files inside another application are separate
integrations. Strata documents optional file-chooser portal support, but the
selected browser/applications may use different chooser paths. Inspect actual
portal routing and verify affected applications rather than assuming all
Open/Save dialogs will use Strata. No chooser migration or live portal change
has been performed during review.

#### Acceptance criteria

- Install/configure the supported Strata chooser backend and route FileChooser
  requests to it using the actual target desktop's portal configuration.
- Preserve unrelated portal implementations, particularly screen sharing and
  other Hyprland portal capabilities. Do not globally replace all interfaces
  merely to change file selection.
- Verify real Open/attachment and Save flows from supported applications,
  prioritizing Zen and Telegram: selection, cancellation, multiple selection,
  file-type filtering, and returned paths as applicable.
- Document applications using private/non-portal dialogs instead of claiming
  universal replacement. Do not add ad-hoc patches to force unsupported apps.
- Changes belong in the Eclipse installer/configuration and test deployment;
  do not change this workstation's active portal routing during development.

**Status:** chooser integration approved; package/configuration discovery and
actual application checks remain pending. No portal services changed.

### WF-05: multiple monitors and workspace sets

**Decision (clarified):** the owner wants independent local 1–10 workspace sets
on each screen after learning how they differ from the current Omarchy setup.
This supersedes matching the current global numbering. No live settings changed.

The [upstream multi-screen documentation](https://andreumassanet.github.io/impasto-docs/shell/screens/)
describes a bar per screen with one active island, plus shared workspaces or
separate sets per screen. In shared mode a number brings the workspace to the
current screen (swapping if shown elsewhere); per-screen mode gives number
shortcuts local meaning. These are documented capabilities, not verified
runtime behavior of the target laptop.

#### Observed Omarchy baseline

Read-only inspection of current config and `hyprctl -j monitors`, `workspaces`,
and `workspacerules` shows two active displays: HP Z27i on HDMI-A-1 and the
HKC laptop panel on eDP-1. Workspace 1 is assigned to the HP display and
workspace 2 to the laptop panel. Workspace 3 currently resides on the HP display;
rules for 3 and 5 have no monitor assignment. This is not evidence that all ten
workspaces have a fixed screen assignment.

The loaded Omarchy default binding source targets globally numbered workspaces
1–10, without Impasto's local per-screen index offset. Thus the current setup
is not the documented Impasto per-screen mode where Super + 2 on a second
monitor targets a distinct workspace (for example, internal workspace 12).
The owner has now explicitly chosen independent local-numbered sets rather
than the observed current Omarchy numbering.

#### Desired behavior

- Super + number selects that local workspace on the focused monitor; the
  other monitor keeps its own active workspace. Use 0 for local workspace 10.
- Super + Shift + number moves a window within the focused screen's set and
  follows it, preserving the accepted move-and-follow behavior.
- Keep Super + Tab for the island overview. Reuse the existing per-screen mode
  rather than adding a second numbering implementation if it meets requirements.
- Do not hardcode the current workstation's monitor identities into defaults.
  Verify persistence, unplug/replug behavior, and monitor ordering on the target.

**Accepted monitor-focus bindings:** Super + Alt + Left/Right/Up/Down focuses
the monitor in that direction without moving windows or changing either
screen's active workspace. The checkout has Left/Right; add Up/Down during
implementation. Super + arrows remains window focus and Super + Shift + arrows
remains window movement.

**Accepted initial single-window transfer:** Super + Alt + Shift + arrow sends
only the focused
window to the destination monitor's currently active workspace and follows it.
Do not switch the destination to the source's local workspace number. Other
windows stay put; this is not moving/swapping an entire workspace. If there
is no monitor in that direction, leave the window/focus unchanged.

The inherited Left/Right chords currently call `trade_workspace()`, which
trades workspaces or their contents depending on mode. Implementing this
behavior therefore requires removing that conflicting action, not adding
a second action on the same keys. No separate workspace-trade shortcut is
requested.

**Comfort concern:** the owner accepts the behavior and chord for now because
the structure makes sense, but does not like the chord. Specifically revisit
its physical comfort and practical use during testing; do not describe it as
a settled ergonomic preference or change it without recording the new choice.

**Status:** independent sets, four-direction monitor focus, and single-window
transfer accepted as the initial design. No bindings applied or runtime
movement scenarios exercised.

### SY-05: keyboard languages and input method

**Decision (revised):** retain configurable layout switching with Caps Lock
(default), Alt + Shift, and None. Remove Super + Space as a language-switching
option; reserve that chord for the launcher. This supersedes retaining all four.

Read-only inspection of this workstation found an English/Persian toggle
configured in `~/.config/hypr/bindings.lua`: Alt + Shift combinations invoke
`fcitx5-remote -t`. The local input config keeps Hyprland's base layout as US
and uses Caps Lock as Compose. These are source observations, not proof of
the effective input-method state or a request to copy every setting.

#### Source evidence and implementation scope

`CompositorService.qml` uses the existing compositor XKB mechanism; the
workstation's Fcitx5 setup is not a request for a second independent layout
controller. `InputSection.qml` exposes Caps Lock, Alt + Shift, and None, and
disables the switch picker with only one layout.

- Set the fresh-configuration default to Caps Lock and expose only Caps Lock,
  Alt + Shift, and None. Audit initial setup/imported options and shipped values;
  preserve explicitly saved supported choices rather than resetting at startup.
- Caps Lock is repurposed for language switching in that mode; do not also
  configure it as Compose or conventional Caps Lock. No alternative Compose
  shortcut is selected by this decision.
- Start with English (US) first and the owner's current Persian layout second.
  Inspection of `~/.config/fcitx5/profile` identifies `keyboard-ir-winkeys`,
  corresponding to XKB layout `ir`, variant `winkeys`, named Persian (Windows)
  in `/usr/share/X11/xkb/symbols/ir`. Do not substitute generic/default Persian.
- Preserve editable layout selection, ordering, and exact variants. The shipped
  mapping is layouts `us,ir` and variants `,winkeys`: the leading empty variant
  belongs to US. `LayoutPicker.qml` adds exact layout/variant entries from the
  installed XKB rules and moves/removes those pairs together; its arrow controls
  reorder the entries without dropping the Persian variant.
- Match actual key output, not just a Persian label. Check top-row digits,
  shifted punctuation, Persian yeh/keheh, and zero-width non-joiner entry against
  the current working layout. Do not import Fcitx5's whole configuration or the
  current Caps-as-Compose option merely to preserve this key arrangement.
- Remove `grp:win_space_toggle` from the selectable options and shipped
  configuration. Handle existing saved/imported selections explicitly during
  migration so the removed option cannot keep intercepting the launcher chord;
  preserve unrelated keyboard options. Explain the switch to the supported
  Caps Lock default for that obsolete selection. No alternate launcher binding
  or shortcut-conflict dialog is needed for this removed choice.
- Verify switching and ordinary typing in Kitty/Bash/ble.sh, LazyVim, Zen,
  Telegram, and retained shell fields; test shortcut behavior in each layout.
- Verify Caps Lock default, each alternative, None, and restart persistence
  with at least two layouts. None disables the switching chord, not the layouts.
- Check the monitor-transfer chord does not cause a stray language switch when
  Alt + Shift is selected. Keep authentication input usable and verify its
  layout state rather than assuming desktop settings apply before login.
- Do not change this workstation's input or install a second input method
  during review.

**Implementation status:** repository defaults and settings migration implemented;
no live input reload, input-method installation, or runtime typing verification.
`hypr/modules/input.lua` and fresh settings use US, Persian (Windows), and Caps
Lock. The shell no longer imports `/etc/X11/xorg.conf.d/00-keyboard.conf` over
those defaults; console and login-screen keyboard configuration remains separate.
Saved machine choices win over legacy compositor values. Legacy keyboard options
move out of profile compositor settings, and imported profiles cannot override
the machine keyboard. Removed Super + Space switching migrates to Caps Lock
unless a supported switch was also saved. Unrelated XKB options survive;
Caps-specific Compose/remapping options are removed only when Caps switching is
active, because those options compete for the same physical key.

**Isolated verification (development machine, 2026-10-28):** compiled the real
`us,ir` / `,winkeys` keymap through `libxkbcommon.so.0` using its C API from
Python `ctypes`, without connecting to or modifying the live compositor.
Assertions passed for ASCII digits, shifted digit punctuation, U+06CC yeh,
U+06A9 keheh, U+06F2 via Right Alt + 2, U+200C via Shift + Right Alt + 2,
U+061F, Caps cycling US → Persian → US, Alt + Shift switching, and None keeping
the starting group when Caps is pressed.

An offscreen Quickshell harness used unchanged `SettingsService.qml` and
`LayoutPicker.qml` copies, temporary HOME/XDG state, passive visual components,
and the exact compositor keyboard helper functions with installed XKB metadata.
It passed fresh defaults; legacy Super + Space migration preserving Compose/
LED options; saved Caps, Alt + Shift, and None; saved variant precedence;
legacy layouts with no variant; imported profile keyboard stripping; Caps
conflict cleanup; variant search/add/remove/reorder; and actual settings-file
write/restart persistence for all three choices. These are component/keymap
checks, not proof of app typing, visual usability, compositor reload, monitor
transfer, or authentication behavior on the target laptop.

#### Target-laptop smoke recipe (not yet run)

1. On the dedicated laptop, inspect `hyprctl getoption input:kb_layout -j`,
   `hyprctl getoption input:kb_variant -j`, and
   `hyprctl getoption input:kb_options -j`. A fresh configuration must report
   `us,ir`, `,winkeys`, and `grp:caps_toggle`. Do not run deployment or reload
   commands on the development workstation to perform this check.
2. In Settings → Keyboard, search `winkeys` or `Persian (Windows)`. Remove/add
   that exact variant, move it before US and back, and confirm the variant list
   changes to `winkeys,` and back to `,winkeys`. Add a third layout and remove it;
   confirm Persian remains `winkeys` after each change and shell restart.
3. Select Persian using Caps Lock, then type by physical US key positions.
   Source evidence from `/usr/share/X11/xkb/symbols/ir`, `xkb_symbols "winkeys"`:
   unshifted number-row `1234567890` produces ASCII digits, **not** Persian
   digits; shifted `1234567890` produces `!@#$%^&*)(` (the final parentheses
   are reversed relative to US). Shift + comma/period produces `<`/`>`.
   Physical `D` produces Persian yeh `ی` (U+06CC), physical semicolon produces
   Persian keheh `ک` (U+06A9), and Shift + slash produces `؟` (U+061F).
   Right Alt + `2` produces `۲` (U+06F2); Shift + Right Alt + `2` produces
   ZWNJ (U+200C). Do not substitute generic Persian's Shift + B or Compose.
   A Wayland event viewer such as `wev` can show these keysyms/code points;
   compare committed text too, since key events alone do not prove app input.
4. Repeat that typing sample in Kitty/Bash/ble.sh, LazyVim insert mode, Zen,
   Telegram, and retained shell text fields; compare to the working
   `keyboard-ir-winkeys` baseline. For an invisible-character check, type a
   sample into a terminal command such as
   `python3 -c 's=input(); print(" ".join(f"U+{ord(c):04X}" for c in s))'`.
   Enter physical `D`, Shift + Right Alt + `2`, physical semicolon; the result
   must be `U+06CC U+200C U+06A9`.
5. Exercise Caps Lock, Alt + Shift, and None with two layouts and after restart.
   None must leave both layouts loaded without a switching chord. Super + Space
   must open the launcher without switching language. With Alt + Shift selected,
   test monitor transfer without stray language changes, plus application
   shortcuts in both layouts and lock/login-screen input independently.
6. In an isolated copy of shell settings on the test laptop, seed
   `grp:win_space_toggle,compose:ralt,grp_led:scroll`, then start the shell:
   the saved result must use `grp:caps_toggle` and retain the other two options.
   Repeat with saved Alt + Shift and None to ensure neither resets to Caps.
   Do not edit or exercise migration against this workstation's live settings.

### SY-06: pointer and cursor

**Decision:** keep pointer sensitivity, cursor size, palette/fixed color
selection, and Shake to find, including its required plugin support.

The checked-out `settings/InputSection.qml` offers pointer sensitivity, cursor
color (palette-following or fixed), cursor size, and Shake to find. The last
feature briefly enlarges the pointer and currently requires
`hypr-dynamic-cursors`; the settings toggle is disabled when unavailable.
These are source observations, not runtime verification.

#### Acceptance criteria

- Preserve editable size/color/sensitivity controls and persistence. Verify
  palette-following color under both derived and fixed palettes.
- Verify Shake to find visibly enlarges and restores the pointer across the
  test displays without leaving an incorrect size or pointer state.
- Preserve clear availability reporting when the plugin is absent; test
  compatibility with the chosen Hyprland build before deployment.
- Retention does not require replacing the current plugin or changing tuning.
  Any backend change needs evidence and functional/visual verification.

**Status:** all reviewed pointer capabilities retained; no cursor code,
dependencies, or live input settings changed.

### AP-04: reduced-effects game mode

**Decision:** keep the reversible reduced-effects Game mode, separate from
removal of the island arcade. No automatic game detection requested.

The checked-out `AppearanceSection.qml` offers a Game mode toggle described as
stopping animations/visualizers and disabling compositor blur, shadows, and
glass while preserving settings for restoration. These are source descriptions,
not measured performance or a verified per-game optimization.

#### Acceptance criteria

- Verify enabling the mode suppresses the intended retained effects/visualizers
  and disabling it restores the prior user choices, not hardcoded defaults.
- Exercise profile switching and shell restart against the existing persistence
  model so reduced-effects state does not silently destroy appearance settings.
- Preserve the mode's retained controls; remove references to deleted dock,
  grid widgets, pets, and arcade without deleting Game mode itself.
- Do not promise higher frame rates or lower latency without measurements on
  the target. No new tuning values, daemon, or automatic activation selected.

**Status:** keep decision recorded; no mode code or runtime settings changed.

### SH-13: online lyrics lookup

**Decision:** keep lyrics lookup and its existing behavior/default. The checkout
sets `lyrics: true`; retain the user-facing switch for disabling lookups.

The checked-out `settings/ModulesSection.qml` describes fetching lyrics from
lrclib.net using track title and artist, with a Look them up toggle. Retained
surfaces include island media/glance and optionally the lock screen; desktop
lyrics widgets remain removed. This is source evidence, not an audited traffic
trace or verified application behavior.

#### Acceptance criteria

- Preserve lyrics in retained island/media and configured lock-screen views;
  remove only the desktop widget presentation.
- Verify a known track displays its available lyrics and a missing result
  leaves the ordinary media controls usable.
- Verify disabling lookup prevents new requests containing track metadata.
  Preserve the existing service rather than adding providers or extra requests.

**Status:** keep decision recorded; no lyrics code/defaults changed or network
lookup tests exercised.

### AP-05: everyday interface and terminal fonts

**Decision:** keep Inter, JetBrainsMono Nerd Font Mono, and the notes-handwriting
option with the existing defaults. This does not select final logo lettering.

The checkout defaults to Inter for the interface and JetBrainsMono Nerd Font
Mono for monospace text. Note bodies can use a bundled handwriting font or
the interface font. Starship's Nerd Font Symbols preset is already accepted,
so the selected terminal font must support the required glyphs.

#### Acceptance criteria

- Preserve font-selection controls and the notes-handwriting toggle.
- Check Persian-script coverage/fallback and shaping in retained applications,
  including mixed-direction text, punctuation, and note editing. No particular
  Persian fallback family is selected yet; research one if needed for readable
  output rather than assume Inter or the monospace font covers every script.
- Verify Starship's selected Nerd Font symbols render in Kitty without missing
  glyphs. Preserve legibility when changing scale or palette.

**Status:** font choices accepted; no font packages or live settings changed.

### SH-14: clipboard history storage preferences

**Decision:** keep the current storage defaults: history enabled, up to 200
entries, images included, and history retained across screen lock. Preserve
the existing controls for changing these preferences.

The checkout's SettingsService defaults to keeping history enabled, up to
200 entries, including images, and not emptying history on lock. The retained
Launcher settings allow changing these preferences. These are source defaults,
not observations of the owner's saved settings or a security audit.

#### Acceptance criteria

- Use non-sensitive sample text/images to verify capture, the configured entry
  limit, image selection, persistence, and retention across lock/unlock.
- Verify disabling history stops new capture and that the configurable
  clear-on-lock behavior still works when selected, despite remaining off by
  default. Do not infer protection for all secrets from a password-manager
  exclusion claim; inspect/test the actual exclusion mechanism.
- Do not read the owner's actual clipboard content during review or change
  this workstation's clipboard manager to exercise Eclipse.

**Status:** defaults retained and documented; no clipboard data inspected,
defaults changed, or runtime privacy tests performed.

### APP-08: standalone image/video viewers and system monitor

**Decision:** keep imv, mpv, and btop.

The inherited `packages/pacman.txt` includes imv for images, mpv for video/audio,
and btop for terminal system monitoring. They are distinct from Strata's own
previews, Spotify, and the island system-statistics panel. The manifest comments
identify Yazi viewer handoffs. These are source observations, not proof of the
owner's preferred application associations.

#### Acceptance criteria

- Open a real sample image in imv and a short sample video/audio file in mpv;
  verify content/playback and retained Yazi handoffs.
- Launch btop in Kitty and verify it displays live process/resource information
  and remains readable under the chosen palette.
- Inspect associations/callers during implementation; do not assume every app
  preview must be replaced or remove shared media dependencies during cutovers.

**Status:** keep choices documented; no application associations or packages
changed, and no viewer/system-monitor runtime scenarios exercised yet.

### AP-06: animated wallpaper capability

**Decision:** keep animated video/GIF wallpaper support alongside still images.

The checked-out `scripts/theme_manager.py` supports video/GIF wallpapers using
mpvpaper, and ffmpeg-extracted stills for palettes and other wallpaper views.
It requests auto-pause behavior from mpvpaper. These are source observations,
not measured power/performance or verified fullscreen behavior.

#### Acceptance criteria

- Apply a non-sensitive sample animated wallpaper and verify playback, switching
  back to a still image, and restoration across the intended session lifecycle.
- Verify poster extraction, palette generation, and retained wallpaper previews
  remain functional. Check behavior on both monitors without assuming identical
  playback or timing from source inspection alone.
- Exercise covered/fullscreen pause and resume behavior and reduced-effects
  Game mode interaction. Record resource observations rather than assuming
  that auto-pause flags guarantee low power use.
- No bundled video asset, animation-by-default setting, automatic wallpaper
  rotation, or generated artwork is selected by this decision.

**Status:** capability retained; no wallpaper implementation or active wallpaper
changed, and no playback/performance checks run yet.

### SH-15: night light

**Decision:** keep the current manual Night light capability and its controls.

The checkout's `bar/island/NightLightDetail.qml` provides a Night light switch,
color-temperature adjustment, and preset warmth choices through SunsetService;
the package manifest includes hyprsunset. These are source observations, not
an established schedule or measured display behavior.

#### Acceptance criteria

- Verify toggle, temperature adjustment, and preset choices on the test laptop,
  including returning to the normal display appearance when disabled.
- Preserve current settings/persistence without introducing an automatic
  schedule, location lookup, or new temperature default.
- Check operation on both displays where supported and interaction with
  retained color/effect settings. Report hardware/runtime limits explicitly.

**Status:** keep decision documented; no hyprsunset configuration or display
state changed, and no runtime color-temperature scenario exercised yet.

### APP-09: OMP project launch and session selection

**Decision:** adopt the discussed Omarchy-style working-directory convention
for OMP. General desktop launches start in `~/Work`; launches from a project
keep the caller's directory. This supersedes the earlier default folder-picker
proposal. The initial explicit session-selector behavior below is accepted,
with detailed interaction to be workshopped later.

#### Launch requirements

- Establish `~/Work` if absent without moving projects or replacing existing
  contents. Keep `~/Projects/eclipse` as the development checkout.
- Preserve non-home caller working directories. When launched from `$HOME`,
  use `~/Work`, matching the inspected Omarchy launcher convention; ensure the
  desktop/menu entry intentionally uses the general-work directory rather than
  inheriting an arbitrary shell/service directory.
- Launch OMP in Kitty with proper path/argument handling, including spaces.
  No mandatory project picker or automatic `~/Work/tries` tooling is requested.
- This convention is not a sandbox and does not grant additional permissions.
  Approval/sandbox flags are not decided by this directory choice; do not copy
  Omarchy's `--auto-approve` invocation merely to reproduce its working directory.
- Verify general launch, explicit project launch, home-directory fallback, and
  a directory containing spaces using observed OMP working-directory behavior.

#### Accepted initial island session selection

- Identify the project/session being displayed, using available project and
  session names rather than implying account-wide aggregate usage.
- Offer explicit selection among running sessions and show one session's data
  at a time. Keep that selection while available; do not automatically follow
  the focused terminal or silently switch to whichever log is newest.
- Clearly indicate an ended/disconnected session instead of substituting
  another session's metrics without a choice.
- The owner accepts this as a starting design and wants to workshop details
  later. Research supported OMP/Kitty interfaces before choosing discovery,
  lifecycle handling, or available metric fields. No new shortcut selected.

**Status:** launch-directory behavior and initial session-selection policy
accepted. Detailed UI and supported interfaces remain implementation research;
no launcher, directories, account settings, or live OMP configuration changed.

### SH-16: GitHub panel starting design

**Decision (expanded):** retain contributions and add browsing of the owner's
repositories and organizations, with lists of their issues and pull requests.
Clicking a repository, organization, issue, or PR opens its corresponding page
in the browser. Avoid overcrowding the island.

#### Accepted scope

- List the owner's repositories and organizations; allow selecting an
  organization and its repositories, then a repository's issues or PRs.
- Open the appropriate GitHub page in the selected browser (Zen), not an
  embedded web view. Creating/editing issues, reviewing/merging PRs, and other
  write operations are not requested.
- Preserve the accepted contribution capability. Keep account/username context
  clear; the graph does not have to remain visible alongside every list.
- Keep the compact island interaction model, with bounded/scrollable lists
  rather than expanding to fit all organizations/repositories/items.

#### Accepted initial navigation

Use a small overview with separate Contributions, Repositories, and
Organizations destinations. A repository has Issues / Pull requests views;
show one list at a time with a back action/breadcrumb. Repository/org rows
select their contents, with an explicit external-link action for opening their
own GitHub pages. Issue/PR rows directly open the browser. This separates
drill-down selection from external navigation rather than assigning two
different actions to the same click.

Use search/filtering and pagination to keep large accounts usable. Start with
open issues/PRs and offer closed/merged status filters. Keep the island bounded
and refine row density during testing; do not show all lists simultaneously.

#### Authentication and data research

**Accepted access scope:** include public and private repositories, including
organization repositories the authenticated account is permitted to access,
and their issues/PRs. Respect organization authorization, SSO, and repository
permissions; this is not a request to bypass access controls.

The public contribution backend alone cannot provide this scope. Research
supported authentication, pagination, rate limits, and organization requirements.
Prefer established credential handling and minimum permissions required for
read-only operations. Verify actual granted scopes: reusing an existing CLI
login does not imply its token is read-only. Do not store tokens in repository,
theme/profile settings, logs, or command-line arguments. Do not read credentials
or query private account data during review.

Private-repository browsing does not request private contribution details or
private issue contents on the lock screen. Keep authenticated data within the
unlocked panel and avoid persisting private item content unless needed and
explicitly designed. The precise authentication/cache strategy is not chosen.

#### Acceptance criteria

- Verify configured account/username, repository/org lists, navigation/back,
  issue/PR classification, status filters, and pagination with controlled data.
  Large lists must remain bounded and not overflow the island.
- Verify clicking representative issue/PR entries opens their exact GitHub URL
  in the browser and external links for repositories/organizations work.
- Distinguish no items, not authenticated/not authorized, rate limiting, and
  offline/fetch failure; do not present inaccessible data as an empty account.
- Verify authorized private and organization repositories are represented and
  permission failures are explicit. Browser authentication is separate from
  panel authentication; opening a private link cannot guarantee access in a
  browser logged into another account.
- Preserve existing island dismissal and keyboard navigation; no desktop widget
  is restored. Control-centre/launcher entry points and bar placement remain
  to be finalized.

**Status:** public/private and authorized organization access, read-only behavior,
compact drill-down navigation, and open-first/status-filter design accepted.
Exact entry-point placement and authentication implementation research remain
pending. No GitHub API/account access, credentials, or code changes performed.

### WF-06: scratchpad

**Decision:** add an Omarchy-inspired application-window scratchpad. This is
separate from the retained notes/task tools, not a request for another editor.

#### Existing reference

The installed Omarchy `default/hypr/bindings/tiling.lua` toggles the named
special workspace `scratchpad` with Super + S and sends the focused window
there without following using Super + Alt + S. Its `looknfeel.lua` sets
`hide_special_on_workspace_change = true`. Source inspected without changing
the current scratchpad, focus, or windows. No separate daemon is evident in
these binding definitions; use existing compositor capability where sufficient.

#### Accepted initial behavior and bindings

- One shared scratchpad, available from either monitor, shown on the monitor
  where it is invoked. Keep independent numbered workspace sets unchanged.
- Super + S shows/hides it. Hiding does not close its application windows.
- Super + Shift + S sends the focused window there without following, matching
  Eclipse's focus-to-move modifier principle rather than copying every Omarchy
  binding. This displaces inherited Capture; Super + S also displaces Notes.
  Preserve both retained tools with deliberate new shortcuts in the complete
  map rather than silently removing them or leaving duplicate actions.
- Use the accepted Super + Shift + number action to retrieve a focused
  scratchpad window into that monitor's local numbered workspace and follow it.
- Hide the overlay when changing normal workspaces, following Omarchy's
  configured behavior. No automatic terminal spawn or separate per-monitor
  scratchpad requested by the user so far.

#### Acceptance criteria

Verify show/hide, multiple scratchpad windows remaining alive while hidden,
send-without-follow, retrieval to the correct monitor-local workspace, focus
restoration, and invocation from both monitors. Check movement with the retained
layouts and that workspace changes hide the scratchpad without losing windows.
Check effective bindings/profile overrides and Capture access before deployment.

**Status:** shared scratchpad behavior, show/send bindings, move-back via local
workspace numbers, and hide-on-workspace-change accepted. No scratchpad code
or live configuration changed; runtime verification pending.

#### Next review checkpoint

Consolidate the accepted keyboard families into one complete proposed map,
including new homes for Notes and Capture and entry points for retained/new
panels. Present unresolved assignments together rather than revisiting accepted
bindings one by one. Before closing feature review, invite any additional
Omarchy workflows the owner specifically wants; do not infer them from general
inspiration or treat the pending bug/artwork as completed.

### SY-07: VPN management and network-panel controls

**Decision:** add a VPN panel in Settings for adding OpenVPN and WireGuard
connections. Put their connect/disconnect controls in the existing island
Wi-Fi/network panel where wireless networks are selected. This is a new feature,
not a claim that Omarchy already provides the requested UI.

**Addition methods confirmed:** support both configuration-file import and
manual setup for both OpenVPN and WireGuard. Neither method substitutes for
the other in implementation or verification.

#### Backend direction

The checkout's `services/NetworkService.qml` reads NetworkManager through
Quickshell.Networking and uses nmcli for some actions. Reuse NetworkManager
profiles as the system's source of truth rather than a competing VPN daemon
or a second Eclipse-specific profile store. WireGuard is a native connection
type, not an ordinary NetworkManager VPN-plugin connection; include both it
and OpenVPN profiles when listing tunnels.

Initial documentation research: the [nmcli manual](https://networkmanager.dev/docs/api/latest/nmcli.html)
documents connection creation/import/activation and credential-agent handling.
OpenVPN import needs the appropriate NetworkManager plugin. NetworkManager's
maintainer [describes native WireGuard import](https://blogs.gnome.org/thaller/2019/03/15/wireguard-in-networkmanager/).
Check current installed APIs/versions and supported import fields before
implementation; this research is not a successful import or tunnel test.

#### UI scope

- Settings lists saved tunnels and offers OpenVPN / WireGuard choices, each
  with Import configuration and Manual setup paths. Import should accept
  supported `.ovpn` and WireGuard `.conf` configurations; explain unsupported
  options instead of silently dropping them.
- Research the appropriate protocol-specific manual fields and authentication
  modes before designing the forms. Keep essential setup clear and advanced
  options separate without excluding required routing/DNS or credential inputs.
- Network detail has a compact VPN section, separate from wireless networks,
  with name/type, actual status, and Connect/Disconnect. It must remain usable
  over Ethernet or with the Wi-Fi radio off if another base link is available.
- Settings provides detailed setup; the island handles everyday activation.
  Avoid crowding the Wi-Fi list with credential/configuration forms.
- No kill switch, provider-specific client, auto-connect policy, or extra VPN
  protocol requested. Do not imply a connected interface proves leak protection
  or a WireGuard peer handshake; show actual available state honestly.

#### Security and verification requirements

- Handle private keys/passwords through supported NetworkManager secret storage
  or agents. Do not put them in Eclipse profiles, logs, process arguments, or
  source control; do not inspect live secrets during review.
- Review imported configuration security and unsupported directives. Never
  execute arbitrary wg-quick hook scripts as a side effect of importing files.
- Preserve the imported routing/DNS intent and distinguish full/split tunnels;
  do not force a new routing policy to make activation appear successful.
- Verify all four creation paths with controlled configurations: OpenVPN import,
  OpenVPN manual setup, WireGuard import, and WireGuard manual setup. For each,
  exercise saved profile listing, authentication where needed, connection,
  effective tunnel traffic/DNS, disconnection, failure/cancellation, persistence,
  and changes made outside the UI. Reaching an active state alone is not proof
  that tunnel traffic works.
- Use disposable endpoints/profiles and arrange recovery before any network
  changes. No test-tunnel deployment or live route/service change on this
  workstation during review; no credentials should be pasted into chat.

**Status:** both import and manual setup for both protocols accepted. Form/API
research, implementation, and real tunnel verification remain pending. No VPN
profiles, credentials, routes, services, or implementation code changed.

## Verification baseline

The CI invokes `./setup check`, which checks Python, Lua, Bash, plain JSON,
and TOML syntax. It does not validate QML or exercise a running desktop.
The original inherited baseline stopped at a missing zsh dependency; zsh has
since been removed from the selected shell/configuration and current check.

Current evidence includes successful syntax/regression/migration checks,
isolated runtime smoke checks, target user-configuration deployment, live
Settings/control-centre/Strata/Telegram inspection, and working Eclipse startup
after an owner reboot. BUG-01's reported crash is closed by the owner's target
confirmation. Complete hardware acceptance, VPN traffic/DNS/authentication,
account-dependent app flows and boot-artwork acceptance remain pending. See
`VERIFICATION.md` for exercised checks and limits.

## References

- [Impasto repository](https://github.com/andreumassanet/impasto)
- [Impasto documentation](https://andreumassanet.github.io/impasto-docs/)
- [Installation scope and flags](https://andreumassanet.github.io/impasto-docs/start/install/)
- [Strata application and integration documentation](https://github.com/lgse/strata)
- [Sine installation and behavior](https://github.com/CosmoCreeper/Sine)
- [Omarchy hotkey reference](https://omarchy.org/manual/hotkeys/)

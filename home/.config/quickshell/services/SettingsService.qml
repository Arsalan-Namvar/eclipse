// ╭──────────────────────────────────────────────────────────────────────────╮
// │                                                                          │
// │   S E T T I N G S   S E R V I C E                                        │
// │   user preferences · defaults here, overrides on disk                    │
// │                                                                          │
// │   github.com/andreumassanet/impasto                                      │
// │                                                                          │
// ╰──────────────────────────────────────────────────────────────────────────╯

pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Every user preference. Defaults are the initialisers in `Store`; changes go
// to $XDG_STATE_HOME/quickshell/settings.json, outside the files `./setup`
// manages. JsonAdapter writes the file back on every change.
Singleton {
    id: root

    readonly property string stateDirectory:
        `${Quickshell.env("XDG_STATE_HOME") || Quickshell.env("HOME") + "/.local/state"}/quickshell`

    // ── ACCESS ──────────────────────────────────────────────────────────────

    readonly property alias clockFormat: config.clockFormat
    readonly property alias clockShowsDate: config.clockShowsDate
    readonly property alias clockShowsSeconds: config.clockShowsSeconds
    readonly property alias barHeight: config.barHeight
    readonly property alias barMargin: config.barMargin
    readonly property alias islandAttached: config.islandAttached
    readonly property alias barSideMargin: config.barSideMargin
    readonly property alias barStyle: config.barStyle
    readonly property alias barEverywhere: config.barEverywhere
    readonly property alias barHidden: config.barHidden
    readonly property alias screenCorners: config.screenCorners
    readonly property alias gameMode: config.gameMode
    readonly property alias barLeft: config.barLeft
    readonly property alias barRight: config.barRight
    readonly property alias islandSummary: config.islandSummary
    readonly property alias lyrics: config.lyrics
    readonly property alias islandActivities: config.islandActivities
    readonly property alias chipShape: config.chipShape
    readonly property alias chipFigure: config.chipFigure
    readonly property alias desktopEdges: config.desktopEdges
    readonly property alias centreButtons: config.centreButtons
    readonly property alias centreTop: config.centreTop
    readonly property alias centreBlocks: config.centreBlocks
    readonly property alias centreColumns: config.centreColumns
    readonly property alias centreRows: config.centreRows
    readonly property alias centreToggles: config.centreToggles
    readonly property alias terminalGround: config.terminalGround
    readonly property alias weatherPlace: config.weatherPlace
    readonly property alias githubUser: config.githubUser
    readonly property alias launcherResults: config.launcherResults
    readonly property alias launcherOrder: config.launcherOrder
    readonly property alias launcherFits: config.launcherFits
    readonly property alias emojiTone: config.emojiTone
    readonly property alias cameraEnabled: config.cameraEnabled
    readonly property alias cameraEffect: config.cameraEffect
    readonly property alias cameraReactions: config.cameraReactions
    readonly property alias clipboardHistory: config.clipboardHistory
    readonly property alias clipboardKeep: config.clipboardKeep
    readonly property alias clipboardImages: config.clipboardImages
    readonly property alias clipboardWipeOnLock: config.clipboardWipeOnLock
    readonly property alias lockBlur: config.lockBlur
    readonly property alias lockClock: config.lockClock
    readonly property alias lockMusic: config.lockMusic
    readonly property alias lockMusicGround: config.lockMusicGround
    readonly property alias userName: config.userName
    readonly property alias userAvatar: config.userAvatar
    readonly property alias doNotDisturb: config.doNotDisturb
    readonly property alias recorderAudio: config.recorderAudio
    readonly property alias captureShape: config.captureShape
    readonly property alias captureKind: config.captureKind
    readonly property alias notesHandwriting: config.notesHandwriting
    readonly property alias deckOnEmpty: config.deckOnEmpty
    readonly property alias spectrumOnEmpty: config.spectrumOnEmpty
    readonly property alias workspaceCount: config.workspaceCount
    readonly property alias workspaceMax: config.workspaceMax
    readonly property alias workspaceMode: config.workspaceMode
    readonly property alias workspaceStyle: config.workspaceStyle
    readonly property alias motionScale: config.motionScale
    readonly property alias motionCurve: config.motionCurve
    readonly property alias animationPreset: config.animationPreset
    readonly property alias windowShadow: config.windowShadow
    readonly property alias barShadow: config.barShadow
    readonly property alias windowGlass: config.windowGlass
    readonly property alias surfaceStyle: config.surfaceStyle
    readonly property alias barSides: config.barSides
    readonly property alias wallpaperTransition: config.wallpaperTransition
    readonly property alias fontFamily: config.fontFamily
    readonly property alias fontMono: config.fontMono
    readonly property alias notificationTimeout: config.notificationTimeout
    readonly property alias compositor: config.compositor
    readonly property alias keyboard: config.keyboard
    readonly property alias displays: config.displays
    readonly property alias keys: config.keys
    readonly property alias keymapVersion: config.keymapVersion
    readonly property alias launcherPrefixes: config.launcherPrefixes
    readonly property alias cursorColor: config.cursorColor
    readonly property alias cursorSize: config.cursorSize
    readonly property alias shakeToFind: config.shakeToFind
    readonly property alias nightLight: config.nightLight
    readonly property alias nightTemperature: config.nightTemperature
    readonly property alias lidPolicy: config.lidPolicy
    readonly property alias idleLock: config.idleLock
    readonly property alias idleScreen: config.idleScreen
    readonly property alias idleSuspend: config.idleSuspend
    readonly property alias language: config.language

    // ── LAUNCHER PREFIXES ───────────────────────────────────────────────────
    //
    // The first character that selects each launcher mode. Stored as
    // overrides keyed by mode id, so a new mode needs no new key.
    readonly property var launcherPrefixDefaults: ({
        calculate: "=", desk: ">", windows: "@", timer: "!", clipboard: "'",
        emoji: ":"
    })

    function launcherPrefix(id: string): string {
        const kept = config.launcherPrefixes ?? ({})
        const chosen = kept[id]
        if (typeof chosen === "string" && chosen.length === 1)
            return chosen
        return root.launcherPrefixDefaults[id] ?? ""
    }

    function setLauncherPrefix(id: string, sigil: string): void {
        const next = Object.assign({}, config.launcherPrefixes ?? ({}))
        if (sigil === "" || sigil === root.launcherPrefixDefaults[id])
            delete next[id]
        else
            next[id] = sigil
        config.launcherPrefixes = next
    }

    readonly property var clockFormats: [
        { id: "HH:mm", label: "24-hour", sample: "17:04" },
        { id: "hh:mm AP", label: "12-hour", sample: "05:04 PM" }
    ]

    // ── BAR LAYOUT ──────────────────────────────────────────────────────────
    //
    // The style is how the bar is drawn; the layout is what is on it, as two
    // lists either side of the island. Changing style keeps the layout.
    readonly property var barStyles: [
        { id: "grouped", label: "Grouped",    note: "The workspaces, the island and the modules together in the middle." },
        { id: "spread",  label: "Spread",     note: "The workspaces at one edge, the modules at the other, the island between them." },
        { id: "island",  label: "One island", note: "Everything inside a single capsule." },
        { id: "bezel",   label: "Bezel",      note: "A band across the whole top edge, with the island dropping out of its middle." }
    ]

    // The island is cut into the top edge: chosen, or the bezel, which is
    // always cut in.
    readonly property bool notched: config.islandAttached || config.barStyle === "bezel"

    // Used while `barLeft`/`barRight` are null. `workspaces` is the strip,
    // `tray` the applications' icons and `split` starts a new capsule; none is
    // a module. The tray is not drawn while it is empty.
    readonly property var barDefaults: ({
        left: ["workspaces"],
        right: ["tray", "notifications", "network", "bluetooth", "volume", "battery"]
    })

    // An entry is a bare id, or `{ id, shape, figure, when }` when the piece
    // has its own look. Empty shape/figure follow `chipShape`/`chipFigure`;
    // `when: "running"` shows it only while active (`ModuleService.shows`).
    //
    // Copied out: JsonAdapter returns lists as Qt sequences, which fail
    // `Array.isArray` and would be mutated in place by a caller's filter.
    function barItems(side: string): var {
        const kept = side === "left" ? config.barLeft : config.barRight
        const list = kept ? Array.from(kept) : root.barDefaults[side]
        return list.map(entry => typeof entry === "string"
            ? { id: entry, shape: "", figure: "", when: "" }
            : { id: entry.id, shape: entry.shape ?? "", figure: entry.figure ?? "",
                when: entry.when ?? "" })
    }

    function barZone(side: string): var {
        return root.barItems(side).map(item => item.id)
    }

    function onBar(id: string): bool {
        return root.barZone("left").indexOf(id) >= 0
            || root.barZone("right").indexOf(id) >= 0
    }

    // Drops splits at either end or next to another split, which would draw
    // an empty capsule.
    function tidy(items: var): var {
        const out = []
        const idOf = item => typeof item === "string" ? item : item.id
        for (const item of items) {
            if (idOf(item) === "split" && (out.length === 0 || idOf(out[out.length - 1]) === "split"))
                continue
            out.push(item)
        }
        while (out.length > 0 && idOf(out[out.length - 1]) === "split")
            out.pop()
        return out
    }

    // Accepts ids or items; stores a bare id for any piece without its own
    // look.
    function setBarZone(side: string, items: var): void {
        const packed = root.tidy(items).map(item => {
            if (typeof item === "string")
                return item
            if ((item.shape ?? "") === "" && (item.figure ?? "") === "" && (item.when ?? "") === "")
                return item.id
            const out = { id: item.id }
            if (item.shape)
                out.shape = item.shape
            if (item.figure)
                out.figure = item.figure
            if (item.when)
                out.when = item.when
            return out
        })
        root.set(side === "left" ? "barLeft" : "barRight", packed)
    }

    // What may sit beside the time on the island while it runs. A module left
    // out still works on the bar; it just doesn't take a side of the island.
    // `privacy` is the microphone, camera or screen in use, which has no
    // module. A recording is always there, and is not on this list.
    readonly property var besideDefaults: ["privacy", "timer", "media", "machine"]
    // Every one the settings offer; the workspace is off until chosen.
    readonly property var besideChoices: ["privacy", "timer", "media", "machine", "workspace"]

    // A kept list predates any choice added since: one that is on by default
    // joins it once, and stays off if it is taken off after that. A list kept
    // before this was remembered saw the first four.
    function welcomeActivities(): void {
        const kept = config.islandActivities
        if (!kept)
            return
        const seen = config.islandActivitiesSeen
            ? Array.from(config.islandActivitiesSeen) : ["privacy", "timer", "media", "workspace"]
        const fresh = root.besideDefaults.filter(id => seen.indexOf(id) < 0 && Array.from(kept).indexOf(id) < 0)
        if (fresh.length === 0 && seen.length === root.besideChoices.length)
            return
        config.islandActivities = Array.from(kept).concat(fresh)
        config.islandActivitiesSeen = root.besideChoices.slice()
    }

    function beside(id: string): bool {
        const kept = config.islandActivities
        return (kept ? Array.from(kept) : root.besideDefaults).indexOf(id) >= 0
    }

    function setBeside(id: string, on: bool): void {
        const kept = config.islandActivities
        const next = (kept ? Array.from(kept) : root.besideDefaults.slice())
            .filter(other => other !== id)
        if (on)
            next.push(id)
        root.set("islandActivities", next)
        root.set("islandActivitiesSeen", root.besideChoices.slice())
    }

    // ── CHIPS ───────────────────────────────────────────────────────────────
    //
    // One shape and one figure mode for the whole bar; a piece may override
    // both (`barItems`). A module without a gauge draws its symbol in either
    // shape (`ModuleService.shapeOf`).
    readonly property var chipShapes: [
        { id: "icon", label: "Icon", note: "The symbol alone, small." },
        { id: "ring", label: "Ring", note: "The gauge, in a circle." }
    ]

    // How the workspace strip draws a workspace: shapes first, then the
    // number written out.
    readonly property var workspaceStyles: [
        { id: "dots", label: "Dots" },
        { id: "bars", label: "Bars" },
        { id: "rings", label: "Rings" },
        { id: "numbers", label: "Numbers" },
        { id: "roman", label: "Roman" },
        { id: "kanji", label: "Kanji" },
        { id: "greek", label: "Greek" }
    ]

    readonly property var chipFigures: [
        { id: "off",   label: "No",       note: "No figure beside it" },
        { id: "hover", label: "On hover", note: "The figure opens under the pointer" },
        { id: "on",    label: "Always",   note: "The figure always beside it" }
    ]

    // No writes until the file has been read: `onAdapterUpdated` writes the
    // whole adapter, so an early `set` would overwrite every stored preference
    // with defaults. A second shell instance sharing the file makes the race
    // easy to hit. Refused writes are dropped, not queued, since a queue could
    // replay over a file another instance has written since.
    property bool arrived: false

    // No settings file existed at startup; `ProfileService` then starts on
    // the first bundled profile.
    property bool fresh: false

    function set(key: string, value: var): void {
        if (config[key] === undefined) {
            console.warn("Unknown setting:", key)
            return
        }
        if (!root.arrived) {
            console.warn("Settings not read yet; refusing to write", key)
            return
        }
        config[key] = value
    }

    // ── PROFILES ────────────────────────────────────────────────────────────
    //
    // A profile is every key except these, which belong to the machine or
    // the person: kept across switches, left out of exports and untouched by
    // Reset. The recorder and capture entries are last-used state.
    readonly property var machineKeys: [
        "displays", "lidPolicy", "workspaceMode",
        "userName", "userAvatar", "language", "keyboard", "weatherPlace", "githubUser",
        "emojiTone",
        "doNotDisturb", "nightLight", "nightTemperature", "barHidden",
        "gameMode",
        "cameraEnabled", "cameraEffect", "cameraReactions",
        "recorderAudio", "captureShape", "captureKind"
    ]

    // A Store never read from disk: its initialisers are the defaults.
    readonly property Store pristine: Store {}

    // Enumerating a QML object yields its properties, methods and `objectName`.
    readonly property var storedKeys: {
        const out = []
        for (const key in root.pristine) {
            if (key !== "objectName" && typeof root.pristine[key] !== "function")
                out.push(key)
        }
        return out
    }

    readonly property var profileKeys:
        root.storedKeys.filter(key => root.machineKeys.indexOf(key) < 0)

    // Type tag for matching a loaded value against its default. Lists come
    // back as Qt sequences (see `barItems`), so test the JSON form.
    function shapeOf(value: var): string {
        if (value === null || value === undefined)
            return "null"
        if (typeof value !== "object")
            return typeof value
        return JSON.stringify(value).charAt(0) === "[" ? "list" : "map"
    }

    // Whether `value` can replace this key's default. A null default (an
    // unarranged layout) accepts null, a list or a map; numbers must be finite.
    function accepts(key: string, value: var): bool {
        const wanted = root.shapeOf(root.pristine[key])
        const given = root.shapeOf(value)
        if (wanted === "null")
            return given === "null" || given === "list" || given === "map"
        if (given === "number" && !Number.isFinite(value))
            return false
        return wanted === given
    }

    // Deep copy as plain data, so callers never hold the store's objects.
    function copy(value: var): var {
        return value === undefined ? null : JSON.parse(JSON.stringify(value))
    }

    // One shared map for the shell and Lua, including inherited defaults to
    // retire. Loading is synchronous so no profile can migrate against an
    // incomplete map during startup.
    readonly property FileView keymapFile: FileView {
        path: Quickshell.shellPath("../hypr/keymap.tsv")
        blockLoading: true
        printErrors: true
    }

    readonly property int currentKeymapVersion: 1
    readonly property var keymap: {
        const rows = []
        for (const line of root.keymapFile.text().split("\n")) {
            if (line === "" || line.startsWith("#"))
                continue
            const fields = line.split("\t")
            if (fields.length >= 2)
                rows.push({ description: fields[0], combination: fields[1],
                    legacy: (fields[2] || "").split("|").filter(value => value !== "") })
        }
        return rows
    }

    // Modifier order and spelling case do not make a binding a customization.
    function keyChord(combination: string): string {
        const parts = combination.toUpperCase().split(/\s*\+\s*/)
        const key = parts.pop().trim()
        return parts.map(part => part.trim().replace(/^CONTROL$/, "CTRL")
            .replace(/^(MOD4|META)$/, "SUPER")).sort().concat([key]).join("+")
    }

    function migrateKeys(values: var, version: int): var {
        const next = ({})
        for (const description in (values ?? ({})))
            if (typeof values[description] === "string")
                next[description] = values[description]
        for (const row of root.keymap)
            if (row.combination === "@removed")
                delete next[row.description]
        if (version >= root.currentKeymapVersion || root.keymap.length === 0)
            return next
        for (const row of root.keymap) {
            const kept = next[row.description]
            if (row.combination === "@removed"
                    || (typeof kept === "string" && kept !== ""
                        && row.legacy.some(old => root.keyChord(old) === root.keyChord(kept))))
                delete next[row.description]
        }
        // A real custom binding wins over a newly assigned default. Keep the
        // custom chord and explicitly unbind only the colliding default, so
        // neither action fires unexpectedly and no user choice is lost.
        const custom = ({})
        for (const description of Object.keys(next).sort())
            if (next[description] !== "")
                custom[root.keyChord(next[description])] = description
        for (const row of root.keymap) {
            if (row.combination === "" || row.combination === "@removed"
                    || Object.prototype.hasOwnProperty.call(next, row.description))
                continue
            const winner = custom[root.keyChord(row.combination)]
            if (winner) {
                next[row.description] = ""
                console.warn("Keyboard map migration: kept custom", winner,
                    "on", row.combination, "; left", row.description, "unbound")
            }
        }
        return next
    }

    // Every profile key, from `values` where valid and from the defaults
    // otherwise, so a switch never inherits the previous profile's values.
    function complete(values: var): var {
        const given = values ?? ({})
        const out = {}
        for (const key of root.profileKeys) {
            const taken = Object.prototype.hasOwnProperty.call(given, key)
                && root.accepts(key, given[key])
            out[key] = root.copy(taken ? given[key] : root.pristine[key])
        }
        out.desktopEdges = root.edgeRecords(given.desktopEdges ?? given.desktopWidgets ?? [])
        for (const key of ["barLeft", "barRight", "centreButtons", "centreTop", "centreBlocks", "centreToggles"])
            out[key] = root.retainedEntries(out[key])
        // Old exported profiles kept keyboard options in `compositor`.
        // Keyboard settings are machine-wide now, never profile overrides.
        out.compositor = root.withoutKeyboard(out.compositor)
        out.keys = root.migrateKeys(out.keys, Number(given.keymapVersion) || 0)
        out.keymapVersion = root.keymap.length > 0 ? root.currentKeymapVersion
            : Number(given.keymapVersion) || 0
        return out
    }

    // The active profile, as plain data.
    function snapshot(): var {
        const out = {}
        for (const key of root.profileKeys)
            out[key] = root.copy(config[key])
        return out
    }

    // Applies a profile in one turn so the file is written once (`saver`).
    // Hyprland keeps the previous profile's values until reloaded; the caller
    // handles that (`CompositorService.reassert`).
    function adopt(values: var): bool {
        if (!root.arrived) {
            console.warn("Settings not read yet; refusing to adopt a profile")
            return false
        }
        const next = root.complete(values)
        for (const key of root.profileKeys)
            config[key] = next[key]
        return true
    }

    // Resets the active profile to defaults; machine keys are kept.
    function reset(): void {
        root.adopt({})
    }

    // Legacy layout rows are accepted only for the two retained edge surfaces.
    function edgeRecords(list: var): var {
        if (root.shapeOf(list) !== "list")
            return []
        const out = []
        for (const row of list ?? []) {
            if (!row || !["notes", "spectrum"].includes(row.id)
                    || !["left", "right", "bottom"].includes(row.edge))
                continue
            const kept = root.copy(row)
            for (const key of ["col", "row", "family", "theme", "style", "bare", "ink", "note"])
                delete kept[key]
            out.push(kept)
        }
        return out
    }

    function retainedEntries(list: var): var {
        if (!list || typeof list.length !== "number")
            return list
        return Array.from(list).filter(entry => !["dock", "widgets", "pet", "games", "markets", "claude", "codex", "impasto"].includes(
            typeof entry === "string" ? entry : (entry.id ?? entry.kind)))
    }
    // Explicit desktop defaults, independent of console/login-screen settings.
    // In particular, do not import a workstation's Caps-as-Compose option.
    function defaultKeyboard(): var {
        return ({ "input:kb_layout": "us,ir", "input:kb_variant": ",winkeys",
            "input:kb_options": "grp:caps_toggle" })
    }

    function withoutKeyboard(values: var): var {
        const next = Object.assign({}, values ?? ({}))
        for (const key of Object.keys(next))
            if (key.startsWith("input:kb_"))
                delete next[key]
        return next
    }

    function keyboardOptions(options: string): string {
        const tokens = options.split(",")
        if (!tokens.includes("grp:caps_toggle"))
            return options
        // These options repurpose the same physical key; unrelated Compose,
        // LED and third-level options remain untouched.
        return tokens.filter(option => !option.startsWith("caps:")
            && !option.startsWith("compose:caps")
            && !option.startsWith("lv3:caps_") && !option.startsWith("lv5:caps_")
            && !["ctrl:nocaps", "ctrl:swapcaps", "ctrl:grouptoggle_capscontrol",
                "ctrl:hyper_capscontrol"].includes(option)).join(",")
    }

    function migrateKeyboard(saved: var): var {
        const kept = ({})
        // Before the machine-wide keyboard store, these lived in profiles.
        for (const key of Object.keys(saved.compositor ?? ({})))
            if (key.startsWith("input:kb_"))
                kept[key] = saved.compositor[key]
        Object.assign(kept, saved.keyboard ?? ({}))
        const next = Object.assign(root.defaultKeyboard(), kept)
        // An existing layout without a variant meant its default variant,
        // not the positional Persian variant of the new fresh defaults.
        if (Object.prototype.hasOwnProperty.call(kept, "input:kb_layout")
                && !Object.prototype.hasOwnProperty.call(kept, "input:kb_variant"))
            next["input:kb_variant"] = ""
        const tokens = String(next["input:kb_options"]).split(",")
        if (tokens.includes("grp:win_space_toggle")) {
            const supported = tokens.some(option => option === "grp:caps_toggle"
                || option === "grp:alt_shift_toggle")
            next["input:kb_options"] = tokens.filter(option => option !== "grp:win_space_toggle")
                .concat(supported ? [] : ["grp:caps_toggle"]).filter(option => option !== "").join(",")
            console.warn("Keyboard migration: Super + Space is reserved for the launcher; using a supported layout switch (Caps Lock by default).")
        }
        next["input:kb_options"] = root.keyboardOptions(String(next["input:kb_options"]))
        return next
    }

    // ── STORAGE ─────────────────────────────────────────────────────────────

    readonly property FileView file: FileView {
        path: `${root.stateDirectory}/settings.json`
        watchChanges: true

        onFileChanged: reload()
        // Deferred to the end of the turn: calling `writeAdapter()` twice in
        // one turn reads back a stale `var` value and loses the second
        // change. Coalescing also means one write per turn (`adopt()`).
        onAdapterUpdated: saver.restart()
        onLoaded: {
            const saved = JSON.parse(file.text())
            const keyboard = root.migrateKeyboard(saved)
            if (JSON.stringify(config.keyboard) !== JSON.stringify(keyboard))
                config.keyboard = keyboard
            const compositor = root.withoutKeyboard(config.compositor)
            if (JSON.stringify(config.compositor) !== JSON.stringify(compositor))
                config.compositor = compositor
            if (config.keymapVersion < root.currentKeymapVersion && root.keymap.length > 0) {
                config.keys = root.migrateKeys(config.keys, config.keymapVersion)
                config.keymapVersion = root.currentKeymapVersion
            }
            root.arrived = true
            root.welcomeActivities()
            config.desktopEdges = root.edgeRecords(saved.desktopEdges ?? saved.desktopWidgets ?? [])
            for (const key of ["barLeft", "barRight", "centreButtons", "centreTop", "centreBlocks", "centreToggles"])
                config[key] = root.retainedEntries(config[key])
            if (config.surfaceStyle === "frosted")
                config.surfaceStyle = "glass"
            // One island spanning the screen is the bezel now.
            if (/"barFullWidth":\s*true/.test(file.text()) && config.barStyle === "island")
                config.barStyle = "bezel"
        }
        // First run: write the defaults, which then count as read.
        onLoadFailed: error => {
            if (error === FileViewError.FileNotFound) {
                root.fresh = true
                config.keymapVersion = root.currentKeymapVersion
                root.arrived = true
                writeAdapter()
            }
        }

        readonly property Timer saver: Timer {
            interval: 0
            onTriggered: root.file.writeAdapter()
        }

        Store {
            id: config
        }
    }

    // ── SCHEMA ──────────────────────────────────────────────────────────────
    //
    // Declared once, instantiated twice: `config` is read from the file and
    // `pristine` holds the defaults.
    component Store: JsonAdapter {
        property string clockFormat: "HH:mm"
        property bool clockShowsDate: false
        property bool clockShowsSeconds: false

        // Capsule height and distance from the top edge. Every other bar
        // metric derives from `barHeight`.
        property int barHeight: 32
        property int barMargin: 16

        // A notch flush with the top edge instead of a floating capsule.
        property bool islandAttached: false

        property int barSideMargin: 18

        // A bar on every screen, or only on the one being worked on. The
        // surface is on every screen either way: this is whether it paints.
        property bool barEverywhere: true

        // Zen: the bar off the screen and its band given to the windows; the
        // island still comes down for what it has to show.
        property bool barHidden: false

        // Every screen's four corners rounded off in black.
        property bool screenCorners: false

        // Game mode: no animations, blur, shadow or glass on the compositor,
        // over whatever the rest of the settings say.
        property bool gameMode: false

        // Window and bar shadows; edge note paper retains its own rendering.
        property bool windowShadow: false
        property bool barShadow: false

        // hyprglass. Dimmed in the settings when the plugin is not built;
        // `CompositorService` pushes it at login and after every reload.
        property bool windowGlass: false

        // The island's and the bar's ground: "classic" solid black,
        // "glass", the terminal's ground over the compositor's blur, or
        // "liquid", a clear frost over it (`Theme.islandGround`).
        property string surfaceStyle: "classic"

        // The bar's sides: "capsule", each group in a capsule, or "bare",
        // the icons on the wallpaper. The one-capsule style has its band.
        property string barSides: "capsule"

        // Row id from `WallpaperService.transitions`; `random` picks anew on
        // each change.
        property string wallpaperTransition: "wipe"


        // One of `barStyles`.
        property string barStyle: "grouped"

        // Ids either side of the island; null means `barDefaults`.
        property var barLeft: null
        property var barRight: null

        // Hovering the island opens the glance; a click still opens the
        // control centre.
        property bool islandSummary: true

        // The playing track's lyrics, looked up on lrclib.net while
        // something on screen shows them.
        property bool lyrics: true

        // Null means `besideDefaults`.
        property var islandActivities: null
        // The choices there were when that list was kept, so one added since
        // can join it once (`welcomeActivities`).
        property var islandActivitiesSeen: null

        // One of `chipShapes` and one of `chipFigures`.
        property string chipShape: "icon"
        property string chipFigure: "on"

        property int launcherResults: 9

        // Order with an empty query: `recent` ranks by launch count with
        // decay; otherwise alphabetical.
        property string launcherOrder: "recent"

        // Fit the island to the number of results instead of a fixed-height
        // list. Off by default: a list that holds still is easier to aim at.
        // `launcherResults` caps it either way.
        property bool launcherFits: false

        // Skin tone for emoji that have one: 0 is the default yellow, 1 to 5
        // light to dark. The person's, so it stays with the machine.
        property int emojiTone: 0

        // ── CAMERA ──────────────────────────────────────────────────
        //
        // Off takes the virtual camera away from every program.
        property bool cameraEnabled: true

        // One of `CameraService.effects`.
        property string cameraEffect: "natural"

        // The gestures that set off a reaction, by `CameraService.reactions` id.
        property var cameraReactions: ["thumbsup", "heart", "peace", "thumbsdown", "horns", "ok"]

        // ── CLIPBOARD ───────────────────────────────────────────────
        //
        // Off stops the watcher, not just the list.
        property bool clipboardHistory: true

        // Payloads are stored as separate files, so the index stays small.
        property int clipboardKeep: 200

        property bool clipboardImages: true

        // Password-manager copies are never stored regardless
        // (`clipboard.py`).
        property bool clipboardWipeOnLock: false

        // Enough to make text unreadable, no more.
        property int lockBlur: 32

        // "stacked", hours over minutes as the login screen draws them, or
        // "inline".
        property string lockClock: "stacked"

        // What is playing on the lock: "lyrics" (the player and its lyrics),
        // "player" or "off"; and behind it, the "cover" blurred or the
        // "desktop" as without music.
        property string lockMusic: "lyrics"
        property string lockMusicGround: "cover"

        // Empty means read from the system: the passwd full name and
        // `~/.face` (`AccountService`).
        property string userName: ""
        property string userAvatar: ""

        // Persisted so silent mode survives a restart.
        property bool doNotDisturb: false

        property bool recorderAudio: false

        // The capture surface reopens on its last shape and kind. The
        // destination is not stored: it resets to saving a file.
        property string captureShape: "region"
        property string captureKind: "photo"

        // Note bodies in the handwriting font instead of the UI font.
        property bool notesHandwriting: true

        // Show edge note decks only on empty workspaces.
        property bool deckOnEmpty: false

        // Show the spectrum only on empty workspaces.
        property bool spectrumOnEmpty: false


        // Dots always shown, and the total number of workspaces. Workspaces
        // past `workspaceCount` still show while occupied.
        property int workspaceCount: 5
        property int workspaceMax: 10
        // `shared`: every screen shares the same workspaces. `screen`: each
        // has ten of its own, the main screen 1–10 and the rest after it.
        property string workspaceMode: "screen"
        // How the strip draws each workspace: a shape (`dots`, `bars`, `rings`)
        // or its number written out (`numbers`, `roman`, `kanji`, `greek`).
        property string workspaceStyle: "dots"

        // Percentage. 100 is the designed speed; 0 disables animation.
        property int motionScale: 100

        // Named in Theme.easingCurves.
        property string motionCurve: "OutCubic"

        // Hyprland's animation preset, from Motion.presets (the two above
        // are the shell's own). `CompositorService` pushes it at startup and
        // after every reload; `animations.lua` deliberately has no preset.
        property string animationPreset: "macos"

        property string fontFamily: "Inter, Cantarell, SF Pro Text, sans-serif"
        property string fontMono: "JetBrainsMono Nerd Font Mono, monospace"

        property int notificationTimeout: 5000

        // ── COMPOSITOR ──────────────────────────────────────────────────
        //
        // Hyprland options changed from the settings window, keyed by
        // option path. Absent keys are left to the Lua config. The option
        // whitelist lives in `compositor.py`.
        property var compositor: ({})

        // The keyboard's own options (`input:kb_*`), kept apart from
        // `compositor` because the keyboard is the machine's, not the desk's.
        property var keyboard: root.defaultKeyboard()

        // ── DISPLAYS ────────────────────────────────────────────────────
        //
        // Arrangements keyed by the set of connected monitors (their
        // descriptions, sorted and joined). Without one, Hyprland's `auto`
        // applies.
        //
        //   <profile> primary   description of the screen the shell's
        //                       surfaces go on; "" means Quickshell's
        //                       first, where an unset
        //                       `PanelWindow.screen` lands anyway
        //             monitors  per description: mode, position, scale,
        //                       transform, mirror, vrr, disabled — each
        //                       optional, absent when unchanged
        //
        // Fields are defined by `monitors.py`.
        property var displays: ({})

        // ── KEYS ────────────────────────────────────────────────────────
        //
        // Sparse description -> combination overrides; "" is explicitly
        // unbound. keymap.tsv supplies defaults shared with Lua. The version
        // prevents a later custom choice from being mistaken for an old default.
        property var keys: ({})
        property int keymapVersion: 0

        // Launcher sigil overrides, keyed by mode id; absent means the
        // default in `launcherPrefixDefaults`.
        property var launcherPrefixes: ({})

        // Notes and audio spectrum on left/right/bottom screen edges only.
        // Existing notes, order, position, appearance and monitor descriptions
        // are retained when migrating the former mixed desktop layout.
        property var desktopEdges: []

        // ── CONTROL CENTRE ──────────────────────────────────────────────
        //
        // The top row's doors before `centreTop`, ids from
        // `ControlsService.doors`; read only as that row's default.
        property var centreButtons: null

        // The top row: `{ left, right }`, session action and door ids in
        // order. Null is the session's actions left and the doors above
        // right; two empty sides are no row at all.
        property var centreTop: null

        // The grid's columns and rows; 0 is the default the default layout
        // fills.
        property int centreColumns: 0
        property int centreRows: 0

        // The blocks on the control centre's grid, one row each:
        //
        //   id    the block, from `ControlsService.catalogue`
        //   col   which column its top left cell is in
        //   row   and which row
        //   size  "2x3": columns by rows, one of the sizes the block offers
        //
        // Null means the default layout.
        property var centreBlocks: null

        // Toggles on the tile block, in order, from
        // `ControlsService.toggleCatalogue`. Null is the default six;
        // overflow becomes a second page.
        property var centreToggles: null

        // kitty's ground, as `surfaceStyle`.
        property string terminalGround: "glass"


        // Anything wttr.in accepts: a city, postcode or airport code. Empty
        // lets wttr.in geolocate by IP, which can be tens of kilometres off.
        property string weatherPlace: ""

        // GitHub account used by the retained contribution service.
        property string githubUser: ""


        // Idle timeouts in minutes, 0 = never; all off by default.
        // `IdleService` runs one monitor per value.
        property int idleLock: 0
        property int idleScreen: 0
        property int idleSuspend: 0

        // Kelvin. Persisted, unlike keep-awake, so a restart comes back
        // warm. `SunsetService` drives hyprsunset.
        property bool nightLight: false
        property int nightTemperature: 4000

        // Closing the lid with another screen connected: `off` disables the
        // panel and moves its workspaces, `keep` leaves it on, `system`
        // defers to logind. The result is written into the display profile
        // so it survives hotplug. With no other screen, logind decides.
        property string lidPolicy: "off"

        // "palette" follows the accent; otherwise a fixed #rrggbb. Built and
        // applied by compositor.py.
        property string cursorColor: "palette"
        property int cursorSize: 24

        // hypr-dynamic-cursors' shake magnification (`shake.enabled`).
        property bool shakeToFind: true

        // Translations live in `theme/Tr.qml`; missing strings fall back to
        // English.
        property string language: "en"
    }
}

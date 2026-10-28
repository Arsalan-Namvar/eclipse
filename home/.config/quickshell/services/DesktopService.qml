// Screen-edge notes and audio spectrum. No general desktop widget grid.
pragma Singleton
import QtQml
import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../theme"
Singleton {
    id: root
    readonly property var insets: ({ top: Theme.barReserve, left: 0, right: 0, bottom: 0 })
    function nameOf(widget: var): string {
        const description = widget && typeof widget.screen === "string" ? widget.screen : ""
        if (description !== "") {
            const monitor = MonitorService.monitorFor(description)
            if (monitor && !monitor.disabled)
                return monitor.name
        }
        return MonitorService.effectivePrimaryName
    }

    // What goes in a row for the screen a surface is on. Empty for the
    // primary, so a one-screen desk writes no screens at all.
    function screenField(name: string): var {
        const description = MonitorService.descriptionFor(name)
        return description === "" || name === MonitorService.effectivePrimaryName
            ? null : description
    }
    function decksOn(name: string): var {
        return root.decks.filter(deck => root.nameOf(deck) === name)
    }
    property var boards: ({})

    function setBoard(name: string, width: real, height: real): void {
        if (name === "")
            return
        const kept = root.boards[name]
        if (kept && kept.width === width && kept.height === height)
            return
        const next = Object.assign({}, root.boards)
        next[name] = { width: width, height: height }
        root.boards = next
    }

    function boardOn(name: string): var {
        return root.boards[name] ?? ({ width: 0, height: 0 })
    }
    function edgeAt(x: real, y: real, width: real, height: real): string {
        return DeckService.edgeAt(x, y, width, height)
    }
    // Keep legacy keys/screens/edge configuration, discard grid-only records.
    function normalise(list: var): var {
        const rows = []
        for (const kept of list ?? []) {
            if (!kept || (kept.id !== "notes" && kept.id !== "spectrum")
                    || root.edges.indexOf(kept.edge) < 0)
                continue
            const row = Object.assign({}, kept)
            row.key = row.key || row.id
            for (const field of ["col", "row", "family", "theme", "style", "bare", "ink", "note"])
                delete row[field]
            rows.push(row)
        }
        return rows
    }
    property var widgets: root.normalise(SettingsService.desktopEdges)
    function isEdge(row: var): bool { return row && root.edges.indexOf(row.edge) >= 0 }
    function isDeck(row: var): bool { return root.isEdge(row) && row.id === "notes" }
    function isSpectrum(row: var): bool { return root.isEdge(row) && row.id === "spectrum" }
    readonly property var decks: root.widgets.filter(row => root.isDeck(row))
    readonly property var spectra: root.widgets.filter(row => root.isSpectrum(row))
    Connections {
        target: SettingsService
        function onDesktopEdgesChanged(): void {
            // A profile switch is authoritative even with a local save pending.
            // Otherwise that timer writes the previous profile over the new one.
            saver.stop()
            root.widgets = root.normalise(SettingsService.desktopEdges)
        }
    }
    readonly property Timer saver: Timer {
        interval: 120
        onTriggered: SettingsService.set("desktopEdges", root.widgets)
    }
    // Non-empty decks, or all of them while arranging.
    readonly property var shownDecks: root.editing
        ? root.decks
        : root.decks.filter(deck => root.deckNotes(deck).length > 0)

    // Keys of drawn widgets, per screen, each list reassigned only when that
    // screen's set changes. A surface's Repeater uses these instead of the
    // rows, since a new array would rebuild every delegate on each move or
    // resize — and a board that has not changed must keep the very array it
    // had, not an equal one.
    property var deckKeys: ({})
    property var spectrumKeys: ({})
    function deckKeysOn(name: string): var {
        return root.deckKeys[name] ?? []
    }

    function spectrumKeysOn(name: string): var {
        return root.spectrumKeys[name] ?? []
    }
    onShownDecksChanged: root.syncKeys()
    onSpectraChanged: root.syncKeys()
    onBoardsChanged: root.syncKeys()
    Component.onCompleted: {
        root.syncKeys()
        if (root.widgets.length > 0)
            HyprlandService.loadClients()
    }
    readonly property Connections rehomes: Connections {
        target: MonitorService

        function onEffectivePrimaryNameChanged(): void { root.syncKeys() }
        function onMonitorsChanged(): void { root.syncKeys() }
    }

    function syncKeys(): void {
        root.deckKeys = root.sameOrNew(root.deckKeys, root.sortByScreen(root.shownDecks))
        root.spectrumKeys = root.sameOrNew(root.spectrumKeys, root.sortByScreen(root.spectra))
    }
    function sortByScreen(list: var): var {
        const out = {}
        for (const name in root.boards)
            out[name] = []
        for (const widget of list) {
            const name = root.nameOf(widget)
            out[name] = (out[name] ?? []).concat([widget.key])
        }
        return out
    }

    // `next`, with every unchanged board's own array put back, and `kept`
    // itself when no board changed at all.
    function sameOrNew(kept: var, next: var): var {
        let same = true
        for (const name in next) {
            const before = kept[name]
            if (before && before.length === next[name].length
                    && before.every((key, index) => key === next[name][index]))
                next[name] = before
            else
                same = false
        }
        for (const name in kept) {
            if (!next[name])
                same = false
        }
        return same ? kept : next
    }
    function entryOf(key: string): var {
        return root.widgets.find(widget => widget.key === key) ?? null
    }
    function geometry(row: var, width: real, height: real): var {
        if (root.isSpectrum(row))
            return root.spectrumBox(root.nameOf(row), row, width, height)
        if (root.isDeck(row)) {
            const count = root.deckNotes(row).length
            return DeckService.stripBox(row.edge, count,
                DeckService.startOf(row.edge, count, root.alongOf(row), width, height), width, height)
        }
        return { x: 0, y: 0, width: 0, height: 0 }
    }
    function write(next: var): void {
        root.widgets = next
        saver.restart()
    }

    // Profile snapshots must include edits still waiting for the debounce.
    function flush(): void {
        if (!saver.running)
            return
        saver.stop()
        SettingsService.set("desktopEdges", root.widgets)
    }

    // A null value removes the field, so the row inherits the desktop default.
    function update(key: string, changes: var): void {
        root.write(root.widgets.map(widget => {
            if (widget.key !== key)
                return widget
            const next = Object.assign({}, widget, changes)
            for (const field in changes) {
                if (changes[field] === null)
                    delete next[field]
            }
            return next
        }))
    }

    // "<id>-<n>" with the first free n, e.g. "clock-2".
    function newKey(id: string): string {
        for (let n = 1; ; n++) {
            const key = `${id}-${n}`
            if (!root.entryOf(key))
                return key
        }
    }
    function remove(key: string): void {
        if (root.selected === key)
            root.selected = ""
        root.write(root.widgets.filter(widget => widget.key !== key))
    }
    readonly property var edges: ["left", "right", "bottom"]

    function deckOn(name: string, edge: string): var {
        return root.decksOn(name).find(deck => deck.edge === edge) ?? null
    }

    // Live, unarchived note keys on a deck, as a plain array.
    function deckNotes(deck: var): var {
        const list = deck && deck.notes ? deck.notes : []
        const keys = []
        const length = typeof list.length === "number" ? list.length : 0
        for (let index = 0; index < length; index++) {
            if (typeof list[index] === "string" && NotesService.entry(list[index])
                    && !NotesService.entry(list[index]).archived)
                keys.push(list[index])
        }
        return keys
    }

    // Position along the edge as a 0–1 fraction; defaults to 0.
    function alongOf(deck: var): real {
        const own = deck ? deck.along : undefined
        return typeof own === "number" ? Math.max(0, Math.min(1, own)) : 0
    }

    function setDeckAlong(key: string, along: real): void {
        if (root.isDeck(root.entryOf(key)))
            root.update(key, { along: Math.max(0, Math.min(1, along)) })
    }
    function placementOf(noteKey: string): string {
        const deck = root.decks.find(deck => root.deckNotes(deck).indexOf(noteKey) >= 0)
        return deck ? deck.edge : ""
    }
    function withoutNote(list: var, noteKey: string): var {
        const kept = []
        for (const row of list) {
            if (!root.isDeck(row)) {
                kept.push(row)
                continue
            }
            const notes = root.deckNotes(row).filter(key => key !== noteKey)
            if (notes.length > 0)
                kept.push(Object.assign({}, row, { notes: notes }))
        }
        return kept
    }
    function removeNote(noteKey: string): void {
        const kept = root.withoutNote(root.widgets, noteKey)
        if (root.selected !== "" && !kept.some(widget => widget.key === root.selected))
            root.selected = ""
        root.write(kept)
    }

    // Puts a note on an edge at `index`, joining the existing deck or
    // creating one. An existing deck keeps its key and position even when
    // this was its only note, so a tab being dragged is not destroyed.
    function placeNote(noteKey: string, name: string, edge: string, index = -1): void {
        if (!NotesService.entry(noteKey) || root.edges.indexOf(edge) < 0)
            return
        const target = root.deckOn(name, edge)
        if (!target) {
            const made = {
                key: root.newKey("notes"), id: "notes", edge: edge, notes: [noteKey], along: 0
            }
            const screen = root.screenField(name)
            if (screen !== null)
                made.screen = screen
            root.write(root.withoutNote(root.widgets, noteKey).concat([made]))
            return
        }
        const notes = root.deckNotes(target).filter(key => key !== noteKey)
        const at = index < 0 ? notes.length : Math.max(0, Math.min(notes.length, index))
        notes.splice(at, 0, noteKey)
        root.write(root.withoutNote(
            root.widgets.filter(widget => widget.key !== target.key), noteKey
        ).concat([Object.assign({}, target, { notes: notes })]))
    }
    function addDeck(name: string, edge: string): void {
        const note = NotesService.newest
        if (note)
            root.placeNote(note.key, name, edge)
    }

    // Moves a deck to another edge, or to another screen, merging into the
    // deck already there.
    function setDeckEdge(key: string, name: string, edge: string): void {
        const deck = root.entryOf(key)
        if (!root.isDeck(deck) || root.edges.indexOf(edge) < 0)
            return
        if (deck.edge === edge && root.nameOf(deck) === name)
            return
        const other = root.deckOn(name, edge)
        if (!other) {
            root.update(key, { edge: edge, screen: root.screenField(name) })
            return
        }
        const notes = root.deckNotes(other).concat(
            root.deckNotes(deck).filter(note => root.deckNotes(other).indexOf(note) < 0))
        const merged = { notes: notes }
        if (deck.takesNew === true)
            merged.takesNew = true
        if (root.selected === key)
            root.selected = other.key
        root.write(root.widgets
            .filter(widget => widget.key !== key)
            .map(widget => widget.key === other.key
                ? Object.assign({}, widget, merged) : widget))
    }

    // The one deck new notes land on, if any: `takesNew` on its row, cleared
    // from every other deck when set, and gone with the deck when it empties.
    function setTakesNew(key: string, on: bool): void {
        if (!root.isDeck(root.entryOf(key)))
            return
        root.write(root.widgets.map(widget => {
            if (!root.isDeck(widget))
                return widget
            const next = Object.assign({}, widget)
            if (on && widget.key === key)
                next.takesNew = true
            else
                delete next.takesNew
            return next
        }))
    }

    function noteAdded(noteKey: string): void {
        const deck = root.decks.find(widget => widget.takesNew === true)
        if (deck)
            root.placeNote(noteKey, root.nameOf(deck), deck.edge)
    }

    // A note ticked on or off a deck from the inspector.
    function toggleDeckNote(key: string, noteKey: string): void {
        const deck = root.entryOf(key)
        if (!root.isDeck(deck))
            return
        const notes = root.deckNotes(deck)
        if (notes.indexOf(noteKey) >= 0) {
            const left = notes.filter(note => note !== noteKey)
            if (left.length === 0)
                root.remove(key)
            else
                root.update(key, { notes: left })
            return
        }
        root.placeNote(noteKey, root.nameOf(deck), deck.edge)
    }
    function spectrumBox(name: string, row: var, boardWidth: real, boardHeight: real): var {
        const reach = root.spectrumOf(row).reach
        const left = -root.insets.left
        const top = -root.insets.top
        const width = boardWidth + root.insets.left + root.insets.right
        const height = boardHeight + root.insets.bottom
        if (row.edge === "bottom")
            return { x: left, y: height - reach, width: width, height: reach }
        const bottom = root.spectrumOn(name, "bottom")
        return {
            x: row.edge === "right" ? left + width - reach : left,
            y: top, width: reach,
            height: (bottom !== null ? height - root.spectrumOf(bottom).reach : height) - top
        }
    }
    readonly property var spectrumLooks: [
        { id: "rounded",  label: "Rounded columns" },
        { id: "square",   label: "Square columns" },
        { id: "segments", label: "Segments" },
        { id: "dots",     label: "Dots" },
        { id: "wave",     label: "Wave" }
    ]

    readonly property var spectrumFills: [
        { id: "fade",  label: "Fading to the tip" },
        { id: "solid", label: "Solid" },
        { id: "blend", label: "Two colours" }
    ]

    readonly property var spectrumRanges: ({
        reach: { from: 60, to: 400 },
        bar: { from: 2, to: 24 },
        gap: { from: 1, to: 16 },
        opacity: { from: 20, to: 100 }
    })

    // "palette" or one of the fixed colours; anything else is `fallback`.
    function spectrumColourName(value: var, fallback: string): string {
        return value === "palette" || Theme.fixedColours.some(entry => entry.id === value)
            ? value : fallback
    }

    function spectrumColour(name: string): color {
        return name === "palette" ? Theme.accent : Qt.color(name)
    }

    function spectrumOf(row: var): var {
        const own = row ?? ({})
        const pick = (value, list, fallback) =>
            list.some(entry => (entry.id ?? entry) === value) ? value : fallback
        const within = (field, fallback) => {
            const range = root.spectrumRanges[field]
            const value = own[field]
            return typeof value === "number"
                ? Math.max(range.from, Math.min(range.to, Math.round(value))) : fallback
        }
        return {
            look: pick(own.look, root.spectrumLooks, "rounded"),
            fill: pick(own.fill, root.spectrumFills, "fade"),
            colorName: root.spectrumColourName(own.color, "palette"),
            color2Name: root.spectrumColourName(own.color2, "#ffffff"),
            color: root.spectrumColour(root.spectrumColourName(own.color, "palette")),
            color2: root.spectrumColour(root.spectrumColourName(own.color2, "#ffffff")),
            reach: within("reach", Theme.spectrumReach),
            bar: within("bar", Theme.spectrumBar),
            gap: within("gap", Theme.spectrumGap),
            lows: pick(own.lows, ["corners", "along"], "corners"),
            peaks: own.peaks === true,
            opacity: within("opacity", 100)
        }
    }
    readonly property Binding watching: Binding {
        target: HyprlandService
        property: "watchClients"
        value: root.widgets.length > 0
    }
    onWidgetsChanged: {
        if (root.widgets.length > 0)
            HyprlandService.loadClients()
    }
    function coveredOn(name: string): bool {
        const workspace = HyprlandService.activeOn(name)
        return workspace > 0 && HyprlandService.clients.some(client =>
            (client.fullscreen ?? 0) >= 2 && client.workspace && client.workspace.id === workspace)
    }
    function spectrumAwayOn(name: string): bool {
        if (root.coveredOn(name))
            return true
        if (!SettingsService.spectrumOnEmpty)
            return false
        const workspace = HyprlandService.activeOn(name)
        return workspace > 0 && HyprlandService.occupiedIds.indexOf(workspace) >= 0
    }

    // On the grid or on an edge.
    function setSpectrum(key: string, changes: var): void {
        const row = root.entryOf(key)
        if (row && row.id === "spectrum")
            root.update(key, changes)
    }

    function spectrumOn(name: string, edge: string): var {
        return root.spectra.find(row => row.edge === edge && root.nameOf(row) === name) ?? null
    }

    // Whether a spectrum can go on `edge` of `name`: an edge, and not one
    // that has one already, its own included.
    function spectrumTakes(name: string, edge: string): bool {
        return root.edges.indexOf(edge) >= 0 && root.spectrumOn(name, edge) === null
    }

    // The bottom first, then the sides; "" when all three have one.
    function freeSpectrumEdge(name: string): string {
        return ["bottom", "left", "right"].find(edge => root.spectrumOn(name, edge) === null) ?? ""
    }

    // Tray tile dropped on an edge, or clicked (`edge` empty: the first free
    // one). Returns the new key, or "" when there is no room.
    function addSpectrum(name: string, edge = ""): string {
        const on = edge !== "" ? edge : root.freeSpectrumEdge(name)
        if (!root.spectrumTakes(name, on))
            return ""
        const made = { key: root.newKey("spectrum"), id: "spectrum", edge: on }
        const screen = root.screenField(name)
        if (screen !== null)
            made.screen = screen
        root.write(root.widgets.concat([made]))
        return made.key
    }

    function setSpectrumEdge(key: string, name: string, edge: string): void {
        if (!root.isSpectrum(root.entryOf(key)) || !root.spectrumTakes(name, edge))
            return
        root.update(key, { edge: edge, screen: root.screenField(name) })
    }
    property bool editing: false
    property string dragging: ""
    property string selected: ""
    property bool inHand: false
    property string editingScreen: ""
    property string galleryScreen: ""
    property var trayBox: null
    function overTray(name: string, x: real, y: real): bool {
        const box = root.trayBox
        return box !== null && name === root.galleryScreen
            && x >= box.x && x <= box.x + box.width && y >= box.y && y <= box.y + box.height
    }
    property var surfaces: ({})

    function publish(name: string, window: var): void {
        const next = Object.assign({}, root.surfaces)
        if (window === null)
            delete next[name]
        else
            next[name] = window
        root.surfaces = next
    }

    readonly property var windows: {
        const out = []
        for (const name in root.surfaces)
            out.push(root.surfaces[name])
        return out
    }
    function edit(on: bool, name = ""): void {
        root.editing = on
        if (on) {
            const screen = name || MonitorService.effectivePrimaryName
            root.editingScreen = screen
            root.galleryScreen = screen
        } else {
            root.dragging = ""
            root.selected = ""
            root.editingScreen = ""
            root.galleryScreen = ""
            root.trayBox = null
        }
    }
    readonly property Connections compositor: Connections {
        target: Hyprland

        function onRawEvent(event): void {
            if (!root.editing)
                return
            switch (event.name) {
            case "workspacev2":
            case "activespecialv2":
            case "openwindow":
                root.edit(false)
                break
            case "fullscreen":
                if (event.data === "1")
                    root.edit(false)
                break
            }
        }
    }
}

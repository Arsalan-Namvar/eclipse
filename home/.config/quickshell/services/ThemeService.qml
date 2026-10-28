// ╭──────────────────────────────────────────────────────────────────────────╮
// │                                                                          │
// │   T H E M E   S E R V I C E                                              │
// │   active palette · persistence and adaptive colours                      │
// │                                                                          │
// │   github.com/andreumassanet/impasto                                      │
// │                                                                          │
// ╰──────────────────────────────────────────────────────────────────────────╯

pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import "../theme"

// Owns which palette is active and keeps that choice across restarts.
QtObject {
    id: root

    readonly property string script: Quickshell.shellPath("scripts/theme_manager.py")

    property string activeId: "adaptive"
    property var dynamicColors: null

    // The adaptive entry has no static colours: they come from the wallpaper.
    readonly property var adaptiveTheme: ({
        id: "adaptive",
        name: "Adaptive (Wallpaper)",
        badge: "From Wallpaper",
        adaptive: true,
        colors: null
    })

    // Built from Palettes so a palette is described exactly once.
    readonly property var availableThemes: [root.adaptiveTheme].concat(Palettes.list)

    // The wallpaper colours once extracted, the current theme until then.
    readonly property var adaptiveSwatches: root.dynamicColors
        ? [root.dynamicColors.background, root.dynamicColors.surface,
           root.dynamicColors.accent, root.dynamicColors.text]
        : [Theme.background, Theme.surface, Theme.accent, Theme.text]

    // Restores the persisted choice on startup.
    readonly property Process stateProcess: Process {
        command: [root.script, "get-state"]
        running: true
        stdout: StdioCollector {
            // streamFinished, not textChanged: the collector fires per chunk
            // and JSON.parse on half a document throws.
            onStreamFinished: {
                const state = root.parseJson(text, "shell state")
                if (state && state.activeTheme)
                    root.setTheme(state.activeTheme, false)
            }
        }
    }

    readonly property Process extractProcess: Process {
        command: [root.script, "extract-colors"]
        stdout: StdioCollector {
            onStreamFinished: {
                const colors = root.parseJson(text, "wallpaper colours")
                if (!colors)
                    return
                root.dynamicColors = colors
                if (root.activeId === "adaptive") {
                    Theme.apply(colors, root.adaptiveTheme.name)
                    root.pushTerminal(colors)
                }
            }
        }
    }

    readonly property Process persistProcess: Process {}

    readonly property Process terminalProcess: Process {}

    // ── FONT ────────────────────────────────────────────────────────────────
    //
    // The monospace family is pushed to kitty so the terminal follows the
    // setting.
    readonly property string terminalFont: SettingsService.fontMono

    onTerminalFontChanged: root.pushTerminalFont()

    function pushTerminalFont(): void {
        if (!SettingsService.arrived)
            return
        root.fontProcess.command = [root.script, "push-terminal-font",
                                    SettingsService.fontMono]
        if (root.fontProcess.running)
            root.fontAgain = true
        else
            root.fontProcess.running = true
    }

    // A push asked for while one runs goes again when it exits; a running
    // Process ignores being started.
    property bool fontAgain: false
    readonly property Process fontProcess: Process {
        onExited: if (root.fontAgain) {
            root.fontAgain = false
            root.pushTerminalFont()
        }
    }

    // ── GROUND ──────────────────────────────────────────────────────────────
    //
    // The terminal's ground, chosen beside the shell's.
    readonly property string terminalGround: SettingsService.terminalGround

    onTerminalGroundChanged: root.pushTerminalGround()

    function pushTerminalGround(): void {
        if (!SettingsService.arrived)
            return
        root.groundProcess.command = [root.script, "push-terminal-ground",
                                      SettingsService.terminalGround]
        if (root.groundProcess.running)
            root.groundAgain = true
        else
            root.groundProcess.running = true
    }

    property bool groundAgain: false
    readonly property Process groundProcess: Process {
        onExited: if (root.groundAgain) {
            root.groundAgain = false
            root.pushTerminalGround()
        }
    }

    // Also pushed at startup, once the settings are read: before that they
    // hold the defaults, and a setting that never changes would leave the
    // fragment kitty.conf includes unwritten.
    function pushTerminalSettings(): void {
        root.pushTerminalFont()
        root.pushTerminalGround()
    }

    Component.onCompleted: root.pushTerminalSettings()

    readonly property Connections settingsArrival: Connections {
        target: SettingsService
        function onArrivedChanged(): void {
            root.pushTerminalSettings()
        }
    }


    // The backend writes the colour fragment kitty.conf includes and repaints
    // open kitty windows.
    function pushTerminal(colors: var): void {
        if (!colors)
            return
        root.terminalProcess.command = [root.script, "push-terminal-palette",
                                        JSON.stringify(colors)]
        root.terminalProcess.running = true
    }

    function parseJson(text: string, what: string): var {
        if (!text || text.trim() === "")
            return null
        try {
            return JSON.parse(text)
        } catch (error) {
            console.warn(`Cannot parse ${what}:`, error)
            return null
        }
    }

    function reloadAdaptiveColors(): void {
        root.extractProcess.running = true
    }

    function setTheme(themeId: string, persist = true): void {
        root.activeId = themeId
        Theme.activeId = themeId

        if (themeId === "adaptive") {
            if (root.dynamicColors) {
                Theme.apply(root.dynamicColors, root.adaptiveTheme.name)
                root.pushTerminal(root.dynamicColors)
            } else {
                root.reloadAdaptiveColors()
            }
        } else {
            const palette = Palettes.byId(themeId)
            if (palette) {
                Theme.apply(palette.colors, palette.name)
                root.pushTerminal(palette.colors)
            } else {
                console.warn("Unknown palette:", themeId)
            }
        }

        if (persist) {
            root.persistProcess.command = [root.script, "set-theme", themeId]
            root.persistProcess.running = true
        }
    }
}

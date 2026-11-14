// ╭──────────────────────────────────────────────────────────────────────────╮
// │                                                                          │
// │   M O T I O N                                                            │
// │   singleton · how the compositor moves, described once                   │
// │                                                                          │
// │   github.com/andreumassanet/impasto                                      │
// │                                                                          │
// ╰──────────────────────────────────────────────────────────────────────────╯

pragma Singleton

import QtQuick
import Quickshell

// Hyprland animation presets, pushed by CompositorService. Each is one bezier
// and three durations, in deciseconds (2.6 = 260 ms):
//
//   slow    geometry
//   medium  appearing and disappearing
//   fast    colour changes
//
// `windows` and `workspaces` are Hyprland animation styles; a `popin`
// percentage is the size a window starts at. Labels deliberately differ from
// the shell's own curve names (Smooth, Snappy, Springy).
Singleton {
    id: root

    readonly property var presets: [
        {
            // Id kept for existing settings files.
            id: "macos",
            label: "Glide",
            note: "Scales into place and decelerates with a long tail. Quick, and it never bounces.",
            curve: [0.32, 0.72, 0, 1],
            slow: 2.6, medium: 1.8, fast: 1.4,
            windows: "slide", workspaces: "slide"
        },
        {
            id: "snappy",
            label: "Brisk",
            note: "Half the distance and half the time. Movement you register rather than watch.",
            curve: [0.22, 1, 0.36, 1],
            slow: 1.3, medium: 1.0, fast: 0.8,
            windows: "popin 94%", workspaces: "slide"
        },
        {
            id: "smooth",
            label: "Calm",
            note: "Long and soft, with a gentle arrival.",
            curve: [0.25, 0.1, 0.25, 1],
            slow: 4.2, medium: 3.0, fast: 2.2,
            windows: "popin 85%", workspaces: "fade"
        },
        {
            id: "springy",
            label: "Bounce",
            note: "Overshoots a little and settles back. The look most Hyprland presets are after.",
            curve: [0.05, 0.9, 0.1, 1.15],
            slow: 3.2, medium: 2.0, fast: 1.4,
            windows: "popin 80%", workspaces: "slide"
        },
        {
            id: "off",
            label: "None",
            note: "Windows appear where they are going to be."
        }
    ]

    function workspaceNoteOf(id: string): string {
        switch (id) {
        case "macos": return "Slide with a long, smooth deceleration."
        case "snappy": return "A quick slide with a short settling time."
        case "smooth": return "Fade gently between workspaces."
        case "springy": return "Slide with a small overshoot and settle."
        case "off": return "Switch workspaces and show the scratchpad instantly."
        }
        return root.workspaceNoteOf(root.presets[0].id)
    }

    function preset(id: string): var {
        return root.presets.find(entry => entry.id === id) ?? root.presets[0]
    }

    function labelOf(id: string): string {
        return root.preset(id).label
    }

    function noteOf(id: string): string {
        return root.preset(id).note
    }

    // The preset as a single Lua chunk for `hyprctl eval`, so it applies
    // atomically rather than one leaf per process.
    function chunk(windowId: string, workspaceId: string, gameMode: bool): string {
        const windows = root.preset(windowId)
        const workspace = root.preset(workspaceId)
        const windowOn = !gameMode && windows.id !== "off"
        const workspaceOn = !gameMode && workspace.id !== "off"
        const lines = [`hl.config({ animations = { enabled = ${windowOn || workspaceOn} } })`]

        function curve(name, entry) {
            const c = entry.curve
            lines.push(`hl.curve("${name}", { type = "bezier", points = { {${c[0]}, ${c[1]}}, {${c[2]}, ${c[3]}} } })`)
        }
        function leaf(name, enabled, speed, bezier, style) {
            if (!enabled) {
                lines.push(`hl.animation({ leaf = "${name}", enabled = false })`)
                return
            }
            const tail = style ? `, style = "${style}"` : ""
            lines.push(`hl.animation({ leaf = "${name}", enabled = true, speed = ${speed}, bezier = "${bezier}"${tail} })`)
        }
        if (windowOn) curve("windowPreset", windows)
        if (workspaceOn) curve("workspacePreset", workspace)

        // Parent first; explicit children allow workspace motion with windows off.
        leaf("global", windowOn, windows.slow, "windowPreset")
        leaf("windows", windowOn, windows.slow, "windowPreset")
        leaf("windowsIn", windowOn, windows.slow, "windowPreset", windows.windows)
        leaf("windowsOut", windowOn, windows.medium, "windowPreset", windows.windows)
        for (const name of ["workspaces", "workspacesIn", "workspacesOut"])
            leaf(name, workspaceOn, workspace.slow, "workspacePreset", workspace.workspaces)
        // Explicit directions: enter from below and return below when hidden.
        leaf("specialWorkspace", workspaceOn, workspace.slow, "workspacePreset", "slidevert")
        leaf("specialWorkspaceIn", workspaceOn, workspace.slow, "workspacePreset", "slidevert bottom")
        leaf("specialWorkspaceOut", workspaceOn, workspace.slow, "workspacePreset", "slidevert top")

        leaf("layers", windowOn, windows.medium, "windowPreset")
        leaf("layersIn", windowOn, windows.medium, "windowPreset", "fade")
        leaf("layersOut", windowOn, windows.fast, "windowPreset", "fade")
        leaf("fade", windowOn, windows.medium, "windowPreset")
        // Opening windows must not flash translucent neighbours during retiling.
        leaf("fadeIn", false)
        leaf("fadeOut", windowOn, windows.fast, "windowPreset")
        leaf("fadeLayersIn", windowOn, windows.medium, "windowPreset")
        leaf("fadeLayersOut", windowOn, windows.fast, "windowPreset")
        leaf("border", windowOn, windows.fast, "windowPreset")
        return lines.join(" ")
    }
}

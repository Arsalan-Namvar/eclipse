pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int watchers: 0
    property var sessions: []
    property string selectedId: ""
    property var lastSelected: null
    property string error: ""
    readonly property var selected: {
        const row = root.sessions.find(entry => entry.id === root.selectedId)
        return row ?? root.lastSelected
    }
    readonly property string state: {
        if (!root.selectedId)
            return "Choose a session"
        if (!root.sessions.some(entry => entry.id === root.selectedId))
            return "disconnected"
        return root.selected?.state ?? "disconnected"
    }
    readonly property real contextFraction: root.selected?.context?.percent !== null
        && root.selected?.context?.percent !== undefined
        ? Math.max(0, Math.min(1, root.selected.context.percent / 100)) : 0
    readonly property string figure: !root.selectedId ? "OMP"
        : root.state === "ended" || root.state === "disconnected" ? root.state
        : typeof root.selected?.context?.percent === "number" ? `${Math.round(root.selected.context.percent)}%` : root.state

    function select(id: string): void {
        const row = root.sessions.find(entry => entry.id === id)
        if (!row)
            return
        root.selectedId = id
        root.lastSelected = row
    }

    function subscribe(): void {
        root.watchers += 1
        root.refresh()
    }

    function release(): void {
        root.watchers = Math.max(0, root.watchers - 1)
    }

    function refresh(): void {
        if (!query.running)
            query.running = true
    }

    function launch(): void {
        Quickshell.execDetached(["bash", Quickshell.shellPath("scripts/omp-launch.sh"), "--general"])
    }

    function count(value: var): string {
        return typeof value === "number" && isFinite(value) ? Math.round(value).toLocaleString() : "Unavailable"
    }

    readonly property Timer poller: Timer {
        interval: 2000
        repeat: true
        running: root.watchers > 0
        onTriggered: root.refresh()
    }

    readonly property Process query: Process {
        command: ["python3", Quickshell.shellPath("scripts/omp_status.py")]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const report = JSON.parse(text)
                    root.sessions = report.sessions ?? []
                    root.error = report.error ?? ""
                    const chosen = root.sessions.find(entry => entry.id === root.selectedId)
                    if (chosen)
                        root.lastSelected = chosen
                } catch (error) {
                    root.error = "Cannot read OMP status"
                    root.sessions = []
                }
            }
        }
    }
}

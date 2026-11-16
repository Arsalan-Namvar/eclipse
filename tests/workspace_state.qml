// Invoked by test_workspace_state.py with isolated state and compositor IPC.
import QtQuick
import Quickshell
import "services"

ShellRoot {
    Timer {
        interval: 10
        running: true
        repeat: true
        function expect(condition, message) {
            if (!condition) throw new Error(message)
        }
        onTriggered: {
            if (!SettingsService.arrived) return
            stop()
            try {
                SettingsService.set("workspaceMode", "screen")
                const normal = [
                    {id: 1, type: "normal", name: "1", monitor: "left", windows: 1},
                    {id: 11, type: "normal", name: "11", monitor: "right", windows: 2}
                ]
                HyprlandService.noteActive("left", 1)
                HyprlandService.noteActive("right", 11)
                for (const special of [
                    {type: "special", name: "special:scratchpad", monitor: "left", windows: 1},
                    {type: "special", name: "special:scratchpad", monitor: "right", windows: 1},
                    {id: -99, name: "special:scratchpad", monitor: "left", windows: 1}
                ]) {
                    HyprlandService.updateWorkspaces(normal.concat([special]))
                    expect(Number.isFinite(HyprlandService.span), "Scratchpad collapsed strip span")
                    expect(HyprlandService.named.length === 2, "Special workspace entered numbered list")
                    expect(JSON.stringify(HyprlandService.occupiedIds) === "[1,11]", "Wrong occupied slots")
                    expect(HyprlandService.activeOn("left") === 1, "Left active workspace lost")
                    expect(HyprlandService.activeOn("right") === 11, "Right active workspace lost")
                    expect(HyprlandService.isVisibleOn(1, "left"), "Left strip missing")
                    expect(HyprlandService.isVisibleOn(11, "right"), "Right strip missing")
                }
                HyprlandService.updateWorkspaces(normal)
                expect(Number.isFinite(HyprlandService.span), "Strip did not survive scratchpad removal")
                console.log("WORKSPACE_STATE_PASSED")
                Qt.quit()
            } catch (error) {
                console.error(error)
                Qt.exit(1)
            }
        }
    }
}

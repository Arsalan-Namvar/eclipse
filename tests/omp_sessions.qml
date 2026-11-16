// Invoked with isolated state by test_omp_sessions.py.
import QtQuick
import Quickshell
import "services"

ShellRoot {
    Timer {
        interval: 1
        running: true
        function expect(condition, message) {
            if (!condition) throw new Error(message)
        }
        onTriggered: {
            try {
                const first = {id: "first", state: "idle"}
                const second = {id: "second", state: "working"}
                const ended = {id: "old", state: "ended"}
                OmpService.receive({sessions: [ended, first, second]})
                expect(OmpService.sessions.length === 2, "Ended session remains listed")
                OmpService.select("first")
                OmpService.receive({sessions: [first, {id: "second", state: "ended"}]})
                expect(OmpService.sessions.length === 1, "Unselected ended session remains")
                expect(OmpService.selectedId === "first", "Unrelated shutdown changed selection")
                OmpService.receive({sessions: [{id: "first", state: "ended"}, second]})
                expect(OmpService.sessions.length === 1 && OmpService.sessions[0].id === "second", "Wrong remaining sessions")
                expect(OmpService.selectedId === "" && OmpService.selected === null, "Ended selection or metrics retained")
                expect(OmpService.figure === "OMP", "Chip retains ended selection")
                OmpService.receive({sessions: [second]})
                expect(OmpService.selectedId === "", "Another session auto-selected")
                OmpService.select("second")
                OmpService.receive({sessions: [{id: "second", state: "disconnected"}]})
                expect(OmpService.state === "disconnected" && OmpService.selectedId === "second", "Disconnected session lost")
                OmpService.receive({sessions: [{id: "second", state: "ended"}]})
                expect(OmpService.sessions.length === 0 && OmpService.selected === null, "Last ended session left stale details")
                console.log("OMP_SESSIONS_PASSED")
                Qt.quit()
            } catch (error) {
                console.error(error)
                Qt.exit(1)
            }
        }
    }
}

pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    readonly property int panelWidth: 680
    readonly property int panelHeight: 510
    readonly property string script: Quickshell.shellPath("scripts/github_browser.py")
    property string view: "contributions"
    property string owner: ""
    property string repository: ""
    property string state: "open"
    property string query: ""
    property int page: 1
    property var trail: []
    property var items: []
    property bool nextPage: false
    property string account: ""
    property string error: ""
    property string reason: ""
    property bool pending: false
    readonly property bool busy: request.running

    function location(): var {
        return { view: root.view, owner: root.owner, repository: root.repository,
            state: root.state, query: root.query, page: root.page }
    }
    function navigate(view: string, owner: string, repo: string): void {
        root.trail = root.trail.concat([root.location()])
        root.view = view
        root.owner = owner
        root.repository = repo
        root.state = "open"
        root.query = ""
        root.page = 1
        root.refresh()
    }
    function back(): void {
        if (root.trail.length === 0) return
        const list = root.trail.slice()
        const previous = list.pop()
        root.trail = list
        root.view = previous.view
        root.owner = previous.owner
        root.repository = previous.repository
        root.state = previous.state
        root.query = previous.query
        root.page = previous.page
        root.refresh()
    }
    function tab(view: string): void {
        root.trail = []
        root.view = view
        root.owner = ""
        root.repository = ""
        root.query = ""
        root.state = "open"
        root.page = 1
        root.refresh()
    }
    function refresh(): void {
        root.items = []
        root.nextPage = false
        root.error = ""
        root.reason = ""
        if (root.view === "contributions") return
        root.pending = true
        if (!root.busy) root.run()
    }
    function run(): void {
        if (!root.pending || root.view === "contributions") return
        root.pending = false
        request.context = JSON.stringify(root.location())
        request.command = ["python3", root.script, root.view,
            "--owner", root.owner, "--repo", root.repository,
            "--page", String(root.page), "--state", root.state,
            "--query", root.query]
        request.running = true
    }
    function open(url: string): void {
        if (/^https:\/\/github\.com\//.test(url)) Qt.openUrlExternally(url)
    }
    function clear(): void {
        // Private titles are memory-only and disappear with the panel.
        root.trail = []
        root.items = []
        root.query = ""
        root.view = "contributions"
        root.pending = false
        root.error = ""
        root.reason = ""
        root.account = ""
    }
    readonly property Process request: Process {
        property string context: ""
        stdout: StdioCollector {
            onStreamFinished: {
                if (request.context !== JSON.stringify(root.location())) return
                try {
                    const result = JSON.parse(text)
                    root.items = result.items ?? []
                    root.nextPage = result.next === true
                    root.error = result.error ?? ""
                    root.reason = result.reason ?? ""
                    if (result.account) root.account = result.account
                } catch (error) {
                    root.error = "GitHub response could not be read."
                    root.reason = "response"
                }
            }
        }
        onExited: Qt.callLater(root.run)
    }
}

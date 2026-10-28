pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Only the public NetworkManager profile/state projection lives in the shell.
// Credentials never enter QML or Eclipse settings/profile serialization.
Singleton {
    id: root

    property var profiles: []
    property string error: ""
    property string message: ""
    property string version: ""
    property bool busy: false
    readonly property string script: Quickshell.shellPath("scripts/vpn.py")
    property int watchers: 0
    function refresh(): void {
        if (!query.running)
            query.running = true
    }

    function operate(action: string, args: var): void {
        if (root.busy)
            return
        root.busy = true
        root.error = ""
        root.message = ""
        operation.command = ["/usr/bin/python3", root.script, action].concat(args)
        operation.running = true
    }

    function importProfile(protocol: string, filename: string): void {
        root.operate("import", [protocol, filename])
    }

    function disconnect(uuid: string): void {
        root.operate("disconnect", [uuid])
    }

    function remove(uuid: string): void {
        root.operate("delete", [uuid])
    }

    function connect(uuid: string): void {
        // nmcli --ask is the secret agent. Its terminal output is deliberately
        // not piped back into the shell or a file. UUID is not a credential.
        Quickshell.execDetached(["kitty", "--title", "VPN authentication", "/usr/bin/python3", root.script, "connect", uuid])
        root.message = "Authentication opens in Kitty. Closing it cancels pending authentication; NetworkManager reports the actual state below."
    }

    function create(protocol: string): void {
        root.openEditor(["--create", "--type", protocol === "openvpn" ? "vpn:openvpn" : "wireguard"])
    }

    function edit(uuid: string): void {
        root.openEditor(["--edit", uuid])
    }

    function openEditor(args: var): void {
        root.error = ""
        root.message = "NetworkManager's editor opens in a separate window. Save there to create/update the real profile; Cancel makes no changes."
        editor.command = ["nm-connection-editor"].concat(args)
        editor.running = true
    }

    readonly property Process query: Process {
        command: ["/usr/bin/python3", root.script, "list"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const result = JSON.parse(text)
                    if (result.error) {
                        root.error = result.error
                        root.profiles = []
                    } else {
                        root.profiles = result.profiles ?? []
                        root.version = result.version ?? ""
                    }
                } catch (_) {
                    root.error = "Cannot read VPN profiles. Install python-gobject and libnm; NetworkManager 1.40 or newer is required for WireGuard import."
                }
            }
        }
    }

    readonly property Process operation: Process {
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const result = JSON.parse(text)
                    root.error = result.error ?? ""
                    root.message = result.message ?? ""
                } catch (_) {
                    root.error = "VPN operation failed. Check that NetworkManager and its OpenVPN plugin are installed."
                }
            }
        }
        onExited: {
            root.busy = false
            root.refresh()
        }
    }

    readonly property Process editor: Process {
        onExited: (code, status) => {
            if (code !== 0)
                root.error = "Could not open NetworkManager's editor. Install nm-connection-editor and networkmanager-openvpn for OpenVPN forms."
            root.refresh()
        }
    }

    // Re-read authoritative state, including edits/activation outside Eclipse.
    // Keep polling while an editor window is open too: GTK may hand the request
    // to another process and return before the user saves it.
    readonly property Timer poll: Timer {
        interval: 2000
        running: root.watchers > 0
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}

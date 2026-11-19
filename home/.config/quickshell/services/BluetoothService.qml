// ╭──────────────────────────────────────────────────────────────────────────╮
// │                                                                          │
// │   B L U E T O O T H   S E R V I C E                                      │
// │   adapter state and what is connected to it                              │
// │                                                                          │
// │   github.com/andreumassanet/impasto                                      │
// │                                                                          │
// ╰──────────────────────────────────────────────────────────────────────────╯

pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Io

// The default adapter, flattened for the control centre.
//
// Power-on clears Bluetooth software rfkill blocks. Device status arrives over
// D-Bus; bluetui owns discovery, pairing, trust and advanced management.
Singleton {
    id: root

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property bool available: root.adapter !== null
    readonly property bool enabled: root.available && root.adapter.enabled
    readonly property bool blocked: root.available && root.adapter.state === BluetoothAdapterState.Blocked
    readonly property bool busy: root.powerProcess.running
    property string error: ""
    property var connectionDevice: null
    property bool connectionWanted: false

    // Everything BlueZ currently knows about, listed or not.
    readonly property var allDevices: {
        if (!root.available || !root.adapter.devices)
            return []
        return root.adapter.devices.values
    }

    readonly property var connectedDevices: root.allDevices.filter(device => device.connected)
    readonly property var listedDevices: root.listDevices(root.allDevices)

    function listDevices(devices: var): var {
        return devices.filter(device => device.paired || device.bonded || device.connected)
            .sort((a, b) => Number(b.connected) - Number(a.connected)
                || (a.name || a.address || "").localeCompare(b.name || b.address || ""))
    }

    function connecting(device: var): bool {
        return device.state === BluetoothDeviceState.Connecting
            || device.state === BluetoothDeviceState.Disconnecting
    }

    function deviceStatus(device: var): string {
        if (device.state === BluetoothDeviceState.Connecting)
            return "Connecting…"
        if (device.state === BluetoothDeviceState.Disconnecting)
            return "Disconnecting…"
        return device.connected ? "Connected" : "Paired · disconnected"
    }

    function toggleConnection(device: var): void {
        if (!device || !root.enabled || root.busy || root.connectionDevice !== null
                || root.connecting(device))
            return
        root.error = ""
        root.connectionWanted = !device.connected
        root.connectionDevice = device
        if (device.connected)
            device.disconnect()
        else if (device.paired || device.bonded)
            device.connect()
        Qt.callLater(root.finishConnection)
    }

    function finishConnection(): void {
        const device = root.connectionDevice
        if (!device || root.connecting(device))
            return
        if (device.connected !== root.connectionWanted)
            root.error = root.connectionWanted
                ? "Could not connect. Check the device is on and nearby, then retry or open Manage Bluetooth."
                : "Could not disconnect. Retry or open Manage Bluetooth."
        root.connectionDevice = null
    }

    readonly property Connections connectionState: Connections {
        target: root.connectionDevice
        function onStateChanged(): void { root.finishConnection() }
    }

    // A single device is named; several are counted.
    readonly property string summary: {
        if (!root.available)
            return "Unavailable"
        if (root.busy)
            return "Changing power…"
        if (root.blocked)
            return "Blocked"
        if (!root.enabled)
            return "Off"
        const connected = root.connectedDevices
        if (connected.length === 0)
            return "No devices"
        if (connected.length === 1)
            return connected[0].name
        return `${connected.length} devices`
    }

    readonly property string icon: {
        if (!root.available)
            return "󰂲"
        if (!root.enabled)
            return "󰂲"
        return root.connectedDevices.length > 0 ? "󰂱" : "󰂯"
    }


    function deviceIcon(device: var): string {
        switch (device.icon) {
        case "audio-headset":
        case "audio-headphones": return "󰋋"
        case "audio-card": return "󰓃"
        case "input-mouse": return "󰍽"
        case "input-keyboard": return "󰌌"
        case "phone": return "󰄜"
        case "computer": return "󰟀"
        default: return "󰂯"
        }
    }

    function manage(): void {
        Quickshell.execDetached(["kitty", "--title", "Bluetooth — bluetui", "bluetui"])
    }

    readonly property Process powerProcess: Process {
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const result = JSON.parse(text)
                    root.error = result.ok ? "" : result.error
                } catch (error) {
                    root.error = "Cannot read Bluetooth power result"
                }
            }
        }
        onExited: code => {
            if (code !== 0 && root.error === "")
                root.error = "Cannot change Bluetooth power"
        }
    }

    function toggle(): void {
        if (!root.available || root.busy)
            return
        root.error = ""
        root.powerProcess.command = ["python3", Quickshell.shellPath("scripts/bluetooth_power.py"),
            root.adapter.dbusPath, root.enabled ? "off" : "on"]
        root.powerProcess.running = true
    }
}

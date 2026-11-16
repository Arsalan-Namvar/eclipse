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
// Power-on also clears Bluetooth software rfkill blocks. Adapter/device state
// still arrives over D-Bus; scanning waits for power-on to complete.
Singleton {
    id: root

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property bool available: root.adapter !== null
    readonly property bool enabled: root.available && root.adapter.enabled
    readonly property bool blocked: root.available && root.adapter.state === BluetoothAdapterState.Blocked
    readonly property bool busy: root.powerProcess.running
    property string error: ""
    property bool discoveryRequested: false

    // Everything BlueZ currently knows about, listed or not.
    readonly property var allDevices: {
        if (!root.available || !root.adapter.devices)
            return []
        return root.adapter.devices.values
    }

    readonly property var connectedDevices: root.allDevices.filter(device => device.connected)

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

    // `name` is BlueZ's Alias, which falls back to the MAC address when the
    // device never advertised a name; `deviceName` is empty in that case.
    function isNamed(device: var): bool {
        return ((device.deviceName ?? "") + "").length > 0
    }

    // Named, paired, connected or pairing devices. Paired devices stay listed
    // whatever BlueZ has cached for their name.
    readonly property var devices: {
        const listed = root.allDevices.filter(device => root.isNamed(device)
            || device.paired || device.connected || device.pairing)
        // Connected first, then paired, then whatever else is in range.
        return listed.sort((a, b) => {
            if (a.connected !== b.connected) return a.connected ? -1 : 1
            if (a.paired !== b.paired) return a.paired ? -1 : 1
            return (a.name ?? "").localeCompare(b.name ?? "")
        })
    }

    // Everything else, shown in a collapsed second list.
    readonly property var unnamedDevices: {
        const rest = root.allDevices.filter(device => !(root.isNamed(device)
            || device.paired || device.connected || device.pairing))
        return rest.sort((a, b) => (a.address ?? "").localeCompare(b.address ?? ""))
    }

    readonly property int unnamedCount: root.unnamedDevices.length

    readonly property bool discovering: root.available && root.adapter.discovering

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

    // `connected` is writable on the device.
    function connectDevice(device: var): void {
        if (device)
            device.connected = !device.connected
    }

    function setDiscovering(on: bool): void {
        root.discoveryRequested = on
        root.syncDiscovery()
    }

    function syncDiscovery(): void {
        if (root.available && root.enabled && !root.busy)
            root.adapter.discovering = root.discoveryRequested
    }

    onEnabledChanged: root.syncDiscovery()
    onBusyChanged: root.syncDiscovery()

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

// Run against the real service with no reachable system bus.
import QtQuick
import Quickshell
import Quickshell.Bluetooth
import "services"
ShellRoot {
    QtObject {
        id: device
        property bool connected: false
        property int state: BluetoothDeviceState.Disconnected
    }
    Timer {
        interval: 1
        running: true
        function expect(condition, message) { if (!condition) throw new Error(message) }
        onTriggered: {
            try {
                const paired = {name: "Headphones", paired: true, bonded: true, connected: false,
                    state: BluetoothDeviceState.Disconnected}
                const unnamed = {address: "00:11:22:33:44:55", paired: false, bonded: true, connected: false}
                const connected = {name: "Speaker", connected: true, state: BluetoothDeviceState.Connected}
                const nearby = {name: "Unpaired nearby", paired: false, bonded: false, connected: false}
                const input = [paired, nearby, unnamed, connected]
                const listed = BluetoothService.listDevices(input)
                expect(listed.length === 3, "Paired or bonded disconnected device missing")
                expect(listed[0] === connected, "Connected device not first")
                expect(listed.indexOf(paired) >= 0 && listed.indexOf(unnamed) >= 0, "Saved devices filtered out")
                expect(listed.indexOf(nearby) === -1, "Unpaired discovery leaked into quick controls")
                expect(input[0] === paired, "Input model mutated by sorting")
                expect(BluetoothService.deviceStatus(paired) === "Paired · disconnected", "Disconnected pairing mislabeled")
                expect(BluetoothService.deviceStatus(connected) === "Connected", "Connected device mislabeled")
                for (const state of [BluetoothDeviceState.Connecting, BluetoothDeviceState.Disconnecting]) {
                    expect(BluetoothService.connecting({state: state}), "In-flight action not guarded")
                    expect(BluetoothService.deviceStatus({state: state}).endsWith("…"), "In-flight status missing")
                }
                expect(!BluetoothService.connecting(paired), "Disconnected device treated as busy")
                BluetoothService.connectionDevice = device
                BluetoothService.connectionWanted = true
                BluetoothService.finishConnection()
                expect(BluetoothService.error.indexOf("Could not connect") === 0, "Failed connection hidden")
                expect(BluetoothService.connectionDevice === null, "Failed action left controls locked")
                BluetoothService.error = ""
                BluetoothService.connectionDevice = device
                BluetoothService.connectionWanted = false
                BluetoothService.finishConnection()
                expect(BluetoothService.error === "", "Successful disconnect reported as failure")
                console.log("BLUETOOTH_DEVICES_PASSED")
                Qt.quit()
            } catch (error) { console.error(error); Qt.exit(1) }
        }
    }
}

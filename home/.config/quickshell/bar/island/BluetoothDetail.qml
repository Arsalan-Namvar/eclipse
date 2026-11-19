// ╭──────────────────────────────────────────────────────────────────────────╮
// │                                                                          │
// │   B L U E T O O T H   D E T A I L                                        │
// │   paired-device quick controls · management through bluetui              │
// │                                                                          │
// │   github.com/andreumassanet/impasto                                      │
// │                                                                          │
// ╰──────────────────────────────────────────────────────────────────────────╯

import QtQuick
import QtQuick.Layouts
import Quickshell

import "../../theme"
import "../../services"
import "../../components"

// Paired-device status and connection/power controls. bluetui owns discovery,
// pairing and advanced management; opening this panel does not change them.
ColumnLayout {
    id: root

    signal back()

    // No back arrow when opened from the bar, where there is nothing to go
    // back to.
    property bool backable: true


    spacing: Theme.cardGap


    // The heading a module's card has (`ModuleCard`), with the back arrow in
    // front of it when there is somewhere to go back to.
    RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: Theme.cardMark
        spacing: 12

        IconButton {
            icon: "󰅁"
            iconSize: 14
            visible: root.backable
            onClicked: root.back()
        }

        RingIndicator {
            Layout.preferredWidth: Theme.cardMark
            Layout.preferredHeight: Theme.cardMark
            thickness: 3
            progress: 0
            trackColor: Theme.indicatorDim

            Text {
                anchors.centerIn: parent
                text: BluetoothService.icon
                font.family: Theme.fontMono
                font.pixelSize: 18
                color: BluetoothService.enabled ? Theme.indicator : Theme.textMuted
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                Layout.fillWidth: true
                text: "Bluetooth"
                elide: Text.ElideRight
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.DemiBold
                color: Theme.text
            }

            Text {
                Layout.fillWidth: true
                text: BluetoothService.busy ? "Changing power…"
                    : BluetoothService.blocked ? "Radio blocked · turn on to unblock"
                    : BluetoothService.summary
                elide: Text.ElideRight
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.textMuted
            }
        }

        ToggleSwitch {
            checked: BluetoothService.enabled
            enabled: BluetoothService.available && !BluetoothService.busy
            onToggled: BluetoothService.toggle()
        }
    }

    Text {
        Layout.fillWidth: true
        visible: BluetoothService.error !== ""
        text: BluetoothService.error
        wrapMode: Text.WordWrap
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.red
    }

    PillButton {
        text: "Manage Bluetooth"
        icon: "󰆍"
        onClicked: BluetoothService.manage()
    }

    Text {
        Layout.fillWidth: true
        text: "Pair new devices, change trust, rename or forget devices in bluetui. Opens in Kitty."
        wrapMode: Text.WordWrap
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.textMuted
    }


    Text {
        Layout.fillWidth: true
        Layout.fillHeight: true
        visible: BluetoothService.listedDevices.length === 0
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: BluetoothService.enabled ? "No paired devices · add one in Manage Bluetooth" : "Bluetooth is off"
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.textMuted
    }

    ListView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        visible: BluetoothService.listedDevices.length > 0
        clip: true
        spacing: 4
        model: ScriptModel {
            values: BluetoothService.listedDevices
            comparisonMode: ObjectComparison.Identity
        }
        boundsBehavior: Flickable.StopAtBounds

        delegate: Rectangle {
            id: entry

            required property var modelData

            width: ListView.view.width
            height: 48
            radius: Theme.radiusMedium
            color: Theme.surfaceIn(QsWindow.window)
            border.color: entry.modelData.connected ? Theme.accent : Theme.borderIn(QsWindow.window)
            border.width: 1

            Behavior on color { ColorAnimation { duration: Theme.durationFast } }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: connectionButton.width + 20
                spacing: 10

                Text {
                    text: BluetoothService.deviceIcon(entry.modelData)
                    font.family: Theme.fontMono
                    font.pixelSize: 15
                    color: entry.modelData.connected ? Theme.accent : Theme.textMuted
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Text {
                        Layout.fillWidth: true
                        text: entry.modelData.name || entry.modelData.address
                        elide: Text.ElideRight
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        font.weight: entry.modelData.connected ? Font.DemiBold : Font.Normal
                        color: entry.modelData.connected ? Theme.accent : Theme.text
                    }

                    Text {
                        Layout.fillWidth: true
                        text: {
                            const bits = [BluetoothService.deviceStatus(entry.modelData)]
                            if (entry.modelData.connected && entry.modelData.batteryAvailable)
                                bits.push(`${Math.round(entry.modelData.battery * 100)}%`)
                            return bits.join(" · ")
                        }
                        elide: Text.ElideRight
                        font.family: Theme.fontFamily
                        font.pixelSize: 9
                        color: Theme.textMuted
                    }
                }

                Text {
                    visible: entry.modelData.connected
                    text: "󰄬"
                    font.family: Theme.fontMono
                    font.pixelSize: 13
                    color: Theme.accent
                }
            }

            PillButton {
                id: connectionButton
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                text: BluetoothService.connecting(entry.modelData) ? "Working…"
                    : entry.modelData.connected ? "Disconnect" : "Connect"
                enabled: BluetoothService.enabled && !BluetoothService.busy
                    && BluetoothService.connectionDevice === null
                    && !BluetoothService.connecting(entry.modelData)
                onClicked: BluetoothService.toggleConnection(entry.modelData)
            }


        }
    }

}

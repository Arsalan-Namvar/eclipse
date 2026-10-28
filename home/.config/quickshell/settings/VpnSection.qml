import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import Quickshell

import "../theme"
import "../services"
import "../components"

SettingsSection {
    id: root
    property string pendingDelete: ""

    Component.onCompleted: {
        VpnService.watchers++
        VpnService.refresh()
    }
    Component.onDestruction: VpnService.watchers--

    Text {
        Layout.fillWidth: true
        text: "VPN profiles belong to NetworkManager. Import here, or open its full manual editor in a separate window. Saved changes appear here automatically."
        wrapMode: Text.WordWrap
        color: Theme.text
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
    }

    Repeater {
        model: [
            { key: "openvpn", label: "OpenVPN", hint: "Manual editor: gateway; TLS certificates, password, password + TLS or static key authentication; proxy, TLS/cipher and IPv4/IPv6 routes/DNS in Advanced and IP tabs." },
            { key: "wireguard", label: "WireGuard", hint: "Manual editor: interface/private key, addresses, peers/public key, endpoint, allowed IPs, optional preshared key and keepalive; routing table, MTU and DNS in the WireGuard and IP tabs." }
        ]
        delegate: ColumnLayout {
            required property var modelData
            Layout.fillWidth: true
            spacing: 8
            Text {
                text: modelData.label
                color: Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.DemiBold
            }
            Text {
                Layout.fillWidth: true
                text: modelData.hint
                wrapMode: Text.WordWrap
                color: Theme.textMuted
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
            }
            RowLayout {
                PillButton {
                    text: "Import configuration…"
                    enabled: !VpnService.busy
                    onClicked: {
                        picker.protocol = modelData.key
                        picker.nameFilters = modelData.key === "openvpn" ? ["OpenVPN (*.ovpn)", "All files (*)"] : ["WireGuard (*.conf)"]
                        picker.open()
                    }
                }
                PillButton {
                    text: "Manual setup · external editor…"
                    onClicked: VpnService.create(modelData.key)
                }
            }
        }
    }

    Text {
        Layout.fillWidth: true
        text: "Import does not connect or enable automatic connection. Unsupported options and executable hooks are rejected, not silently dropped. WireGuard files must use a valid interface filename (for example wg0.conf). Original files stay unchanged. Review full/split routes, allowed IPs and DNS before connecting."
        wrapMode: Text.WordWrap
        color: Theme.textMuted
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
    }
    Text {
        Layout.fillWidth: true
        text: "Secrets use NetworkManager's supported storage choices, not Eclipse settings. WireGuard private/preshared keys may be stored in NetworkManager's root-only keyfile; OpenVPN inline keys are extracted into restricted NetworkManager certificate files. Keep original imports and external key files secure. In the editor choose ask every time or a session secret agent when appropriate. Connect opens Kitty with nmcli's secure, non-echoing password prompt; passwords are never command arguments or shell logs."
        wrapMode: Text.WordWrap
        color: Theme.textMuted
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
    }

    RowLayout {
        Layout.fillWidth: true
        Text {
            Layout.fillWidth: true
            text: "Saved tunnels" + (VpnService.version ? " · NetworkManager " + VpnService.version : "")
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeMedium
            font.weight: Font.DemiBold
        }
        PillButton { text: "Refresh"; onClicked: VpnService.refresh() }
    }
    Text {
        Layout.fillWidth: true
        visible: VpnService.profiles.length === 0
        text: "No accessible OpenVPN or WireGuard profiles. Profiles created outside Eclipse appear here too."
        wrapMode: Text.WordWrap
        color: Theme.textMuted
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
    }
    Repeater {
        model: VpnService.profiles
        delegate: ColumnLayout {
            required property var modelData
            Layout.fillWidth: true
            spacing: 8
            Text {
                Layout.fillWidth: true
                text: modelData.name + " · " + modelData.protocol + " · " + modelData.state
                elide: Text.ElideRight
                color: modelData.active ? Theme.accent : Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
            }
            RowLayout {
                PillButton {
                    text: modelData.engaged ? "Disconnect / cancel" : "Connect · terminal prompt"
                    enabled: !VpnService.busy
                    onClicked: modelData.engaged ? VpnService.disconnect(modelData.uuid) : VpnService.connect(modelData.uuid)
                }
                PillButton { text: "Edit…"; onClicked: VpnService.edit(modelData.uuid) }
                PillButton {
                    text: "Delete…"
                    enabled: !modelData.engaged && !VpnService.busy
                    onClicked: root.pendingDelete = modelData.uuid
                }
            }
            RowLayout {
                visible: root.pendingDelete === modelData.uuid
                Text {
                    text: "Permanently delete this NetworkManager profile?"
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                }
                PillButton {
                    text: "Delete profile"
                    enabled: !VpnService.busy
                    onClicked: {
                        VpnService.remove(modelData.uuid)
                        root.pendingDelete = ""
                    }
                }
                PillButton { text: "Cancel"; onClicked: root.pendingDelete = "" }
            }
        }
    }
    Text {
        Layout.fillWidth: true
        visible: VpnService.error !== "" || VpnService.message !== "" || VpnService.busy
        text: VpnService.busy ? "Working…" : (VpnService.error || VpnService.message)
        wrapMode: Text.WordWrap
        color: VpnService.error ? Theme.accent : Theme.textMuted
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
    }
    Text {
        Layout.fillWidth: true
        text: "Active means NetworkManager activated the profile, not verified traffic, DNS, leak protection or a WireGuard peer handshake. VPN controls also live in the island's Network panel and work over Ethernet with Wi-Fi off."
        wrapMode: Text.WordWrap
        color: Theme.textMuted
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
    }

    FileDialog {
        id: picker
        property string protocol: "openvpn"
        title: "Import VPN configuration"
        fileMode: FileDialog.OpenFile
        onAccepted: {
            const url = String(picker.selectedFile)
            if (url.startsWith("file://"))
                VpnService.importProfile(picker.protocol, decodeURIComponent(url.slice(7)))
        }
    }
}

import QtQuick
import QtQuick.Layouts
import Quickshell

import "../../theme"
import "../../services"
import "../../components"

ColumnLayout {
    id: root

    spacing: 12
    implicitWidth: OmpService.panelWidth - 2 * Theme.panelPadding
    readonly property var session: OmpService.selected
    readonly property bool historical: OmpService.state === "ended" || OmpService.state === "disconnected"
    readonly property bool contextKnown: root.session?.context?.percent !== null
        && root.session?.context?.percent !== undefined
    Component.onCompleted: OmpService.subscribe()
    Component.onDestruction: OmpService.release()

    function stateColor(state: string): color {
        return state === "working" ? Theme.accent : state === "idle" ? Theme.green : Theme.textMuted
    }
    function projectName(path: string): string {
        return path.replace(/\/$/, "").split("/").pop() || path
    }


    RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: 36
        spacing: 8
        OmpLabel { text: "󰚩"; color: Theme.accent; font.family: Theme.fontMono; font.pixelSize: 22 }
        OmpLabel {
            text: "Oh My Pi"
            color: Theme.text
            font.pixelSize: Theme.fontSizeLarge
            font.weight: Font.DemiBold
            Layout.fillWidth: true
        }
        PillButton { text: "Launch"; icon: "󰐕"; onClicked: OmpService.launch() }
        IconButton { icon: "󰑐"; onClicked: OmpService.refresh() }
    }

    OmpLabel {
        Layout.fillWidth: true
        visible: OmpService.error !== ""
        text: OmpService.error
        color: Theme.red
        wrapMode: Text.WordWrap
    }

    Flickable {
        visible: OmpService.sessions.length > 0
        Layout.fillWidth: true
        Layout.preferredHeight: OmpService.sessionListHeight
        contentHeight: sessionList.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        ColumnLayout {
            id: sessionList
            width: parent.width
            spacing: 6
            Repeater {
                model: OmpService.sessions
                Rectangle {
                    id: option
                    required property var modelData
                    readonly property bool picked: OmpService.selectedId === option.modelData.id
                    Layout.fillWidth: true
                    Layout.preferredHeight: 54
                    radius: Theme.radiusSmall
                    color: option.picked ? Qt.alpha(Theme.accent, .14)
                        : press.containsMouse ? Theme.surfaceHoverIn(QsWindow.window) : Theme.surfaceIn(QsWindow.window)
                    border.width: 1
                    border.color: option.picked ? Theme.accent : Theme.borderIn(QsWindow.window)
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10
                        Rectangle { width: 6; height: 6; radius: 3; color: root.stateColor(option.modelData.state) }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            OmpLabel {
                                Layout.fillWidth: true
                                text: option.modelData.name || "Untitled session"
                                color: Theme.text
                                font.weight: option.picked ? Font.DemiBold : Font.Normal
                            }
                            OmpLabel {
                                Layout.fillWidth: true
                                text: root.projectName(option.modelData.project) + " · " + option.modelData.sessionId.slice(0, 8)
                                font.pixelSize: Theme.fontSizeLabel
                            }
                        }
                        OmpLabel { text: option.modelData.state; color: root.stateColor(option.modelData.state) }
                    }
                    MouseArea {
                        id: press
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: OmpService.select(option.modelData.id)
                    }
                }
            }
        }
    }

    ColumnLayout {
        visible: root.session === null
        Layout.fillWidth: true
        spacing: 6
        OmpLabel {
            Layout.fillWidth: true
            text: OmpService.sessions.length ? "Select a session" : "No connected sessions"
            color: Theme.text
            font.pixelSize: Theme.fontSizeMedium
            font.weight: Font.DemiBold
        }
        OmpLabel {
            Layout.fillWidth: true
            text: OmpService.sessions.length ? "Your selection stays put when terminal focus changes."
                : "Launch OMP in ~/Work. Local session status appears here; choose a session to inspect it."
            wrapMode: Text.WordWrap
        }
    }

    ColumnLayout {
        visible: root.session !== null
        Layout.fillWidth: true
        spacing: 10
        RowLayout {
            Layout.fillWidth: true
            OmpLabel {
                Layout.fillWidth: true
                text: root.session?.name || "Untitled session"
                color: Theme.text
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.DemiBold
            }
            OmpLabel { text: OmpService.state; color: root.stateColor(OmpService.state) }
        }
        OmpLabel {
            Layout.fillWidth: true
            text: root.session?.project ?? ""
            elide: Text.ElideMiddle
            font.family: Theme.fontMono
        }
        OmpLabel {
            Layout.fillWidth: true
            text: (root.session?.provider || "Provider unavailable") + " / " + (root.session?.model || "Model unavailable")
        }
        Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: Theme.borderIn(QsWindow.window) }
        RowLayout {
            Layout.fillWidth: true
            OmpLabel { text: "Context estimate"; Layout.fillWidth: true }
            OmpLabel {
                text: root.contextKnown ? root.session.context.percent.toFixed(1) + "%" : "Unavailable"
                color: root.contextKnown ? Theme.accent : Theme.textMuted
                font.family: Theme.fontMono
            }
        }
        UsageBar { Layout.fillWidth: true; visible: root.contextKnown; progress: OmpService.contextFraction }
        OmpLabel {
            Layout.fillWidth: true
            text: root.contextKnown ? OmpService.count(root.session.context.tokens) + " / " + OmpService.count(root.session.context.window) + " tokens"
                : "OMP has not reported a context capacity."
            font.pixelSize: Theme.fontSizeLabel
        }
        GridLayout {
            Layout.fillWidth: true
            columns: 3
            columnSpacing: 12
            rowSpacing: 10
            OmpMetric { label: "Session tokens"; value: OmpService.count(root.session?.tokens) }
            OmpMetric { label: "Input / output"; value: OmpService.count(root.session?.input) + " / " + OmpService.count(root.session?.output) }
            OmpMetric { label: "Cost estimate · USD"; value: typeof root.session?.cost === "number" ? "$" + root.session.cost.toFixed(4) : "Unavailable" }
            OmpMetric { label: "Cache read"; value: OmpService.count(root.session?.cacheRead) }
            OmpMetric { label: "Cache write"; value: OmpService.count(root.session?.cacheWrite) }
            OmpMetric { label: "Last observed"; value: root.session ? Qt.formatDateTime(new Date(root.session.observed), "HH:mm:ss") : "Unavailable" }
        }
        OmpLabel {
            Layout.fillWidth: true
            text: root.historical ? "Last observation · this session is " + OmpService.state + ". No replacement selected."
                : "Session counters and estimates—not account limits or billing."
            wrapMode: Text.WordWrap
            color: root.historical ? Theme.accent : Theme.textMuted
            font.pixelSize: Theme.fontSizeLabel
        }
    }

    Item { Layout.fillHeight: true }
}

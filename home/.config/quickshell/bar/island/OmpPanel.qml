import QtQuick
import QtQuick.Layouts

import "../../theme"
import "../../services"
import "../../components"

ColumnLayout {
    id: root

    spacing: Theme.detailGap
    implicitWidth: 520
    Component.onCompleted: OmpService.subscribe()
    Component.onDestruction: OmpService.release()

    RowLayout {
        Layout.fillWidth: true
        Text {
            text: "Oh My Pi"
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeLarge
            font.weight: Font.DemiBold
            Layout.fillWidth: true
        }
        PillButton { text: "Launch in ~/Work"; onClicked: OmpService.launch() }
        PillButton { text: "Refresh"; onClicked: OmpService.refresh() }
    }

    Text {
        Layout.fillWidth: true
        text: "Choose one session. Selection never follows terminal focus or the newest session."
        wrapMode: Text.WordWrap
        color: Theme.textMuted
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
    }

    Flickable {
        Layout.fillWidth: true
        implicitHeight: Math.min(180, sessionList.implicitHeight)
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
                    Layout.fillWidth: true
                    implicitHeight: sessionLabel.implicitHeight + 16
                    radius: Theme.radiusSmall
                    color: OmpService.selectedId === option.modelData.id ? Theme.accent : Theme.surface
                    Text {
                        id: sessionLabel
                        anchors.fill: parent
                        anchors.margins: 8
                        text: `${option.modelData.name} · ${option.modelData.state}\n${option.modelData.project} · ${option.modelData.sessionId.slice(0, 8)}`
                        textFormat: Text.PlainText
                        wrapMode: Text.WrapAnywhere
                        color: OmpService.selectedId === option.modelData.id ? Theme.accentText : Theme.text
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: OmpService.select(option.modelData.id)
                    }
                }
            }
        }
    }

    Text {
        Layout.fillWidth: true
        visible: OmpService.sessions.length === 0 || OmpService.error !== ""
        text: OmpService.error || "No desktop-connected OMP sessions. Launch OMP above; the Eclipse extension publishes local status only."
        wrapMode: Text.WordWrap
        color: Theme.textMuted
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
    }

    Text {
        Layout.fillWidth: true
        visible: OmpService.selectedId !== ""
        text: OmpService.selected ? `${OmpService.selected.name}\n${OmpService.selected.project}\n${OmpService.selected.sessionId}\nStatus: ${OmpService.state}` : ""
        textFormat: Text.PlainText
        wrapMode: Text.WrapAnywhere
        color: Theme.text
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeRegular
    }

    Text {
        Layout.fillWidth: true
        visible: OmpService.selected !== null
        readonly property var session: OmpService.selected
        text: !session ? "" : [
            `Model: ${session.provider ?? "Unavailable"} / ${session.model ?? "Unavailable"}`,
            `Session tokens: ${OmpService.count(session.tokens)}`,
            `Input ${OmpService.count(session.input)} · Output ${OmpService.count(session.output)}`,
            `Cache read ${OmpService.count(session.cacheRead)} · Cache write ${OmpService.count(session.cacheWrite)}`,
            session.context ? `Context estimate: ${OmpService.count(session.context.tokens)} / ${OmpService.count(session.context.window)} (${session.context.percent === null ? "Unavailable" : session.context.percent.toFixed(1) + "%"})` : "Context estimate: Unavailable",
            typeof session.cost === "number" ? `OMP session cost estimate: $${session.cost.toFixed(4)} USD` : "Session cost estimate: Unavailable",
            `Last update: ${Qt.formatDateTime(new Date(session.observed), "ddd d MMM HH:mm:ss")}`
        ].join("\n")
        wrapMode: Text.WordWrap
        color: Theme.textMuted
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
        lineHeight: 1.25
    }

    Text {
        Layout.fillWidth: true
        text: "Tokens and cost are OMP's session counters, not account limits or a bill. Context is OMP's estimate. Ended/disconnected figures are the last observation; no replacement session is selected."
        wrapMode: Text.WordWrap
        color: Theme.textMuted
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
    }
}

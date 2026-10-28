// ╭──────────────────────────────────────────────────────────────────────────╮
// │                                                                          │
// │   L A Y O U T   P I C K E R                                              │
// │   every keyboard layout X knows, and the order they are loaded in        │
// │                                                                          │
// │   github.com/andreumassanet/impasto                                      │
// │                                                                          │
// ╰──────────────────────────────────────────────────────────────────────────╯

import QtQuick
import QtQuick.Layouts
import Quickshell

import "../theme"
import "../services"
import "../components"

// Hyprland passes the comma-separated list to xkb, which loads the layouts as
// groups in order: the first is the starting layout and the switch key cycles
// through the rest. Shows only the chosen layouts until Edit is pressed.
Rectangle {
    id: root

    // XKB lists are positional; an empty variant still occupies a slot.
    property string current: ""
    property string variants: ""

    property bool expanded: false

    signal changed(string layouts, string variants)

    readonly property var chosen: {
        const variants = root.variants.split(",")
        return root.current.split(",").map((id, index) =>
            ({ id: id.trim(), variant: (variants[index] ?? "").trim() }))
            .filter(entry => entry.id !== "")
    }

    property string filter: ""

    readonly property var matches: {
        const term = root.filter.trim().toLowerCase()
        if (term === "")
            return CompositorService.layouts
        return CompositorService.layouts.filter(
            entry => entry.label.toLowerCase().includes(term)
                || entry.id.toLowerCase().includes(term)
                || entry.variant.toLowerCase().includes(term))
    }

    function selected(id: string, variant: string): int {
        return root.chosen.findIndex(entry => entry.id === id && entry.variant === variant)
    }

    function save(next: var): void {
        root.changed(next.map(entry => entry.id).join(","),
            next.map(entry => entry.variant).join(","))
    }

    function toggle(id: string, variant: string): void {
        const next = root.chosen.slice()
        const at = root.selected(id, variant)
        if (at >= 0) {
            if (next.length === 1)
                return
            next.splice(at, 1)
        } else {
            next.push({ id: id, variant: variant })
        }
        root.save(next)
    }

    function move(index: int, direction: int): void {
        const next = root.chosen.slice()
        const target = index + direction
        if (target < 0 || target >= next.length)
            return
        const entry = next.splice(index, 1)[0]
        next.splice(target, 0, entry)
        root.save(next)
    }

    // Sits in a `SettingGroup`'s card, padded like its rows.
    Layout.fillWidth: true
    implicitHeight: body.implicitHeight + 28
    color: "transparent"

    Behavior on implicitHeight {
        NumberAnimation { duration: Theme.durationFast; easing.type: Theme.easing }
    }

    ColumnLayout {
        id: body

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 14
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: Tr.t("Layouts, in order")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.DemiBold
                color: Theme.text
            }

            Text {
                visible: root.chosen.length > 1
                text: Tr.t("· the first is the one you start on")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeLabel
                color: Theme.textMuted
            }

            Item { Layout.fillWidth: true }

            PillButton {
                text: root.expanded ? Tr.t("Done") : Tr.t("Edit")
                icon: root.expanded ? "󰄬" : "󰐕"
                implicitWidth: 76
                implicitHeight: 26
                active: root.expanded
                onClicked: {
                    root.expanded = !root.expanded
                    if (root.expanded)
                        search.forceActiveFocus()
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            Repeater {
                model: root.chosen

                RowLayout {
                    id: chip

                    required property var modelData
                    required property int index

                    Layout.fillWidth: true
                    spacing: 6

                    Text {
                        Layout.fillWidth: true
                        text: (chip.index + 1) + ". " + CompositorService.labelForLayout(
                            chip.modelData.id, chip.modelData.variant)
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeLabel
                        color: chip.index === 0 ? Theme.accent : Theme.text
                        elide: Text.ElideRight
                    }

                    PillButton {
                        visible: root.expanded
                        text: "↑"
                        enabled: chip.index > 0
                        implicitWidth: 32
                        implicitHeight: 26
                        onClicked: root.move(chip.index, -1)
                    }

                    PillButton {
                        visible: root.expanded
                        text: "↓"
                        enabled: chip.index < root.chosen.length - 1
                        implicitWidth: 32
                        implicitHeight: 26
                        onClicked: root.move(chip.index, 1)
                    }

                    PillButton {
                        visible: root.expanded
                        text: "×"
                        enabled: root.chosen.length > 1
                        implicitWidth: 32
                        implicitHeight: 26
                        onClicked: root.toggle(chip.modelData.id, chip.modelData.variant)
                    }
                }
            }
        }

        Rectangle {
            visible: root.expanded
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            radius: Theme.radiusSmall
            color: Theme.island
            border.color: search.activeFocus ? Theme.accent : Theme.islandBorder
            border.width: 1

            Behavior on border.color { ColorAnimation { duration: Theme.durationFast } }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 9
                anchors.rightMargin: 9
                spacing: 8

                Text {
                    text: "󰍉"
                    font.family: Theme.fontMono
                    font.pixelSize: 12
                    color: Theme.textMuted
                }

                TextInput {
                    id: search

                    Layout.fillWidth: true
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.text
                    selectByMouse: true
                    selectionColor: Theme.accent
                    selectedTextColor: Theme.accentText
                    clip: true

                    onTextEdited: root.filter = text
                    Keys.onEscapePressed: { search.text = ""; root.filter = "" }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        visible: search.text === ""
                        text: Tr.t("Search {} layouts")
                            .replace("{}", CompositorService.layouts.length)
                        font: search.font
                        color: Theme.textMuted
                    }
                }
            }
        }

        ListView {
            visible: root.expanded
            Layout.fillWidth: true
            Layout.preferredHeight: root.expanded ? 220 : 0
            clip: true
            spacing: 1
            model: ScriptModel {
                values: root.matches
            }
            boundsBehavior: Flickable.StopAtBounds

            delegate: Rectangle {
                id: row

                required property var modelData
                readonly property bool taken: root.selected(row.modelData.id, row.modelData.variant) >= 0

                width: ListView.view.width
                height: 28
                radius: Theme.radiusSmall - 2
                color: rowMouse.containsMouse ? Theme.islandSurfaceHover : Qt.alpha(Theme.islandSurfaceHover, 0)

                Behavior on color { ColorAnimation { duration: Theme.durationFast } }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 9
                    anchors.rightMargin: 9
                    spacing: 10

                    Text {
                        text: row.taken ? "󰄬" : "󰝦"
                        font.family: Theme.fontMono
                        font.pixelSize: 11
                        color: row.taken ? Theme.accent : Theme.islandBorder
                    }

                    Text {
                        Layout.fillWidth: true
                        text: row.modelData.label
                        elide: Text.ElideRight
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        font.weight: row.taken ? Font.DemiBold : Font.Normal
                        color: row.taken ? Theme.accent : Theme.text
                    }

                    Text {
                        text: row.modelData.id + (row.modelData.variant ? ":" + row.modelData.variant : "")
                        font.family: Theme.fontMono
                        font.pixelSize: Theme.fontSizeLabel
                        color: Theme.textMuted
                    }
                }

                MouseArea {
                    id: rowMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.toggle(row.modelData.id, row.modelData.variant)
                }
            }
        }
    }
}

// Configuration for the two retained screen-edge surfaces.
import QtQuick
import Quickshell
import Quickshell.Widgets
import "../theme"
import "../services"
import "../components"
Item {
    id: root
    required property Item board
    readonly property string key: DesktopService.selected
    readonly property var row: DesktopService.entryOf(root.key)
    readonly property bool deck: DesktopService.isDeck(root.row)
    readonly property bool onSpectrum: DesktopService.isSpectrum(root.row)
    readonly property bool strip: root.onSpectrum
    readonly property var looks: DesktopService.spectrumOf(root.row)
    implicitHeight: column.implicitHeight
    Column {
        id: column
        width: parent.width
        spacing: 12
        Row {
            spacing: 12
            Heading { text: root.deck ? Tr.t("Notes on the edge") : Tr.t("Spectrum") }
            PillButton { text: Tr.t("Remove"); onClicked: DesktopService.remove(root.key) }
        }
        Row {
            spacing: 8
            Repeater {
                model: DesktopService.edges
                PillButton {
                    required property string modelData
                    text: Tr.t(modelData)
                    enabled: root.row && (root.deck || DesktopService.spectrumTakes(DesktopService.nameOf(root.row), modelData))
                    onClicked: {
                        const name = DesktopService.nameOf(root.row)
                        if (root.deck) DesktopService.setDeckEdge(root.key, name, modelData)
                        else DesktopService.setSpectrumEdge(root.key, name, modelData)
                    }
                }
            }
        }
            Heading {
                visible: root.onSpectrum
                text: Tr.t("Look")
            }

            Row {
                visible: root.onSpectrum
                spacing: 6

                Repeater {
                    model: root.onSpectrum ? DesktopService.spectrumLooks : []

                    SpectrumTile {
                        required property var modelData

                        current: root.looks.look === modelData.id
                        look: modelData.id
                        onChosen: DesktopService.setSpectrum(root.key, { look: modelData.id })
                    }
                }
            }

            Heading {
                visible: root.onSpectrum
                text: Tr.t("Fill")
            }

            Row {
                visible: root.onSpectrum
                spacing: 6

                Repeater {
                    model: root.onSpectrum ? DesktopService.spectrumFills : []

                    SpectrumTile {
                        required property var modelData

                        current: root.looks.fill === modelData.id
                        fillStyle: modelData.id
                        onChosen: DesktopService.setSpectrum(root.key, { fill: modelData.id })
                    }
                }
            }

            Text {
                visible: root.onSpectrum
                width: parent.width
                text: {
                    const look = DesktopService.spectrumLooks.find(entry => entry.id === root.looks.look)
                    const fill = DesktopService.spectrumFills.find(entry => entry.id === root.looks.fill)
                    return [look, fill].filter(entry => entry).map(entry => Tr.t(entry.label)).join(" · ")
                }
                elide: Text.ElideRight
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeLabel
                color: Theme.textMuted
            }

            Heading {
                visible: root.onSpectrum
                text: root.looks.fill === "blend" ? Tr.t("From the edge") : Tr.t("Colour")
            }

            ColourRow {
                visible: root.onSpectrum
                field: "color"
            }

            Heading {
                visible: root.onSpectrum && root.looks.fill === "blend"
                text: Tr.t("To the tip")
            }

            ColourRow {
                visible: root.onSpectrum && root.looks.fill === "blend"
                field: "color2"
            }

            Heading {
                visible: root.onSpectrum
                text: Tr.t("Size")
            }

            Measure {
                visible: root.strip
                label: Tr.t("Height")
                field: "reach"
            }

            Measure {
                visible: root.onSpectrum
                label: Tr.t("Bars")
                field: "bar"
            }

            Measure {
                visible: root.onSpectrum
                label: Tr.t("Gap")
                field: "gap"
            }

            Heading {
                visible: root.onSpectrum
                text: Tr.t("Lows")
            }

            Row {
                visible: root.onSpectrum
                spacing: 8

                Repeater {
                    model: root.onSpectrum ? [
                        { id: "corners", label: Tr.t("At the corners") },
                        { id: "along", label: Tr.t("Along the edge") }
                    ] : []

                    Rectangle {
                        id: lowsTile

                        required property var modelData

                        readonly property bool current: root.looks.lows === lowsTile.modelData.id

                        width: 138
                        height: 34
                        radius: Theme.radiusSmall
                        color: lowsTile.current ? Theme.surfaceHoverIn(QsWindow.window) : "transparent"
                        border.color: lowsTile.current ? Theme.accent : Theme.hairline
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: lowsTile.modelData.label
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeLabel
                            color: lowsTile.current ? Theme.text : Theme.textMuted
                        }

                        HoverHandler { cursorShape: Qt.PointingHandCursor }

                        TapHandler {
                            gesturePolicy: TapHandler.ReleaseWithinBounds
                            onTapped: DesktopService.setSpectrum(root.key, { lows: lowsTile.modelData.id })
                        }
                    }
                }
            }

            Item {
                visible: root.onSpectrum
                width: parent.width
                height: 28

                Heading {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: Tr.t("Peaks")
                }

                ToggleSwitch {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    checked: root.looks.peaks
                    onToggled: checked => DesktopService.setSpectrum(root.key, { peaks: checked })
                }
            }

            SliderRow {
                visible: root.onSpectrum
                width: parent.width
                height: 34
                icon: "󰊸"
                value: root.looks.opacity
                from: DesktopService.spectrumRanges.opacity.from
                to: DesktopService.spectrumRanges.opacity.to
                onMoved: value => DesktopService.setSpectrum(root.key, { opacity: value })
            }

            // ── ALIGNMENT ───────────────────────────────────────────────────
            //
            // For a deck: the start, centre or end of its edge. Finer placement
            // is the grip before the first tab.

            Text {
                visible: root.deck
                text: Tr.t("Along the edge")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeLabel
                font.weight: Font.DemiBold
                color: Theme.textMuted
            }

            Row {
                visible: root.deck
                spacing: 8

                Repeater {
                    model: root.deck ? [
                        { value: 0, label: Tr.t("Start") },
                        { value: 0.5, label: Tr.t("Middle") },
                        { value: 1, label: Tr.t("End") }
                    ] : []

                    Rectangle {
                        id: alongTile

                        required property var modelData

                        readonly property bool current: root.deck
                            && Math.abs(DesktopService.alongOf(root.row) - alongTile.modelData.value) < 0.01

                        width: 64
                        height: 30
                        radius: Theme.radiusSmall
                        color: alongTile.current ? Theme.surfaceHoverIn(QsWindow.window) : "transparent"
                        border.color: alongTile.current ? Theme.accent : Theme.hairline
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: alongTile.modelData.label
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeLabel
                            color: alongTile.current ? Theme.text : Theme.textMuted
                        }

                        HoverHandler { cursorShape: Qt.PointingHandCursor }

                        TapHandler {
                            gesturePolicy: TapHandler.ReleaseWithinBounds
                            onTapped: DesktopService.setDeckAlong(root.key, alongTile.modelData.value)
                        }
                    }
                }
            }

            // ── NOTES ───────────────────────────────────────────────────────
            //
            // For a deck: every note, ticked on or off this edge, in the order
            // ticked. Ticking a note here moves it from wherever it was.

            Item {
                visible: root.deck
                width: parent.width
                height: 28

                Heading {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: Tr.t("New notes land here")
                }

                ToggleSwitch {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    checked: root.deck && root.row.takesNew === true
                    onToggled: checked => DesktopService.setTakesNew(root.key, checked)
                }
            }

            Text {
                visible: root.deck
                text: Tr.t("Which notes")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeLabel
                font.weight: Font.DemiBold
                color: Theme.textMuted
            }

            Column {
                visible: root.deck
                width: parent.width
                spacing: 4

                Repeater {
                    model: ScriptModel {
                        values: root.deck ? NotesService.live : []
                        objectProp: "key"
                    }

                    Rectangle {
                        id: tickRow

                        required property var modelData

                        readonly property bool on: root.deck
                            && DesktopService.deckNotes(root.row).indexOf(tickRow.modelData.key) >= 0
                        readonly property string elsewhere: {
                            const place = DesktopService.placementOf(tickRow.modelData.key)
                            return tickRow.on || place === "" ? "" : place
                        }

                        width: parent.width
                        height: 26
                        radius: Theme.radiusSmall
                        color: tickHover.hovered ? Theme.surfaceHoverIn(QsWindow.window) : Qt.alpha(Theme.surfaceHoverIn(QsWindow.window), 0)

                        Row {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 6
                            anchors.rightMargin: 6
                            spacing: 8

                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                width: 14
                                height: 14
                                radius: 4
                                color: tickRow.on ? Theme.accent : "transparent"
                                border.color: tickRow.on ? Theme.accent : Theme.textMuted
                                border.width: 1.5

                                Text {
                                    anchors.centerIn: parent
                                    visible: tickRow.on
                                    text: "󰄬"
                                    font.family: Theme.fontMono
                                    font.pixelSize: 9
                                    color: Theme.accentText
                                }
                            }

                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                width: 8
                                height: 8
                                radius: 4
                                color: NotesService.tintColor(tickRow.modelData.tint)
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 30 - (elsewhereMark.visible ? elsewhereMark.width + 8 : 0)
                                text: NotesService.titleOf(tickRow.modelData)
                                elide: Text.ElideRight
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeLabel
                                color: tickRow.on ? Theme.text : Theme.textMuted
                            }

                            Text {
                                id: elsewhereMark

                                anchors.verticalCenter: parent.verticalCenter
                                visible: tickRow.elsewhere !== ""
                                text: "󰞘"
                                font.family: Theme.fontMono
                                font.pixelSize: 10
                                color: Theme.textMuted
                            }
                        }

                        HoverHandler { id: tickHover; cursorShape: Qt.PointingHandCursor }

                        TapHandler {
                            gesturePolicy: TapHandler.ReleaseWithinBounds
                            onTapped: DesktopService.toggleDeckNote(root.key, tickRow.modelData.key)
                        }
                    }
                }
            }
    }
    component Heading: Text {
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeLabel
        font.weight: Font.DemiBold
        color: Theme.textMuted
    }

    // This strip with one thing changed, as a tile.
    component SpectrumTile: Rectangle {
        id: tile

        property bool current: false
        property string look: root.looks.look
        property string fillStyle: root.looks.fill

        signal chosen()

        width: 50
        height: 44
        radius: Theme.radiusSmall
        color: tile.current ? Theme.surfaceHoverIn(QsWindow.window) : "transparent"
        border.color: tile.current ? Theme.accent : Theme.hairline
        border.width: 1

        SpectrumBars {
            anchors.fill: parent
            anchors.margins: 6
            sample: true
            style: tile.look
            fillStyle: tile.fillStyle
            color: root.looks.color
            color2: root.looks.color2
            barWidth: 4
            gap: 2
            floorLength: 1
            lowsAt: "along"
            peaks: root.looks.peaks
        }

        HoverHandler { cursorShape: Qt.PointingHandCursor }

        TapHandler {
            gesturePolicy: TapHandler.ReleaseWithinBounds
            onTapped: tile.chosen()
        }
    }

    // As the cursor's colour is chosen: Palette, the accent, which follows the
    // wallpaper, then the fixed colours.
    component ColourRow: Flow {
        id: colours

        property string field: "color"
        readonly property string chosen: colours.field === "color"
            ? root.looks.colorName : root.looks.color2Name

        function choose(value: string): void {
            DesktopService.setSpectrum(root.key, { [colours.field]: value })
        }

        width: parent.width
        spacing: 6

        // The palette's, ringed thicker as the cursor's is: it is the live
        // accent, not a colour.
        Rectangle {
            id: palette

            readonly property bool current: colours.chosen === "palette"

            width: paletteRow.implicitWidth + 20
            height: 26
            radius: height / 2
            color: "transparent"
            border.color: palette.current ? Theme.accent : Theme.hairline
            border.width: 1

            Row {
                id: paletteRow

                anchors.centerIn: parent
                spacing: 6

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 14
                    height: 14
                    radius: 7
                    color: Theme.accent
                    border.color: Theme.accentText
                    border.width: 2
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: Tr.t("Palette")
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeLabel
                    color: palette.current ? Theme.accent : Theme.text
                }
            }

            HoverHandler { cursorShape: Qt.PointingHandCursor }

            TapHandler {
                gesturePolicy: TapHandler.ReleaseWithinBounds
                onTapped: colours.choose("palette")
            }
        }

        Repeater {
            model: Theme.fixedColours

            Rectangle {
                id: swatch

                required property var modelData

                readonly property bool current: colours.chosen === swatch.modelData.id

                width: 26
                height: 26
                radius: 13
                color: swatch.modelData.id
                border.color: swatch.current ? Theme.accent : Theme.hairline
                border.width: swatch.current ? 2 : 1

                HoverHandler { cursorShape: Qt.PointingHandCursor }

                TapHandler {
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: colours.choose(swatch.modelData.id)
                }
            }
        }
    }

    // One of the sizes, in pixels, beside its name.
    component Measure: Item {
        id: measure

        property string label: ""
        property string field: ""
        readonly property var range: DesktopService.spectrumRanges[measure.field]

        width: parent.width
        height: 30

        Text {
            id: name

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 52
            text: measure.label
            elide: Text.ElideRight
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeLabel
            color: Theme.textMuted
        }

        SliderRow {
            anchors.left: name.right
            anchors.right: parent.right
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            height: 26
            value: root.looks[measure.field]
            from: measure.range.from
            to: measure.range.to
            unit: " px"
            onMoved: value => DesktopService.setSpectrum(root.key, { [measure.field]: value })
        }
    }
}

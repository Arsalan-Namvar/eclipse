// Retained screen-edge spectrum and configuration; no desktop widget grid.
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import "../theme"
import "../services"
import "../components"
PanelWindow {
    id: root
    CornerGuard {}
    readonly property string screenName: root.screen?.name ?? ""
    readonly property bool editing: DesktopService.editing
    readonly property bool hosting: DesktopService.editingScreen === root.screenName
    readonly property bool configuring: root.editing && DesktopService.galleryScreen === root.screenName
    anchors { top: true; left: true; right: true; bottom: true }
    exclusionMode: ExclusionMode.Ignore
    exclusiveZone: 0
    color: "transparent"
    WlrLayershell.namespace: "impasto-desktop"
    WlrLayershell.layer: root.editing ? WlrLayer.Top : WlrLayer.Bottom
    WlrLayershell.keyboardFocus: root.editing && root.hosting ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
    HyprlandFocusGrab {
        active: root.editing && root.hosting
        windows: (DesktopService.windows ?? []).concat(DeckService.windows ?? [])
        onCleared: DesktopService.edit(false)
    }
    Component.onCompleted: DesktopService.publish(root.screenName, root)
    Component.onDestruction: DesktopService.publish(root.screenName, null)
    mask: Region { width: root.editing ? root.width : 0; height: root.editing ? root.height : 0 }
    FocusScope {
        id: surfaceBoard
        anchors.fill: parent
        anchors.topMargin: DesktopService.insets.top
        focus: true
        Keys.onEscapePressed: DesktopService.edit(false)
        onWidthChanged: DesktopService.setBoard(root.screenName, width, height)
        onHeightChanged: DesktopService.setBoard(root.screenName, width, height)
        Component.onCompleted: DesktopService.setBoard(root.screenName, width, height)
        HoverHandler {
            onHoveredChanged: if (hovered && root.editing && !DesktopService.inHand && DeckService.dragging === "") DesktopService.galleryScreen = root.screenName
        }
        TapHandler {
            acceptedButtons: Qt.RightButton
            onTapped: {
                if (root.editing) DesktopService.edit(false)
                else DesktopService.edit(true, root.screenName)
            }
        }
        Repeater {
            model: ScriptModel { values: DesktopService.spectrumKeysOn(root.screenName) }
            EdgeSpectrum { board: surfaceBoard; screenName: root.screenName }
        }
        Rectangle {
            id: card
            visible: root.configuring
            x: Math.max(12, (surfaceBoard.width - width) / 2)
            y: 18
            width: Math.min(360, surfaceBoard.width - 24)
            height: Math.min(content.implicitHeight + 28, surfaceBoard.height - 36)
            radius: Theme.radiusLarge
            color: Theme.island
            border.color: Theme.hairline
            onXChanged: publishBox()
            onYChanged: publishBox()
            onWidthChanged: publishBox()
            onHeightChanged: publishBox()
            onVisibleChanged: publishBox()
            function publishBox(): void {
                if (visible) DesktopService.trayBox = { x: x, y: y, width: width, height: height }
            }
            TapHandler { acceptedButtons: Qt.LeftButton | Qt.RightButton; gesturePolicy: TapHandler.ReleaseWithinBounds }
            Flickable {
                anchors.fill: parent
                anchors.margins: 14
                contentHeight: content.implicitHeight
                clip: true
                Column {
                    id: content
                    width: parent.width
                    spacing: 12
                    Row {
                        spacing: 12
                        Text { text: Tr.t("Screen edges"); color: Theme.text; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSizeMedium }
                        PillButton { text: Tr.t("Done"); onClicked: DesktopService.edit(false) }
                    }
                    Text { width: parent.width; wrapMode: Text.WordWrap; text: Tr.t("Choose an edge to add notes or spectrum. Drag a tab to reorder or move it. Drop a surface here to unpin it."); color: Theme.textMuted; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSizeLabel }
                    Repeater {
                        model: DesktopService.edges
                        Row {
                            required property string modelData
                            spacing: 8
                            Text { width: 52; text: Tr.t(modelData); color: Theme.text; font.family: Theme.fontFamily }
                            PillButton { text: Tr.t("Notes"); enabled: NotesService.newest !== null; onClicked: { DesktopService.addDeck(root.screenName, modelData); DesktopService.selected = DesktopService.deckOn(root.screenName, modelData)?.key ?? "" } }
                            PillButton { text: Tr.t("Spectrum"); enabled: DesktopService.spectrumTakes(root.screenName, modelData); onClicked: DesktopService.selected = DesktopService.addSpectrum(root.screenName, modelData) }
                        }
                    }
                    Repeater {
                        model: DesktopService.widgets.filter(row => DesktopService.nameOf(row) === root.screenName)
                        PillButton {
                            required property var modelData
                            text: Tr.t(modelData.id === "notes" ? "Notes" : "Spectrum") + " · " + Tr.t(modelData.edge)
                            onClicked: DesktopService.selected = modelData.key
                        }
                    }
                    Loader {
                        width: parent.width
                        active: DesktopService.selected !== "" && DesktopService.nameOf(DesktopService.entryOf(DesktopService.selected)) === root.screenName
                        sourceComponent: Inspector { board: surfaceBoard; width: content.width }
                        height: item ? item.implicitHeight : 0
                    }
                }
            }
        }
    }
}

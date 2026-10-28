// ╭──────────────────────────────────────────────────────────────────────────╮
// │                                                                          │
// │   E D G E   S P E C T R U M                                              │
// │   sound bars along a whole screen edge · under the windows               │
// │                                                                          │
// │   github.com/andreumassanet/impasto                                      │
// │                                                                          │
// ╰──────────────────────────────────────────────────────────────────────────╯

import QtQuick

import "../theme"
import "../services"

// One spectrum row, along the whole of its edge (`DesktopService.geometry`):
// the bottom from corner to corner, a side from under the bar to the bottom.
// It is part of the desk, so it is under the windows: an empty workspace
// shows all of it, and beside a window only its foot shows, in the margin the
// window leaves.
//
// While arranging, click to configure, drag to another free edge, or drop
// onto the configuration card to remove the surface.
Item {
    id: root

    required property string modelData
    required property Item board
    required property string screenName

    readonly property string key: root.modelData
    readonly property var row: DesktopService.entryOf(root.key)
    readonly property string edge: root.row ? root.row.edge : "bottom"
    readonly property var looks: DesktopService.spectrumOf(root.row)
    readonly property var box: DesktopService.geometry(root.row ?? ({}), root.board.width, root.board.height)
    readonly property bool editing: DesktopService.editing
    readonly property bool selected: DesktopService.selected === root.key
    readonly property bool held: carry.active

    x: root.box.x
    y: root.box.y
    width: root.box.width
    height: root.box.height

    // While arranging, the strip's ground, so it can be found in silence.
    Rectangle {
        anchors.fill: parent
        visible: root.editing
        radius: Theme.radiusSmall
        color: Qt.alpha(Theme.accent, root.selected ? 0.16 : 0.08)
        border.color: root.selected ? Theme.accent : Theme.hairline
        border.width: root.selected ? 2 : 1
        opacity: root.held ? 0.4 : 1
    }

    // Gone while it is away (`spectrumAwayOn`), and deaf with it.
    SpectrumBars {
        anchors.fill: parent
        edge: root.edge
        style: root.looks.look
        fillStyle: root.looks.fill
        color: root.looks.color
        color2: root.looks.color2
        barWidth: root.looks.bar
        gap: root.looks.gap
        lowsAt: root.looks.lows
        peaks: root.looks.peaks
        listening: root.editing || !DesktopService.spectrumAwayOn(root.screenName)
        visible: listening
        opacity: root.looks.opacity / 100 * (root.held ? 0.4 : 1)
    }

    // ── ARRANGING ───────────────────────────────────────────────────────────
    //
    // The strip stays put while its handle follows the pointer. Only free
    // screen edges accept a drop.

    TapHandler {
        enabled: root.editing
        acceptedButtons: Qt.LeftButton
        gesturePolicy: TapHandler.ReleaseWithinBounds
        onTapped: DesktopService.selected = root.selected ? "" : root.key
    }

    DragHandler {
        id: carry

        enabled: root.editing
        target: null

        onActiveChanged: {
            if (carry.active) {
                DesktopService.dragging = root.key
                DesktopService.selected = ""
                root.aim()
                return
            }
            const pointer = root.pointer()
            const edge = DeckService.receiving
            const removed = DesktopService.overTray(root.screenName, pointer.x, pointer.y)
            DesktopService.dragging = ""
            DeckService.receiving = ""
            if (removed)
                DesktopService.remove(root.key)
            else if (edge !== "")
                DesktopService.setSpectrumEdge(root.key, root.screenName, edge)
        }

        onCentroidChanged: root.aim()
    }

    Binding {
        target: DesktopService
        property: "inHand"
        value: true
        when: carry.active
    }

    function pointer(): point {
        return root.board.mapFromItem(null,
            carry.centroid.scenePosition.x, carry.centroid.scenePosition.y)
    }

    function aim(): void {
        if (!carry.active)
            return
        const pointer = root.pointer()
        hand.x = pointer.x - hand.width / 2
        hand.y = pointer.y - hand.height / 2
        const name = root.screenName
        const over = DesktopService.overTray(name, pointer.x, pointer.y)
        const edge = over ? "" : DesktopService.edgeAt(pointer.x, pointer.y, root.board.width, root.board.height)
        DeckService.receivingScreen = name
        DeckService.receiving = DesktopService.spectrumTakes(name, edge) ? edge : ""
    }

    // A silent sample follows the pointer without loading a grid widget face.
    Loader {
        id: hand

        parent: root.board
        z: 10
        active: root.held
        width: 180
        height: 80
        opacity: 0.9

        sourceComponent: Rectangle {
            radius: Theme.radiusSmall
            color: Theme.island
            border.color: Theme.accent
            border.width: 2

            SpectrumBars {
                anchors.fill: parent
                anchors.margins: 8
                sample: true
                style: root.looks.look
                fillStyle: root.looks.fill
                color: root.looks.color
                color2: root.looks.color2
                barWidth: root.looks.bar
                gap: root.looks.gap
                lowsAt: root.looks.lows
                peaks: root.looks.peaks
            }
        }
    }
}

import QtQuick

import "../../theme"
import "../../services"
import "../island"

Item {
    id: root
    property bool compact: false
    implicitWidth: root.compact ? Theme.capsuleHeight : 520
    implicitHeight: root.compact ? Theme.capsuleHeight : detail.implicitHeight

    Component.onCompleted: OmpService.subscribe()
    Component.onDestruction: OmpService.release()

    Text {
        visible: root.compact
        anchors.centerIn: parent
        text: "󰚩"
        color: Theme.accent
        font.family: Theme.fontMono
        font.pixelSize: Theme.fontSizeRegular
    }
    Loader {
        id: detail
        active: !root.compact
        width: parent.width
        sourceComponent: OmpPanel {}
    }
}

import QtQuick
import QtQuick.Layouts
import "../../theme"

ColumnLayout {
    id: root
    property string label: ""
    property string value: ""
    spacing: 3
    Layout.fillWidth: true
    Layout.preferredWidth: 1
    OmpLabel { Layout.fillWidth: true; text: root.label; font.pixelSize: Theme.fontSizeLabel }
    OmpLabel { Layout.fillWidth: true; text: root.value; color: Theme.text; font.family: Theme.fontMono }
}

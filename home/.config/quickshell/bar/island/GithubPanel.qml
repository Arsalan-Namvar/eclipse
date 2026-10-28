pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../services"
import "../../components"

ColumnLayout {
    id: root
    signal closed()
    spacing: 10
    readonly property var service: GithubBrowserService
    Component.onCompleted: {
        GithubService.subscribe()
        root.forceActiveFocus()
    }
    Component.onDestruction: {
        GithubService.release()
        GithubBrowserService.clear()
    }
    Keys.onEscapePressed: {
        if (root.service.trail.length) root.service.back()
        else root.closed()
    }
    Connections {
        target: GithubBrowserService
        function onViewChanged(): void {
            if (root.service.view !== "contributions") Qt.callLater(() => list.forceActiveFocus())
        }
    }
    RowLayout {
        Layout.fillWidth: true
        PillButton { text: "Back"; visible: root.service.trail.length > 0; onClicked: root.service.back() }
        Repeater {
            model: ["contributions", "repositories", "organizations"]
            PillButton {
                required property string modelData
                text: modelData.charAt(0).toUpperCase() + modelData.slice(1)
                active: root.service.view === modelData
                onClicked: root.service.tab(modelData)
            }
        }
        Item { Layout.fillWidth: true }
        PillButton { text: "Refresh"; enabled: !root.service.busy; onClicked: {
            if (root.service.view === "contributions") GithubService.refresh()
            else root.service.refresh()
        } }
    }
    ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        visible: root.service.view === "contributions"
        Text {
            Layout.fillWidth: true
            text: GithubService.user !== "" ? GithubService.user : "Choose your GitHub username in Settings → Modules."
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap
        }
        Text {
            text: GithubService.available ? GithubService.totalLabel + " contributions · " + GithubService.streak + " day streak · " + GithubService.age
                : (GithubService.userUnknown ? "Profile not found. Check the username." : "No contribution data available.")
            color: Theme.textMuted
            font.family: Theme.fontFamily
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
        ContributionGrid {
            Layout.fillWidth: true
            Layout.preferredHeight: 130
            weeks: GithubService.weeks
            visible: GithubService.available
            spacing: 3
            maxCell: Math.max(1, (width + spacing) / Math.max(1, GithubService.weeks.length) - spacing)
        }
        Item { Layout.fillHeight: true }
        PillButton { text: "Open profile"; enabled: GithubService.user !== ""; onClicked: root.service.open("https://github.com/" + encodeURIComponent(GithubService.user)) }
    }
    ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        visible: root.service.view !== "contributions"
        RowLayout {
            Layout.fillWidth: true
            Text {
                Layout.fillWidth: true
                text: root.service.owner + (root.service.repository ? "/" + root.service.repository : "")
                visible: root.service.owner !== ""
                color: Theme.text
                font.family: Theme.fontFamily
                elide: Text.ElideMiddle
            }
            PillButton { text: "Issues"; visible: root.service.repository !== ""; active: root.service.view === "issues"; onClicked: {
                root.service.view = "issues"; if (root.service.state === "merged") root.service.state = "closed"; root.service.page = 1; root.service.refresh()
            } }
            PillButton { text: "Pull requests"; visible: root.service.repository !== ""; active: root.service.view === "pulls"; onClicked: {
                root.service.view = "pulls"; root.service.page = 1; root.service.refresh()
            } }
        }
        RowLayout {
            Layout.fillWidth: true
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 34
                radius: 10
                color: Theme.islandSurface
                TextInput {
                    id: filter
                    anchors.fill: parent
                    anchors.margins: 8
                    color: Theme.text
                    font.family: Theme.fontFamily
                    selectByMouse: true
                    text: root.service.query
                    onTextEdited: searchDelay.restart()
                    Keys.onDownPressed: list.forceActiveFocus()
                    Keys.onReturnPressed: list.forceActiveFocus()
                }
                Text {
                    anchors.fill: filter
                    visible: filter.text === ""
                    text: "Filter this page…"
                    color: Theme.textMuted
                    font.family: Theme.fontFamily
                }
                Timer { id: searchDelay; interval: 250; onTriggered: {
                    root.service.query = filter.text; root.service.refresh()
                } }
            }
            Repeater {
                model: root.service.repository !== "" ? (root.service.view === "pulls" ? ["open", "closed", "merged", "all"] : ["open", "closed", "all"]) : []
                PillButton {
                    required property string modelData
                    text: modelData
                    active: root.service.state === modelData
                    onClicked: { root.service.state = modelData; root.service.page = 1; root.service.refresh() }
                }
            }
        }
        Text {
            Layout.fillWidth: true
            visible: root.service.error !== ""
            text: root.service.error
            color: Theme.indicatorBad
            wrapMode: Text.WordWrap
            font.family: Theme.fontFamily
        }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Text {
                anchors.centerIn: parent
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                visible: root.service.items.length === 0 && root.service.error === ""
                text: root.service.busy ? "Loading…" : "No matching items on this page."
                color: Theme.textMuted
                font.family: Theme.fontFamily
            }
            ListView {
                id: list
                anchors.fill: parent
                clip: true
                spacing: 6
                boundsBehavior: Flickable.StopAtBounds
                model: root.service.items
                keyNavigationEnabled: true
                focus: true
                currentIndex: count > 0 ? 0 : -1
                function choose(item): void {
                    if (root.service.view === "organizations") root.service.navigate("org-repositories", item.owner, "")
                    else if (root.service.view === "repositories" || root.service.view === "org-repositories") root.service.navigate("issues", item.owner, item.name)
                    else { root.service.open(item.url); root.closed() }
                }
                Keys.onReturnPressed: if (currentIndex >= 0) choose(root.service.items[currentIndex])
                delegate: Rectangle {
                    id: row
                    required property var modelData
                    required property int index
                    width: list.width
                    height: 62
                    radius: 12
                    color: mouse.containsMouse || list.currentIndex === index ? Theme.islandSurfaceHover : Theme.islandSurface
                    MouseArea {
                        id: mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: list.choose(row.modelData)
                    }
                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.right: external.left
                        anchors.rightMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 3
                        Text {
                            width: parent.width
                            text: (row.modelData.number ? "#" + row.modelData.number + " " : "") + row.modelData.title
                            textFormat: Text.PlainText
                            elide: Text.ElideRight
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeRegular
                            color: Theme.text
                        }
                        Text {
                            width: parent.width
                            text: row.modelData.private ? "Private repository" : (row.modelData.state || row.modelData.description || "")
                            textFormat: Text.PlainText
                            elide: Text.ElideRight
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.textMuted
                        }
                    }
                    PillButton {
                        id: external
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        text: "↗"
                        onClicked: { root.service.open(row.modelData.url); root.closed() }
                    }
                }
            }
        }
        RowLayout {
            Layout.fillWidth: true
            PillButton { text: "Previous"; enabled: root.service.page > 1 && !root.service.busy; onClicked: { root.service.page--; root.service.refresh() } }
            Text { text: "Page " + root.service.page; color: Theme.textMuted; font.family: Theme.fontFamily }
            Item { Layout.fillWidth: true }
            PillButton { text: "Next"; enabled: root.service.nextPage && !root.service.busy; onClicked: { root.service.page++; root.service.refresh() } }
        }
        Text {
            Layout.fillWidth: true
            text: root.service.account !== "" ? "Signed in as " + root.service.account + " · github.com · read-only"
                : "Uses your github.com GitHub CLI login. Authentication: gh auth login."
            color: Theme.textMuted
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap
        }
    }
}

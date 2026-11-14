// ╭──────────────────────────────────────────────────────────────────────────╮
// │                                                                          │
// │   M A I N                                                                │
// │   sddm login screen                                                      │
// │                                                                          │
// │   github.com/andreumassanet/impasto                                      │
// │                                                                          │
// ╰──────────────────────────────────────────────────────────────────────────╯

import QtQuick

import "components"

// No `import SDDM`: that is the Qt5 module, and under Qt6 the theme fails to
// load. `sddm`, `userModel`, `sessionModel` and `keyboard` are context
// properties.

// The selected celestial identity is shared with the splash. Authentication
// remains SDDM's responsibility; test mode never submits a password.
Rectangle {
    id: root

    readonly property bool preview: Qt.application.arguments.indexOf("--test-mode") >= 0
    readonly property real uiScale: Math.max(0.6, Math.min(1.1, root.width / 1280, root.height / 900))
    color: "#06070b"
    gradient: Gradient {
        GradientStop { position: 0; color: "#06070b" }
        GradientStop { position: 1; color: "#0e0d13" }
    }

    Column {
        id: identity
        anchors.horizontalCenter: parent.horizontalCenter
        // Center the emblem itself; lettering sits beneath it.
        y: root.height / 2 - 128 * root.uiScale
        spacing: 16 * root.uiScale

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 256 * root.uiScale
            height: width
            source: "eclipse-mark.svg"
            fillMode: Image.PreserveAspectFit
            Accessible.name: "Eclipse celestial emblem"
        }
        Image {
            width: 300 * root.uiScale
            height: width * 112 / 720
            source: "eclipse-wordmark.svg"
            fillMode: Image.PreserveAspectFit
            Accessible.name: "Eclipse"
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: identity.bottom
        anchors.topMargin: 14 * root.uiScale
        visible: root.preview
        text: qsTr("Preview only · login and power actions are disabled")
        color: Theme.textMuted
        font.family: Theme.fontFamily
        font.pixelSize: 12 * root.uiScale
    }

    // ── STATE ───────────────────────────────────────────────────────────────

    property bool authenticating: false
    property bool failed: false
    property string message: ""

    function attempt(password: string): void {
        if (root.authenticating)
            return
        if (root.preview) {
            account.clear()
            root.failed = false
            root.message = qsTr("Preview only — authentication is not available")
            return
        }
        root.authenticating = true
        root.failed = false
        root.message = ""
        sddm.login(account.userName, password, session.currentIndex)
    }

    Connections {
        target: sddm

        function onLoginSucceeded(): void {
            root.authenticating = false
            root.message = ""
        }

        // The field clears itself; clearing it here would fight its shake.
        function onLoginFailed(): void {
            root.authenticating = false
            root.failed = true
            root.message = qsTr("Wrong password")
        }

        function onInformationMessage(message: string): void {
            root.message = message
        }

        function onSocketDisconnected(): void {
            root.authenticating = false
            account.clear()
            root.message = qsTr("Login service disconnected")
        }
    }

    // ── STAGES ──────────────────────────────────────────────────────────────

    // 0 at rest, 1 awake.
    property bool awake: false
    property real stage: root.awake ? 1 : 0

    Behavior on stage {
        NumberAnimation { duration: Theme.durationMorph; easing.type: Theme.easing }
    }

    function rouse(): void {
        root.awake = true
        drowse.restart()
    }

    function rest(): void {
        drowse.stop()
        account.expanded = false
        session.expanded = false
        account.clear()
        root.failed = false
        root.message = ""
        root.awake = false
    }

    // Return to the centered identity after inactivity, unless authenticating.
    Timer {
        id: drowse

        interval: 30000
        onTriggered: root.authenticating ? drowse.restart() : root.rest()
    }

    TapHandler {
        onTapped: {
            root.rouse()
            account.claim()
        }
    }


    // ── ACCOUNT ─────────────────────────────────────────────────────────────

    // Invisible at rest by opacity, never `visible`: the field inside holds
    // the keyboard from the start, so the first key is its first character.
    AccountPill {
        id: account

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60 - 24 * (1 - root.stage)
        opacity: root.stage
        z: 2

        users: userModel
        currentIndex: userModel.lastIndex
        authenticating: root.authenticating
        failed: root.failed
        message: root.message
        capsLock: keyboard.capsLock
        awake: root.awake

        onSubmitted: password => root.attempt(password)
        onWoke: root.rouse()

        // `failed` is bound from here, so the pill only signals; assigning it
        // inside would break the binding.
        onDismissed: {
            root.failed = false
            root.message = ""
        }

        // Switching account discards the half-typed password.
        onChosen: {
            account.clear()
            root.failed = false
            root.message = ""
            account.claim()
        }

        // A list open closes first; otherwise the screen goes back to rest.
        onEscaped: {
            if (account.expanded || session.expanded) {
                account.expanded = false
                session.expanded = false
                return
            }
            root.rest()
        }

        // Focused from the start: the first key press is the first character.
        Component.onCompleted: account.claim()
    }

    // ── BATTERY ─────────────────────────────────────────────────────────────
    //
    // Top right, where the lock screen shows it.

    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: parent.top
        anchors.topMargin: Theme.barTopMargin
        width: Theme.capsuleHeight
        height: Theme.capsuleHeight
        radius: Theme.radiusPill
        color: Theme.island
        visible: charge.available

        BatteryRing {
            id: charge

            anchors.centerIn: parent
            size: Theme.capsuleHeight
        }
    }

    // ── POWER AND SESSION ───────────────────────────────────────────────────
    //
    // Power bottom left, as on the lock screen; session bottom right. Only
    // while awake.

    PowerRow {
        anchors.left: parent.left
        anchors.leftMargin: Theme.barTopMargin + 6
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.barTopMargin + 6
        opacity: root.stage
        visible: opacity > 0

        canReboot: !root.preview && sddm.canReboot
        canPowerOff: !root.preview && sddm.canPowerOff

        onRebootRequested: if (!root.preview) sddm.reboot()
        onPowerOffRequested: if (!root.preview) sddm.powerOff()
    }

    SessionPicker {
        id: session

        anchors.right: parent.right
        anchors.rightMargin: Theme.barTopMargin + 6
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.barTopMargin + 6
        opacity: root.stage
        visible: opacity > 0

        sessions: sessionModel
        currentIndex: sessionModel.lastIndex
    }
}

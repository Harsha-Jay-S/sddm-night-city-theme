import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    color: "#05040a"

    property date currentDate: new Date()
    property string timeStr: ""
    property string secsStr: ""
    property string dateStr: ""
    property bool loginSucceeded: false
    property bool loginDenied: false

    property var monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    property var dayNames: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    function formatDate(d) {
        return dayNames[d.getDay()] + ", " + monthNames[d.getMonth()] + " " + d.getDate()
    }

    function tick() {
        root.currentDate = new Date()
        var d = root.currentDate
        var h = d.getHours()
        var m = d.getMinutes()
        var s = d.getSeconds()
        root.timeStr = (h < 10 ? "0" : "") + h + ":" + (m < 10 ? "0" : "") + m
        root.secsStr = (s < 10 ? "0" : "") + s
        root.dateStr = root.formatDate(d).toUpperCase()
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.tick()
    }

    Timer {
        id: denyGlowTimer
        interval: 2500
        onTriggered: root.loginDenied = false
    }

    BackgroundLayer {
        anchors.fill: parent
    }

    CornerBrackets {
        anchors.fill: parent
    }

    ClockDisplay {
        id: clockDisplay
        time: root.timeStr
        secs: root.secsStr
        date: root.dateStr
        sessionUnlocked: root.loginSucceeded
        loginDenied: root.loginDenied
    }

    StatusPills { }

    AuthPanel {
        id: authPanel
        loginSucceeded: root.loginSucceeded
        loginDenied: root.loginDenied
        onLoginRequested: root.doLogin()
    }

    PowerButtons { }

    SessionSwitcher { id: sessionSwitcher }

    Connections {
        target: sddm
        function onLoginSucceeded() {
            // Reveal success immediately: SDDM tears the greeter down within a
            // few hundred ms of this signal, so any delayed reveal loses the
            // race and the user just sees the greeter vanish (a glitch).
            root.loginDenied = false
            root.loginSucceeded = true
        }
        function onLoginFailed() {
            root.loginSucceeded = false
            root.loginDenied = true
            denyGlowTimer.restart()
            authPanel.textPass.readOnly = false
            authPanel.showError()
        }
    }

    function doLogin() {
        var user = userModel ? userModel.lastUser : ""
        var password = authPanel.textPass.text
        var session = sessionSwitcher.selectedIndex
        if (!user || !password) return

        authPanel.textPass.readOnly = true
        sddm.login(user, password, session)
    }

    Component.onCompleted: {
        authPanel.textPass.forceActiveFocus()
    }
}

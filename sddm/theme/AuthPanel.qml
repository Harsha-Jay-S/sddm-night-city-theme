import QtQuick
import QtQuick.Controls

Item {
    id: root

    FontLoader { source: "fonts/ChakraPetch-Regular.ttf" }
    FontLoader { source: "fonts/ChakraPetch-Medium.ttf" }
    FontLoader { source: "fonts/ChakraPetch-Bold.ttf" }

    property alias textPass: textPass
    property bool denied: false
    property bool capsOn: false
    property bool revealing: false
    property string errorMsg: ""
    property string greeting: ""
    property bool loginSucceeded: false
    property bool loginDenied: false

    signal loginRequested()

    x: parent.width / 2 - width / 2
    y: parent.height - 92 - implicitHeight
    width: 440

    readonly property var greetings: [
        "Let\u0027s build something epic.",
        "Nothing can stop you today.",
        "One step closer to your goals.",
        "Push past your limit. Right here, right now!",
        "\u0022Hard work is worthless for those that don\u0027t believe in themselves.\u0022 (Naruto Uzumaki)",
        "\u0022I don\u0027t care about \u0027optimal\u0027 paths. I\u0027ll make my own.\u0022 (Eren Yeager)",
        "The only one who can beat me, is me.",
        "\u0022Don\u0027t mock me. I have no time to deal with trash.\u0022 (Saitama \u2013 One Punch Man)",
        "\u0022I don\u0027t need a reason to win. I just will.\u0022 (Kageyama Tobio \u2013 Haikyuu!!)",
        "\u0022I am the one who decides my own limits.\u0022 (Genos \u2013 One Punch Man)",
        "There is no such thing as luck. Only talent, drive, and preparation.",
        "\u0022If nobody cares to accept you... just accept yourself.\u0022 (Gaara \u2013 Naruto)",
        "If the world is against me, then I\u0027ll fight the world.",
        "\u0022The only thing we\u0027re allowed to do... is to believe that we won\u0027t regret the choice we made.\u0022 (Levi Ackerman \u2013 Attack on Titan)"
    ]

    function pickGreeting() {
        greeting = greetings[Math.floor(Math.random() * greetings.length)]
    }

    function showError() {
        errorMsg = "Type carefully. I\u0027m watching."
        denied = true
        shakeAnim.restart()
    }

    function roundRect(ctx, x, y, w, h, r) {
        ctx.beginPath()
        ctx.moveTo(x + r, y)
        ctx.lineTo(x + w - r, y)
        ctx.quadraticCurveTo(x + w, y, x + w, y + r)
        ctx.lineTo(x + w, y + h - r)
        ctx.quadraticCurveTo(x + w, y + h, x + w - r, y + h)
        ctx.lineTo(x + r, y + h)
        ctx.quadraticCurveTo(x, y + h, x, y + h - r)
        ctx.lineTo(x, y + r)
        ctx.quadraticCurveTo(x, y, x + r, y)
        ctx.closePath()
    }

    Label {
        id: greetingLabel
        text: root.loginSucceeded ? "Okaerinasai!"
             : root.loginDenied ? "Omae wa mou... wait, type that again."
             : root.greeting
        width: 812
        height: 23
        horizontalAlignment: Text.AlignHCenter
        font { family: "Chakra Petch"; pixelSize: 15 }
        lineHeight: 1.35
        color: root.loginSucceeded ? "#35e8ff"
             : root.loginDenied ? "#ff35c8"
             : Qt.rgba(234/255, 246/255, 255/255, 0.72)
        x: parent.width / 2 - width / 2
        y: 0
        Behavior on color { ColorAnimation { duration: 250 } }
    }

    Column {
        spacing: 14
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        y: greetingLabel.y + greetingLabel.height + 14

        Item {
            id: inputWrap
            width: parent.width
            height: 52
            opacity: textPass.focus ? 1.0 : 0.5
            Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutSine } }

            Rectangle {
                id: inputBg
                anchors.fill: parent
                radius: 14
                color: Qt.rgba(6/255, 4/255, 14/255, 0.42)
                border {
                    width: 1
                    color: root.loginSucceeded ? "#35e8ff"
                         : root.loginDenied ? "#ff35c8"
                         : textPass.focus ? Qt.rgba(53/255, 232/255, 255/255, 0.65)
                                          : Qt.rgba(120/255, 180/255, 255/255, 0.18)
                }
                Behavior on border.color { ColorAnimation { duration: 200 } }

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 6
                    spacing: 10
                    layoutDirection: Qt.LeftToRight

                    Item {
                        id: lockIcon
                        width: 18
                        height: 18
                        anchors.verticalCenter: parent.verticalCenter

                        Canvas {
                            width: 18
                            height: 18
                            anchors.centerIn: parent
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)
                                ctx.save()
                                ctx.scale(18/24, 18/24)
                                ctx.strokeStyle = root.loginSucceeded ? "#35e8ff"
                                                 : root.loginDenied ? "#ff35c8"
                                                 : Qt.rgba(53/255, 232/255, 255/255, 0.75)
                                ctx.lineWidth = 1.8
                                ctx.lineCap = "round"
                                ctx.lineJoin = "round"
                                root.roundRect(ctx, 4, 11, 16, 9, 2)
                                ctx.stroke()
                                ctx.beginPath()
                                ctx.moveTo(8, 11)
                                ctx.lineTo(8, 8)
                                ctx.bezierCurveTo(8, 5.79, 9.79, 4, 12, 4)
                                ctx.bezierCurveTo(14.21, 4, 16, 5.79, 16, 8)
                                ctx.lineTo(16, 11)
                                ctx.stroke()
                                ctx.restore()
                            }
                            Component.onCompleted: requestPaint()
                        }
                    }

                    TextField {
                        id: textPass
                        width: parent.width - lockIcon.width - toggleBtn.width - submitBtn.width - 30
                        anchors.verticalCenter: parent.verticalCenter
                        font { family: "Chakra Petch"; pixelSize: 16; letterSpacing: 2.24 }
                        color: root.loginSucceeded ? "#35e8ff" : root.loginDenied ? "#ff35c8" : "#f4fbff"
                        placeholderText: "Enter password"
                        placeholderTextColor: Qt.rgba(244/255, 251/255, 255/255, 0.35)
                        echoMode: root.revealing ? TextInput.Normal : TextInput.Password
                        background: Rectangle { color: "transparent" }
                        focus: true

                        onTextChanged: {
                            if (!root.loginSucceeded) {
                                root.errorMsg = ""
                                root.denied = false
                            }
                        }

                        onAccepted: {
                            if (!root.loginSucceeded) {
                                root.loginRequested()
                            }
                        }
                    }

                    Rectangle {
                        id: toggleBtn
                        width: 38
                        height: 38
                        radius: 9
                        color: mouseToggle.containsMouse ? Qt.rgba(53/255, 232/255, 255/255, 0.12) : "transparent"
                        anchors.verticalCenter: parent.verticalCenter
                        visible: !root.loginSucceeded

                        Canvas {
                            id: eyeOpenIcon
                            width: 19
                            height: 19
                            anchors.centerIn: parent
                            visible: !root.revealing
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)
                                ctx.save()
                                ctx.scale(19/24, 19/24)
                                ctx.strokeStyle = mouseToggle.containsMouse ? "#35e8ff" : Qt.rgba(207/255, 233/255, 255/255, 0.7)
                                ctx.lineWidth = 1.8
                                ctx.lineCap = "round"
                                ctx.lineJoin = "round"
                                ctx.beginPath()
                                ctx.moveTo(1, 12)
                                ctx.bezierCurveTo(1, 12, 5, 4, 12, 4)
                                ctx.bezierCurveTo(19, 4, 23, 12, 23, 12)
                                ctx.bezierCurveTo(23, 12, 19, 20, 12, 20)
                                ctx.bezierCurveTo(5, 20, 1, 12, 1, 12)
                                ctx.closePath()
                                ctx.stroke()
                                ctx.beginPath()
                                ctx.moveTo(9, 12)
                                ctx.bezierCurveTo(9, 10.34, 10.34, 9, 12, 9)
                                ctx.bezierCurveTo(13.66, 9, 15, 10.34, 15, 12)
                                ctx.bezierCurveTo(15, 13.66, 13.66, 15, 12, 15)
                                ctx.bezierCurveTo(10.34, 15, 9, 13.66, 9, 12)
                                ctx.closePath()
                                ctx.stroke()
                                ctx.restore()
                            }
                            Component.onCompleted: requestPaint()
                        }

                        Canvas {
                            id: eyeOffIcon
                            width: 19
                            height: 19
                            anchors.centerIn: parent
                            visible: root.revealing
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)
                                ctx.save()
                                ctx.scale(19/24, 19/24)
                                ctx.strokeStyle = mouseToggle.containsMouse ? "#35e8ff" : Qt.rgba(207/255, 233/255, 255/255, 0.7)
                                ctx.lineWidth = 1.8
                                ctx.lineCap = "round"
                                ctx.lineJoin = "round"
                                ctx.beginPath()
                                ctx.moveTo(17.94, 17.94)
                                ctx.bezierCurveTo(15.62, 19.27, 13.87, 20, 12, 20)
                                ctx.bezierCurveTo(5, 20, 1, 12, 1, 12)
                                ctx.bezierCurveTo(2.55, 9.38, 4.67, 7.33, 7.06, 6.06)
                                ctx.stroke()
                                ctx.beginPath()
                                ctx.moveTo(9.9, 4.24)
                                ctx.bezierCurveTo(10.58, 4.08, 11.29, 4, 12, 4)
                                ctx.bezierCurveTo(19, 4, 23, 12, 23, 12)
                                ctx.bezierCurveTo(22.22, 13.27, 21.28, 14.39, 20.16, 15.27)
                                ctx.stroke()
                                ctx.beginPath()
                                ctx.moveTo(13.44, 13.44)
                                ctx.bezierCurveTo(12.89, 14.51, 11.73, 15.24, 10.41, 15.08)
                                ctx.bezierCurveTo(9.09, 14.93, 8.11, 14.07, 7.82, 12.82)
                                ctx.bezierCurveTo(7.53, 11.57, 8.09, 10.3, 9.16, 9.7)
                                ctx.stroke()
                                ctx.beginPath()
                                ctx.moveTo(1, 1)
                                ctx.lineTo(23, 23)
                                ctx.stroke()
                                ctx.restore()
                            }
                            Component.onCompleted: requestPaint()
                        }

                        MouseArea {
                            id: mouseToggle
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.revealing = !root.revealing
                        }
                    }

                    Rectangle {
                        id: submitBtn
                        width: 40
                        height: 40
                        radius: 11
                        anchors.verticalCenter: parent.verticalCenter
                        visible: !root.loginSucceeded

                        Canvas {
                            anchors.fill: parent
                            onPaint: {
                                var ctx = getContext("2d")
                                var grad = ctx.createLinearGradient(0, height, width, 0)
                                grad.addColorStop(0, "#35e8ff")
                                grad.addColorStop(1, "#8f6bff")
                                ctx.fillStyle = grad
                                root.roundRect(ctx, 0, 0, width, height, 11)
                                ctx.fill()
                            }
                            Component.onCompleted: requestPaint()
                        }

                        Canvas {
                            id: arrowIcon
                            width: 20
                            height: 20
                            anchors.centerIn: parent
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)
                                ctx.save()
                                ctx.scale(20/24, 20/24)
                                ctx.strokeStyle = "#06121a"
                                ctx.lineWidth = 2.4
                                ctx.lineCap = "round"
                                ctx.lineJoin = "round"
                                ctx.beginPath()
                                ctx.moveTo(5, 12)
                                ctx.lineTo(19, 12)
                                ctx.stroke()
                                ctx.beginPath()
                                ctx.moveTo(12, 5)
                                ctx.lineTo(19, 12)
                                ctx.lineTo(12, 19)
                                ctx.stroke()
                                ctx.restore()
                            }
                            Component.onCompleted: requestPaint()
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: parent.color = Qt.rgba(53/255, 232/255, 255/255, 0.8)
                            onExited: parent.color = "transparent"
                            onClicked: root.loginRequested()
                        }
                    }
                }
            }
        }

        Item {
            id: capsRow
            width: parent.width
            height: root.capsOn && !root.loginSucceeded ? 15 : 0
            visible: root.capsOn && !root.loginSucceeded
            opacity: root.capsOn && !root.loginSucceeded ? 1 : 0
            Behavior on height { NumberAnimation { duration: 150 } }
            Behavior on opacity { NumberAnimation { duration: 150 } }

            Row {
                spacing: 8
                anchors.horizontalCenter: parent.horizontalCenter

                Canvas {
                    width: 15
                    height: 15
                    anchors.verticalCenter: parent.verticalCenter
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)
                        ctx.save()
                        ctx.scale(15/24, 15/24)
                        ctx.strokeStyle = "#6DCCDE"
                        ctx.lineWidth = 1.9
                        ctx.lineCap = "round"
                        ctx.lineJoin = "round"
                        ctx.beginPath()
                        ctx.moveTo(12, 4)
                        ctx.lineTo(5, 11)
                        ctx.lineTo(9, 11)
                        ctx.lineTo(9, 16)
                        ctx.lineTo(15, 16)
                        ctx.lineTo(15, 11)
                        ctx.lineTo(19, 11)
                        ctx.closePath()
                        ctx.stroke()
                        ctx.beginPath()
                        ctx.moveTo(8, 20)
                        ctx.lineTo(16, 20)
                        ctx.stroke()
                        ctx.restore()
                    }
                    Component.onCompleted: requestPaint()
                }

                Label {
                    text: "Caps Lock is on"
                    font { family: "Chakra Petch"; pixelSize: 13; letterSpacing: 1.04 }
                    color: "#ffd166"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Item {
            id: errorRow
            width: parent.width
            height: root.denied && root.errorMsg && !root.loginSucceeded ? 15 : 0
            visible: root.denied && root.errorMsg && !root.loginSucceeded
            opacity: root.denied && root.errorMsg && !root.loginSucceeded ? 1 : 0
            Behavior on height { NumberAnimation { duration: 150 } }
            Behavior on opacity { NumberAnimation { duration: 150 } }

            Row {
                spacing: 8
                anchors.horizontalCenter: parent.horizontalCenter

                Canvas {
                    width: 15
                    height: 15
                    anchors.verticalCenter: parent.verticalCenter
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)
                        ctx.save()
                        ctx.scale(15/24, 15/24)
                        ctx.strokeStyle = "#ff5db4"
                        ctx.lineWidth = 2
                        ctx.lineCap = "round"
                        ctx.lineJoin = "round"
                        ctx.beginPath()
                        ctx.moveTo(10.29, 3.86)
                        ctx.lineTo(1.82, 18)
                        ctx.bezierCurveTo(1.33, 18.81, 1.89, 19.87, 2.82, 20.17)
                        ctx.lineTo(21.18, 20.17)
                        ctx.bezierCurveTo(22.11, 19.87, 22.67, 18.81, 22.18, 18)
                        ctx.lineTo(13.71, 3.86)
                        ctx.bezierCurveTo(13.22, 3.05, 12.17, 3.05, 10.29, 3.86)
                        ctx.closePath()
                        ctx.stroke()
                        ctx.beginPath()
                        ctx.moveTo(12, 9)
                        ctx.lineTo(12, 13)
                        ctx.stroke()
                        ctx.beginPath()
                        ctx.moveTo(12, 17)
                        ctx.lineTo(12.01, 17)
                        ctx.stroke()
                        ctx.restore()
                    }
                    Component.onCompleted: requestPaint()
                }

                Label {
                    text: root.errorMsg
                    font { family: "Chakra Petch"; pixelSize: 13; letterSpacing: 0.78 }
                    color: "#ff5db4"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    Timer {
        id: denyResetTimer
        interval: 480
        onTriggered: {
            root.denied = false
            root.errorMsg = ""
        }
    }

    SequentialAnimation {
        id: shakeAnim
        alwaysRunToEnd: true
        NumberAnimation { target: root; property: "x"; to: root.x - 2; duration: 46 }
        NumberAnimation { target: root; property: "x"; to: root.x + 4; duration: 92 }
        NumberAnimation { target: root; property: "x"; to: root.x - 9; duration: 46 }
        NumberAnimation { target: root; property: "x"; to: root.x + 9; duration: 92 }
        NumberAnimation { target: root; property: "x"; to: root.x - 4; duration: 46 }
        NumberAnimation { target: root; property: "x"; to: root.x + 4; duration: 46 }
        NumberAnimation { target: root; property: "x"; to: root.x - 2; duration: 46 }
        NumberAnimation { target: root; property: "x"; to: root.x; duration: 46 }
        onStopped: denyResetTimer.restart()
    }

    Component.onCompleted: pickGreeting()
}

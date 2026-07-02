import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: root

    property string time: "00:00"
    property string secs: "00"
    property string date: "MONDAY, JANUARY 1"
    property bool sessionUnlocked: false
    property bool loginDenied: false

    FontLoader { source: "fonts/ChakraPetch-Regular.ttf" }
    FontLoader { source: "fonts/ChakraPetch-Bold.ttf" }
    FontLoader { source: "fonts/ChakraPetch-Medium.ttf" }
    FontLoader { source: "fonts/ChakraPetch-SemiBold.ttf" }
    FontLoader { source: "fonts/Orbitron-Variable.ttf" }

    x: 60
    y: 52

    Row {
        id: sessionRow
        spacing: 12

        Rectangle {
            id: pulseDot
            width: 8
            height: 8
            radius: 4
            color: root.loginDenied ? "#ff35c8" : "#35e8ff"
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color { ColorAnimation { duration: 250 } }

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                PropertyAnimation { to: 0.55; duration: 1100; easing.type: Easing.InOutSine }
                PropertyAnimation { to: 1; duration: 1100; easing.type: Easing.InOutSine }
            }
        }

        Label {
            id: sessionLabel
            text: root.sessionUnlocked ? "SESSION UNLOCKED" : "SESSION LOCKED"
            font { family: "Chakra Petch"; pixelSize: 12; letterSpacing: 5.04 }
            color: root.loginDenied ? "#ff35c8"
                 : root.sessionUnlocked ? "#35e8ff"
                 : Qt.rgba(255/255, 53/255, 200/255, 0.85)
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color { ColorAnimation { duration: 250 } }
        }
    }

    Item {
        id: timeBlock
        y: 28

        Row {
            spacing: 10

            Column {
                id: timeCol
                spacing: 0

                Label {
                    id: timeLabel
                    text: root.time
                    font { family: "Orbitron"; weight: Font.Black; pixelSize: 104; letterSpacing: 1.04 }
                    lineHeight: 0.9
                    color: "#f4fbff"
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: Qt.rgba(53/255, 232/255, 255/255, 0.55)
                        shadowBlur: 0.9
                        shadowHorizontalOffset: 0
                        shadowVerticalOffset: 0
                        shadowOpacity: 1.0
                        shadowScale: 1.0
                    }
                }

                Label {
                    id: dateLabel
                    text: root.date
                    font { family: "Chakra Petch"; weight: Font.Medium; pixelSize: 16; letterSpacing: 5.44 }
                    color: Qt.rgba(234/255, 246/255, 255/255, 0.72)
                    leftPadding: 8
                    topPadding: 8
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: Qt.rgba(53/255, 232/255, 255/255, 0.2)
                        shadowBlur: 0.6
                        shadowHorizontalOffset: 0
                        shadowVerticalOffset: 0
                        shadowOpacity: 1.0
                        shadowScale: 1.0
                    }
                }
            }

            Column {
                id: secsCol
                width: 40
                spacing: 6
                topPadding: 8

                Label {
                    text: ":" + root.secs
                    font { family: "Orbitron"; weight: Font.DemiBold; pixelSize: 22 }
                    color: "#ff6fe0"
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Column {
                    spacing: 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    Repeater {
                        model: ["東", "京", "・", "深", "夜"]
                        Label {
                            text: modelData
                            font { family: "Noto Sans CJK JP"; pixelSize: 15 }
                            color: Qt.rgba(53/255, 232/255, 255/255, 0.5)
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
        }
    }
}

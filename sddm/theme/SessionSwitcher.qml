import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: root

    FontLoader { source: "fonts/ChakraPetch-Regular.ttf" }
    FontLoader { source: "fonts/ChakraPetch-Medium.ttf" }

    x: 60
    y: parent.height - 80 - 52
    width: btnBg.width
    height: 52
    z: 10

    property bool popupOpen: false
    property string currentSessionName: "SESSION"
    // The chosen session row, passed to sddm.login(). Initialised to the
    // persisted last-used session (sessionModel.lastIndex is READ-ONLY, so the
    // selection must live here, not be written back to the model).
    property int selectedIndex: sessionModel ? sessionModel.lastIndex : 0

    function svgIcon(paths, sw, strokeColor) {
        var sc = strokeColor || "currentColor"
        return "data:image/svg+xml;utf8," + encodeURIComponent(
            '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="' + sc + '" stroke-width="' + (sw || "1.7") + '" stroke-linecap="round" stroke-linejoin="round">' + paths + '</svg>'
        )
    }

    // Initialise the button label from the currently-selected session.
    Repeater {
        model: sessionModel
        delegate: Item {
            visible: false
            Component.onCompleted: {
                if (model.index === root.selectedIndex)
                    root.currentSessionName = model.name
            }
        }
    }

    // Click-catcher: closes the menu when clicking elsewhere. Only active while
    // open, so it never blocks the other buttons. (Matches the reference HTML's
    // plain-div popup instead of a QtQuick Controls Popup, which needs an
    // Overlay that is unreliable inside SDDM's greeter window.)
    MouseArea {
        enabled: root.popupOpen
        visible: root.popupOpen
        x: -3000; y: -3000
        width: 6000; height: 6000
        z: 1
        onClicked: root.popupOpen = false
    }

    Rectangle {
        id: btnBg
        width: contentRow.implicitWidth + 36
        height: parent.height
        z: 2
        radius: 14
        color: Qt.rgba(10/255, 8/255, 20/255, 0.5)
        border {
            width: 1
            color: root.popupOpen || btnMouse.containsMouse
                ? "#35e8ff"
                : Qt.rgba(53/255, 232/255, 255/255, 0.3)
        }

        Row {
            id: contentRow
            spacing: 11
            anchors.centerIn: parent

            Image {
                width: 20; height: 20
                anchors.verticalCenter: parent.verticalCenter
                source: root.svgIcon(
                    '<polygon points="12 2 2 7 12 12 22 7 12 2"/>' +
                    '<polyline points="2 17 12 22 22 17"/>' +
                    '<polyline points="2 12 12 17 22 12"/>',
                    "1.7", "#35e8ff"
                )
                sourceSize { width: 20; height: 20 }
            }

            Label {
                text: root.currentSessionName
                font { family: "Chakra Petch"; pixelSize: 13; letterSpacing: 1.3 }
                color: "#dff6ff"
                anchors.verticalCenter: parent.verticalCenter
            }

            Image {
                width: 14; height: 14
                anchors.verticalCenter: parent.verticalCenter
                rotation: root.popupOpen ? 0 : 180
                Behavior on rotation { NumberAnimation { duration: 150 } }
                source: root.svgIcon(
                    '<polyline points="6 15 12 9 18 15"/>',
                    "2.2", "#dff6ff"
                )
                sourceSize { width: 14; height: 14 }
                opacity: 0.7
            }
        }

        MouseArea {
            id: btnMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.popupOpen = !root.popupOpen
        }
    }

    Rectangle {
        id: sessionMenu
        z: 3
        visible: root.popupOpen
        width: Math.max(btnBg.width, 210)
        height: menuCol.implicitHeight + 12
        x: 0
        y: -height - 12
        radius: 14
        color: Qt.rgba(12/255, 9/255, 24/255, 0.96)
        border { width: 1; color: Qt.rgba(120/255, 180/255, 255/255, 0.22) }
        layer {
            enabled: true
            effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#35e8ff"
                shadowBlur: 0.3
                shadowOpacity: 0.25
            }
        }

        Column {
            id: menuCol
            x: 6
            y: 6
            width: parent.width - 12
            spacing: 2

            Repeater {
                model: sessionModel
                delegate: Item {
                    property string sesName: model ? model.name : ""
                    property int sesIndex: model ? model.index : -1

                    width: parent.width
                    height: 40

                    Rectangle {
                        anchors.fill: parent
                        radius: 9
                        color: itemMouse.containsMouse
                            ? Qt.rgba(53/255, 232/255, 255/255, 0.12)
                            : "transparent"
                    }

                    Label {
                        text: sesName
                        font { family: "Chakra Petch"; pixelSize: 13; letterSpacing: 1.3 }
                        color: sesIndex === root.selectedIndex
                            ? "#35e8ff" : "#dff2ff"
                        anchors {
                            left: parent.left; leftMargin: 12
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    Rectangle {
                        visible: sesIndex === root.selectedIndex
                        width: 7; height: 7; radius: 3.5
                        color: "#35e8ff"
                        anchors {
                            right: parent.right; rightMargin: 14
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: itemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.selectedIndex = sesIndex
                            root.currentSessionName = sesName
                            root.popupOpen = false
                        }
                    }
                }
            }
        }
    }
}

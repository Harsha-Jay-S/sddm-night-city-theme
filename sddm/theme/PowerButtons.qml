import QtQuick
import QtQuick.Controls

Item {
    id: root

    FontLoader { source: "fonts/ChakraPetch-Regular.ttf" }
    FontLoader { source: "fonts/ChakraPetch-Medium.ttf" }

    y: parent.height - 80 - 52
    anchors.right: parent.right
    anchors.rightMargin: 60
    width: row.implicitWidth
    height: 52

    function svgIcon(paths, sw, strokeColor) {
        var sc = strokeColor || "currentColor"
        return "data:image/svg+xml;utf8," + encodeURIComponent(
            '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="' + sc + '" stroke-width="' + (sw || "1.8") + '" stroke-linecap="round" stroke-linejoin="round">' +
            paths +
            '</svg>'
        )
    }

    Row {
        id: row
        spacing: 14

        Repeater {
            model: [
                {
                    label: "Sleep",
                    paths: '<path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>',
                    color: "#c9b3ff",
                    borderColor: Qt.rgba(176/255, 107/255, 255/255, 0.3),
                    hoverColor: "#e9dcff",
                    hoverBorder: "#b06bff",
                    action: "suspend"
                },
                {
                    label: "Restart",
                    paths: '<polyline points="23 4 23 10 17 10"/><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"/>',
                    color: "#9fe8ff",
                    borderColor: Qt.rgba(53/255, 232/255, 255/255, 0.3),
                    hoverColor: "#dff6ff",
                    hoverBorder: "#35e8ff",
                    action: "reboot"
                },
                {
                    label: "Shut down",
                    paths: '<path d="M18.36 6.64a9 9 0 1 1-12.73 0"/><line x1="12" y1="2" x2="12" y2="12"/>',
                    color: "#ff8fd8",
                    borderColor: Qt.rgba(255/255, 53/255, 200/255, 0.32),
                    hoverColor: "#ffd6f1",
                    hoverBorder: "#ff35c8",
                    action: "powerOff"
                }
            ]

            delegate: Rectangle {
                id: btn
                width: 52
                height: 52
                radius: 14
                color: Qt.rgba(10/255, 8/255, 20/255, 0.5)
                border { width: 1; color: modelData.borderColor }

                Image {
                    id: iconImage
                    width: 22
                    height: 22
                    anchors.centerIn: parent
                    source: root.svgIcon(modelData.paths, "1.8", modelData.color)
                    sourceSize { width: 22; height: 22 }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        parent.border.color = modelData.hoverBorder
                        parent.color = Qt.rgba(10/255, 8/255, 20/255, 0.7)
                    }
                    onExited: {
                        parent.border.color = modelData.borderColor
                        parent.color = Qt.rgba(10/255, 8/255, 20/255, 0.5)
                    }
                    onClicked: {
                        if (modelData.action === "suspend") sddm.suspend()
                        else if (modelData.action === "reboot") sddm.reboot()
                        else if (modelData.action === "powerOff") sddm.powerOff()
                    }
                }
            }
        }
    }
}

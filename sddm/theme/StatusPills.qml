import QtQuick
import QtQuick.Controls

Item {
    id: root

    FontLoader { source: "fonts/ChakraPetch-Regular.ttf" }
    FontLoader { source: "fonts/ChakraPetch-Medium.ttf" }

    y: 56
    anchors.right: parent.right
    anchors.rightMargin: 60
    width: row.implicitWidth
    height: 38

    function svgIcon(paths, stroke, w, fill) {
        var f = fill ? ' fill="' + fill + '"' : ' fill="none"'
        return "data:image/svg+xml;utf8," + encodeURIComponent(
            '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" stroke="' + stroke + '" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' + f + '>' +
            paths +
            '</svg>'
        )
    }

    Row {
        id: row
        spacing: 12

        Rectangle {
            id: neoPillBg
            height: 38
            radius: 19
            color: Qt.rgba(10/255, 8/255, 20/255, 0.5)
            border { width: 1; color: Qt.rgba(53/255, 232/255, 255/255, 0.28) }

            Row {
                spacing: 9
                anchors.centerIn: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14

                Image {
                    width: 17
                    height: 17
                    anchors.verticalCenter: parent.verticalCenter
                    source: svgIcon(
                        '<path d="M5 12.55a11 11 0 0 1 14.08 0"/>' +
                        '<path d="M1.42 9a16 16 0 0 1 21.16 0"/>' +
                        '<path d="M8.53 16.11a6 6 0 0 1 6.95 0"/>' +
                        '<line x1="12" y1="20" x2="12.01" y2="20"/>',
                        "#35e8ff", "2"
                    )
                    sourceSize { width: 17; height: 17 }
                }

                Label {
                    text: sddm.hostName
                    font { family: "Chakra Petch"; pixelSize: 13; letterSpacing: 1.82 }
                    color: "#dff6ff"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Rectangle {
            id: batteryPillBg
            height: 38
            radius: 19
            color: Qt.rgba(10/255, 8/255, 20/255, 0.5)
            border { width: 1; color: Qt.rgba(53/255, 232/255, 255/255, 0.28) }

            Row {
                spacing: 9
                anchors.centerIn: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14

                Image {
                    width: 26
                    height: 16
                    anchors.verticalCenter: parent.verticalCenter
                    source: svgIcon(
                        '<rect x="1" y="2.5" width="21" height="11" rx="2.5" stroke="#35e8ff" stroke-width="1.6"/>' +
                        '<rect x="23" y="6" width="2.4" height="4" rx="1" fill="#35e8ff"/>' +
                        '<rect x="3" y="4.5" width="14.5" height="7" rx="1" fill="#35e8ff"/>',
                        "#35e8ff", "1.6", "#35e8ff"
                    )
                    sourceSize { width: 26; height: 16 }
                }

                Label {
                    text: "87%"
                    font { family: "Chakra Petch"; pixelSize: 13; letterSpacing: 1.3 }
                    color: "#dff6ff"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}

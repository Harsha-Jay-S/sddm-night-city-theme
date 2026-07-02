import QtQuick

Item {
    id: root

    readonly property color cyan: Qt.rgba(53/255, 232/255, 255/255, 1)

    // Top-left cyan
    Rectangle { x: 22; y: 22; width: 46; height: 2; color: Qt.rgba(53/255, 232/255, 255/255, 0.55) }
    Rectangle { x: 22; y: 22; width: 2; height: 46; color: Qt.rgba(53/255, 232/255, 255/255, 0.55) }

    // Top-right pink
    Rectangle { x: parent.width - 22 - 46; y: 22; width: 46; height: 2; color: Qt.rgba(255/255, 53/255, 200/255, 0.5) }
    Rectangle { x: parent.width - 22 - 2; y: 22; width: 2; height: 46; color: Qt.rgba(255/255, 53/255, 200/255, 0.5) }

    // Bottom-left cyan
    Rectangle { x: 22; y: parent.height - 22 - 2; width: 46; height: 2; color: Qt.rgba(53/255, 232/255, 255/255, 0.45) }
    Rectangle { x: 22; y: parent.height - 22 - 46; width: 2; height: 46; color: Qt.rgba(53/255, 232/255, 255/255, 0.45) }

    // Bottom-right pink
    Rectangle { x: parent.width - 22 - 46; y: parent.height - 22 - 2; width: 46; height: 2; color: Qt.rgba(255/255, 53/255, 200/255, 0.45) }
    Rectangle { x: parent.width - 22 - 2; y: parent.height - 22 - 46; width: 2; height: 46; color: Qt.rgba(255/255, 53/255, 200/255, 0.45) }
}

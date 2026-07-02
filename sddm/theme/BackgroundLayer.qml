import QtQuick

Item {
    id: root

    Image {
        id: bgImage
        anchors.fill: parent
        source: "background.jpg"
        fillMode: Image.PreserveAspectCrop
        transform: Scale {
            origin.x: parent.width * 0.58
            origin.y: parent.height * 0.5
            xScale: 1.04
            yScale: 1.04
        }
    }

    Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            var grad = ctx.createLinearGradient(0, 0, width, 0)
            grad.addColorStop(0, Qt.rgba(4/255, 2/255, 12/255, 0.92))
            grad.addColorStop(0.30, Qt.rgba(4/255, 2/255, 12/255, 0.6))
            grad.addColorStop(0.52, Qt.rgba(4/255, 2/255, 12/255, 0.12))
            grad.addColorStop(0.68, Qt.rgba(4/255, 2/255, 12/255, 0))
            ctx.fillStyle = grad
            ctx.fillRect(0, 0, width, height)
        }
        Component.onCompleted: requestPaint()
    }

    Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            var grad = ctx.createLinearGradient(0, height, 0, 0)
            grad.addColorStop(0, Qt.rgba(4/255, 2/255, 12/255, 0.9))
            grad.addColorStop(0.34, Qt.rgba(4/255, 2/255, 12/255, 0.12))
            grad.addColorStop(0.55, Qt.rgba(4/255, 2/255, 12/255, 0))
            ctx.fillStyle = grad
            ctx.fillRect(0, 0, width, height)
        }
        Component.onCompleted: requestPaint()
    }

    Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            var cx = width * 0.78
            var cy = height * 0.42
            var r = Math.max(width, height) * 0.7
            var grad = ctx.createRadialGradient(cx, cy, 0, cx, cy, r)
            grad.addColorStop(0.40, Qt.rgba(0, 0, 0, 0))
            grad.addColorStop(1, Qt.rgba(3/255, 1/255, 10/255, 0.55))
            ctx.fillStyle = grad
            ctx.fillRect(0, 0, width, height)
        }
        Component.onCompleted: requestPaint()
    }

    Item {
        anchors.fill: parent
        opacity: 0.35

        Canvas {
            id: scanCanvas
            anchors.fill: parent
            property real scrollOffset: 0

            Timer {
                interval: 50
                running: true
                repeat: true
                onTriggered: {
                    scanCanvas.scrollOffset = (scanCanvas.scrollOffset + 1) % 4
                    scanCanvas.requestPaint()
                }
            }

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                var y = scrollOffset - 4
                while (y < height) {
                    ctx.fillStyle = Qt.rgba(0, 0, 0, 0.22)
                    ctx.fillRect(0, y, width, 1)
                    y += 4
                }
            }
        }
    }
}

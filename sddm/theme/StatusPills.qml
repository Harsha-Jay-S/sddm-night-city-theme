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

    property string batteryPct: ""
    property int batteryLevel: -1
    // Baked in at install time by apply_fix.sh from /etc/os-release PRETTY_NAME.
    // (Reading it at runtime would need file XHR, disabled by default in Qt 6.)
    property string osName: "__OS_NAME__"

    // Battery IS read at runtime (it changes), so it needs file XHR. Qt 6
    // disables GET on local files unless QML_XHR_ALLOW_FILE_READ=1 is set for
    // the greeter process — apply_fix.sh adds it to /etc/environment, which the
    // greeter's pam_env loads. A successful file:// read can report status 0
    // (no HTTP status), so we key off responseText rather than status === 200.
    function tryReadBattery(n) {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "file:///sys/class/power_supply/BAT" + n + "/capacity")
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var val = (xhr.responseText || "").trim()
                if (val.length > 0) {
                    root.batteryPct = val + "%"
                    root.batteryLevel = parseInt(val)
                } else if (n < 3) {
                    root.tryReadBattery(n + 1)
                } else {
                    root.batteryPct = ""
                    root.batteryLevel = -1
                }
            }
        }
        xhr.send()
    }

    function readBattery() {
        root.tryReadBattery(0)
    }

    // Official Fedora logomark (badge + "f"), path lifted from
    // /usr/share/pixmaps/fedora_whitelogo.svg, recoloured to the theme cyan.
    function fedoraSvg(size) {
        var s = size || 24
        return "data:image/svg+xml;utf8," + encodeURIComponent(
            '<svg xmlns="http://www.w3.org/2000/svg" width="' + s + '" height="' + s + '" viewBox="0 0 25.232422 25.232422">' +
            '<path fill="#35e8ff" fill-rule="nonzero" d="M 12.617188,0 C 5.6519153,0 0.0045413,5.6437286 0,12.607422 v 9.763672 c 0.00313425,1.580948 1.2874074,2.861328 2.8691406,2.861328 h 0.013672 9.7382814 C 19.587156,25.228504 25.232422,19.582661 25.232422,12.617188 25.232422,5.6487592 19.585619,0 12.617188,0 Z m 2.55664,5.1914062 c 2.118587,0 4.119141,1.6238841 4.119141,3.8613282 0,0.2075151 -0.0012,0.4150366 -0.03516,0.6503906 -0.05864,0.5953 -0.601024,1.021414 -1.193359,0.9375 -0.592335,-0.0849 -0.9963,-0.6459928 -0.886719,-1.234375 0.01008,-0.067134 0.01563,-0.172261 0.01563,-0.3535156 0,-1.2685811 -1.037833,-1.7597656 -2.019531,-1.7597656 -0.981104,0 -1.86679,0.8244895 -1.86914,1.7578124 0.01698,1.0796308 0,2.1530148 0,3.2304688 l 1.822265,-0.01172 c 1.421606,-0.02942 1.43508,2.112421 0.01367,2.101563 l -1.835937,0.01172 c -0.0047,0.868366 0.0079,0.711099 0.0039,1.148438 0,0 0.01421,1.060057 -0.01758,1.865234 -0.219757,2.364801 -2.231688,4.25586 -4.650391,4.25586 -2.563628,0 -4.6796875,-2.096067 -4.6796875,-4.666016 0.077003,-2.643788 2.1889025,-4.723901 4.84375,-4.699219 l 1.4785155,-0.0098 v 2.101562 l -1.4785155,0.01172 H 8.7929688 C 7.333849,14.433671 6.086393,15.423749 6.0625,16.986328 c 0,1.423777 1.1503992,2.5625 2.578125,2.5625 1.425357,0 2.564453,-1.036469 2.564453,-2.560547 0.0162,-2.527496 -0.01044,-5.31813 -0.002,-7.9433591 7.89e-4,-0.1474944 0.0092,-0.2669921 0.02539,-0.4296875 0.240685,-1.9436476 1.977772,-3.4238282 3.945312,-3.4238282 z"/>' +
            '</svg>'
        )
    }

    // Battery glyph with a fill bar proportional to charge. Outline is the
    // theme cyan; the inner bar turns pink at 15% or below as a low warning.
    function batterySvg(level) {
        var lvl = Math.max(0, Math.min(100, level))
        var maxW = 14.0
        var w = maxW * lvl / 100
        var fillColor = lvl <= 15 ? "#ff5db4" : "#35e8ff"
        return "data:image/svg+xml;utf8," + encodeURIComponent(
            '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#35e8ff" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">' +
            '<rect x="1" y="6" width="18" height="12" rx="2.5"/>' +
            '<rect x="20" y="10" width="2.5" height="4" rx="1" fill="#35e8ff" stroke="none"/>' +
            (w > 0.2 ? '<rect x="2.5" y="8" width="' + w.toFixed(2) + '" height="8" rx="1" fill="' + fillColor + '" stroke="none"/>' : '') +
            '</svg>'
        )
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.readBattery()
    }

    Row {
        id: row
        spacing: 12

        Rectangle {
            height: 38
            radius: 19
            color: Qt.rgba(10/255, 8/255, 20/255, 0.5)
            border { width: 1; color: Qt.rgba(53/255, 232/255, 255/255, 0.28) }
            width: hostRow.implicitWidth + 28

            Row {
                id: hostRow
                spacing: 9
                anchors.centerIn: parent

                Image {
                    width: 17; height: 17
                    anchors.verticalCenter: parent.verticalCenter
                    source: root.fedoraSvg(17)
                    sourceSize { width: 17; height: 17 }
                }

                Label {
                    text: root.osName
                    font { family: "Chakra Petch"; pixelSize: 13; letterSpacing: 1.82 }
                    color: "#dff6ff"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Rectangle {
            id: batteryPill
            visible: root.batteryPct !== ""
            height: 38
            radius: 19
            color: Qt.rgba(10/255, 8/255, 20/255, 0.5)
            border { width: 1; color: Qt.rgba(53/255, 232/255, 255/255, 0.28) }
            width: batteryRow.implicitWidth + 28

            Row {
                id: batteryRow
                spacing: 9
                anchors.centerIn: parent

                Image {
                    width: 22; height: 14
                    anchors.verticalCenter: parent.verticalCenter
                    source: root.batterySvg(root.batteryLevel)
                    sourceSize { width: 22; height: 14 }
                }

                Label {
                    text: root.batteryPct
                    font { family: "Chakra Petch"; pixelSize: 13; letterSpacing: 1.3 }
                    color: root.batteryLevel >= 0 && root.batteryLevel <= 15 ? "#ff5db4" : "#dff6ff"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}

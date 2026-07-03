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
    // Baked in at install time by install.sh from /etc/os-release PRETTY_NAME.
    // (Reading it at runtime would need file XHR, disabled by default in Qt 6.)
    property string osName: "__OS_NAME__"
    // Baked in at install time: whichever real distro icon install.sh resolved
    // from the running system (freedesktop LOGO field, or a fallback), copied
    // next to this file. Shown in its native colours, not recoloured.
    property string logoFile: "__DISTRO_LOGO_FILE__"

    // Battery IS read at runtime (it changes), so it needs file XHR. Qt 6
    // disables GET on local files unless QML_XHR_ALLOW_FILE_READ=1 is set for
    // the greeter process — install.sh adds it to /etc/environment, which the
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
                    id: distroLogo
                    width: 17; height: 17
                    anchors.verticalCenter: parent.verticalCenter
                    source: root.logoFile
                    sourceSize { width: 17; height: 17 }
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                }

                // If the resolved icon fails to decode at runtime (missing
                // codec plugin, corrupt file), show a plain dot rather than
                // a blank gap in the pill.
                Rectangle {
                    visible: distroLogo.status === Image.Error
                    width: 17; height: 17; radius: 8.5
                    anchors.verticalCenter: parent.verticalCenter
                    color: "transparent"
                    border { width: 1.5; color: "#35e8ff" }
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

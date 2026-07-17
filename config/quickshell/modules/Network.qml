import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    width: 100
    height: 30

    anchors {
        top: parent.top
        topMargin: -6
        left: parent.left
        right: parent.right
        rightMargin: 22
    }

    property string ssid: "загрузка"

    property string networkIcon: {
        if (ssid === " " || ssid === "загрузка") return "󰤮"
        return "󰤨"
    }

    property string networkText: {
        if (ssid === "загрузка") return "загрузка"
        if (ssid === " ") return "откл"
        if (ssid.length > 10) return ssid.substring(0, 9) + "…"
        return ssid
    }

    function updateNetwork() {
        networkProc.running = true
    }

    Process {
        id: networkProc
        command: [
            "sh", "-c",
            "nmcli -t device show | grep -E '^GENERAL.CONNECTION:' | head -1 | cut -d: -f2"
        ]
        running: false

        stdout: SplitParser {
            onRead: data => {
                var result = data.trim()
                if (result === "" || result === "--") {
                    root.ssid = " "
                } else {
                    root.ssid = result
                }
                console.log("Network SSID:", root.ssid)
            }
        }
    }

    Rectangle {
        id: bg

        anchors.fill: parent
        radius: 6
        color: mouseArea.containsMouse ? "transparent" : "transparent"

        Text {
            anchors.centerIn: parent
            text: root.networkIcon
            color: "#ebdbb2"

            font {
                family: "Hack Nerd Font"
                pixelSize: 12
                weight: Font.Bold
            }

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            Quickshell.execDetached(["nm-connection-editor"])
        }
    }

    Rectangle {
        id: tooltip

        visible: mouseArea.containsMouse
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: 4

        width: tooltipText.implicitWidth + 16
        height: tooltipText.implicitHeight + 8
        radius: 4
        color: "#282828"
        border.color: "#504945"
        border.width: 1
        z: 999

        Text {
            id: tooltipText
            anchors.centerIn: parent
            text: root.networkText
            color: "#ebdbb2"
            font {
                family: "Hack Nerd Font"
                pixelSize: 11
            }
        }
    }

    Timer {
        interval: 5000
        repeat: true
        running: true

        onTriggered: updateNetwork()
    }

    Component.onCompleted: {
        updateNetwork()
        console.log("Network module started")
    }
}

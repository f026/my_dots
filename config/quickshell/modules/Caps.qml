import QtQuick 2.15
import Quickshell 0.1
import Quickshell.Io 0.1

Item {
    width: 36
    height: 6

    // Отступы вокруг модуля
    property int horizontalPadding: 0

    property bool capsActive: false

    Timer {
        interval: 3
        running: true
        repeat: true
        onTriggered: capsProcess.running = true
    }

    Process {
        id: capsProcess
        command: ["sh", "-c", "cat /sys/class/leds/input3::capslock/brightness"]
        stdout: SplitParser {
            onRead: data => capsActive = data.trim() === "1"
        }
    }

    Rectangle {
        anchors {
            fill: parent
             rightMargin:-60
             topMargin:-10
        }
        radius: 6
        color: capsActive ? "transparent" : "transparent"
        Behavior on color {
            ColorAnimation { duration: 150 }
        }

        Text {
            anchors.centerIn: parent
            text: "󰪛"
            font.pixelSize: 16
            font.bold: true
            color: capsActive ? "#ebdbb2" : "transparent"
            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }
    }
}

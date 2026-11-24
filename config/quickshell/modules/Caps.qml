import QtQuick 2.15
import Quickshell 0.1
import Quickshell.Io 0.1
import "../DynamicTheme"
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
        command: ["sh", "-c", "cat /sys/class/leds/input2::capslock/brightness"]
        stdout: SplitParser {
            onRead: data => capsActive = data.trim() === "1"
        }
    }

    Rectangle {
        anchors {
            fill: parent
            top:parent.top 
            right: parent.right
            rightMargin:2
             topMargin:-2
        }
        radius: 6
        color: capsActive ? "transparent" : "transparent"
        Behavior on color {
            ColorAnimation { duration: 150 }
        }

        Text {
            anchors.centerIn: parent
            text: "󰪛"
            font.pixelSize: 14
            font.bold: true
            color: capsActive ? Theme.primary : "transparent"
            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }
    }
}

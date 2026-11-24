import Quickshell
import Quickshell.Io
import QtQuick
import "../DynamicTheme"

Item {
    id: root

    property string command: Quickshell.env("HOME") + "/.config/quickshell/scripts/kb_layout.sh"
    property string layout: ""

    Process {
        id: listener

        command: ["bash", root.command]
        running: root.command !== ""

        stdout: SplitParser {
            onRead: data => {
                let trimmed = data.trim()

                if (trimmed !== "" && trimmed !== root.layout) {
                    root.layout = trimmed
                }
            }
        }
    }

    width: kbRow.width + 8
    height: 24

    Rectangle {
        anchors.fill: parent
        radius: 8
        opacity: 0.65
        color: "transparent"
    }

    Row {
        id: kbRow

        anchors {
    verticalCenter: parent.verticalCenter
    right: parent.right
    rightMargin: 30
}

        spacing: 2

        Text {
            font.family: "Mononoki Nerd Font Propo"
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: root.layout
            color: Theme.primary
            font.family: "Mononoki Nerd Font Propo"
            font.pixelSize: 15
            font.weight: Font.Bold
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}

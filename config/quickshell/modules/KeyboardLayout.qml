import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    property string command: "~/.config/quickshell/scripts/kb_layout.sh"
    property string layout: ""

    Process {
        id: listener
        command: root.command !== "" ? ["sh", "-c", root.command] : []
        running: root.command !== ""

        stdout: SplitParser {
            onRead: data => {
                let trimmed = data.trim()
                if (trimmed) {
                    root.layout = trimmed
                }
            }
        }
    }

    // Уменьшенная ширина
    width: kbRow.width + 8
    height: 24

    Rectangle {
        anchors.fill: parent
        radius: 8
        opacity: 0.65
        color:"transparent"
        
        
    }

    Row {
        id: kbRow 
        anchors{
            top:parent.top
            topMargin:-2
            rightMargin:0
            right:parent.right
        }
        spacing: 2
        Text {
            font.family: "Mononoki Nerd Font Propo"
            font.pixelSize: 15
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: root.layout
            color: "#ebdbb2"
            font.family: "Mononoki Nerd Font Propo"
            font.pixelSize: 15
            font.weight: Font.Bold
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}

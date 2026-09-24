import Quickshell
import Quickshell.Io
import QtQuick

ShellRoot {
    IpcHandler {
        target: "mixer"
        function toggle(): void {
            mixer.visible = !mixer.visible
        }
    }

    FloatingWindow {
        id: mixer
        visible: false
        width: 400
        height: 300

        Rectangle {
            anchors.fill: parent
            color: "#222"

            Text {
                anchors.centerIn: parent
                text: "Окно вне панели"
                color: "white"
            }
        }
    }
}

import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import qs.modules

ShellRoot {
    // Обои на первый монитор
    Walls {
        screen: Quickshell.screens.find(s => s.name === "HDMI-A-1")
    }
    // Обои на второй монитор
    Walls {
        screen: Quickshell.screens.find(s => s.name === "eDP-1")
    }

    PanelWindow {
        anchors {
            bottom: true
        }
        screen: Quickshell.screens.find(screen => screen.name === "HDMI-A-1")
        width: 1200
        height: 20
        color: "transparent"
        WrapperRectangle {
            anchors.fill: parent
            color: "#282828"
            radius: 8
            border {
                width: 2
                color: "#ebdbb2"
            }
            margin: 8
            RowLayout {
                anchors.fill: parent
                spacing: 2

                Workspaces { }
                Item { Layout.fillWidth: true }
                MediaPlayer { }

                Item { Layout.fillWidth: true }

                RowLayout {
                spacing: 26
                    Caps {}
                    KeyboardLayout {}
                    Network {}
                    Clock {}
                    // BatteryIndicator{}
                }
            }
        }
    }
}

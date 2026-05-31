import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import qs.modules

PanelWindow {
    anchors {
        bottom: true

    }
    screen: Quickshell.screens.find(screen => screen.name === "HDMI-A-1")
    width:1200
    height:20
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
            
            // ЛЕВАЯ ГРУППА (прижата к левому краю)
            Workspaces { }
            Item { Layout.fillWidth: true }
            MediaPlayer { } 
            
            // РАСПОРКА (толкает правую группу к правому краю)
            Item { Layout.fillWidth: true }
            
            // ПРАВАЯ ГРУППА (прижата к правому краю)
            RowLayout {
                spacing: 26
                Caps {} 
                KeyboardLayout { }
                Network { }
                Clock { }
            }
        }
    }
}

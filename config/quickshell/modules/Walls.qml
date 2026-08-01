import Quickshell
import Quickshell.Wayland
import QtQuick
import QtMultimedia
import Quickshell.Io

WlrLayershell {
    id: wallpaper
    layer: WlrLayer.Background
    namespace: "wallpaper"
    exclusiveZone: -1
    anchors {
        bottom: true
        top: true
        left: true
        right: true
    }
    color: "#1b1b1b"

    property int type: 1  // 1 = статика, жёстко задано
    property string staticBust: ""
    property string shaderName: ""
    // --- Статика ---
    Image {
        id: staticImg
        visible: type === 1
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        clip: true
        source: "file://" + Quickshell.env("HOME") + "/.config/hypr/wallpapers/atomic_heart.jpg" + staticBust 
        // source: "file://" + Quickshell.env("HOME") + "/.config/hypr/wallpapers/linux.png" + staticBust 
        // source: "file://" + Quickshell.env("HOME") + "/.config/hypr/wallpapers/art__pastel_clouds_dreamlike.jpg" + staticBust
    }
}

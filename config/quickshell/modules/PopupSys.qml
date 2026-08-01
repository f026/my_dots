import Quickshell
import Quickshell.Wayland
import QtQuick

Variants {
    model: [Quickshell.screens.find(screen => screen.name === "HDMI-A-1")]
    
    WlrLayershell {
        required property ShellScreen modelData
        layer: WlrLayer.Overlay
        namespace: "sys-popups"
        exclusiveZone: 0
        screen: modelData
    
        implicitWidth: 220
        implicitHeight: contentCol.implicitHeight + 6
        color: "transparent"
        anchors.bottom: true
    
        property var vl: ({})
    
        property bool showVol: false
        property bool showBright: false
        
        JsonListen {
            command: Qt.resolvedUrl("../scripts/vol.sh").toString().replace("file://", "")
            onDataChanged: {
                vl = data
                showVol = true
                volTimer.restart()
            }
        }
        
        
        
        Timer {
            id: volTimer
            interval: 2000
            onTriggered: showVol = false
        }
        
        Timer {
            id: brightTimer
            interval: 2000
            onTriggered: showBright = false
        }
        
        Column {
            id: contentCol
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6
            width: parent.width
            spacing: 6
    
            // Volume
            Rectangle {
                width: parent.width
                height: showVol ? 16 : 0
                clip: true
                radius: 8
                color: "transparent"
    
                Behavior on height {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                   }
                }
    
    
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    opacity: 0.85
                    color: "#282828"
                    
                }
    
                Item {
                    anchors.fill: parent
                    anchors.margins: 3
    
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: vl.sign ?? ""
                        color:"#ebdbb2"  
                        font.family: "Mononoki Nerd Font Propo"
                        font.pixelSize: 14
                    }
    
                    Rectangle {
                        implicitHeight: parent.height
                        implicitWidth: 200
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        radius: 5
                        opacity: 0.65
                        color:"#282828"
                        
    
                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.margins: 2
                            implicitHeight: parent.height - 4
                            implicitWidth: (vl.vol ?? 0) * 2
                            color:"#ebdbb2" 
                            radius: 3
                        }
                    }
                }
            }
    
        }
    }
}

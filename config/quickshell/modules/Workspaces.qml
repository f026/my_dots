import QtQuick
import Quickshell
import Quickshell.Hyprland

Item {
    height: 30
    width: childrenRect.width
    
    Row {
        id: row
        spacing: -2
        
        anchors {
            top: parent.top
            topMargin: -2
            left: parent.left
            leftMargin: 8
        }
        
        Repeater {
            model: Hyprland.workspaces  // Используем модель воркспейсов
            
            Rectangle {
                width: 24
                height: 26
                radius: 12
                visible: isActive || modelData.windows.length > 0  // Показываем только активный или с окнами
                property bool isActive: modelData.id === Hyprland.focusedWorkspace.id
                
                color: "transparent"
                
                Text {
                    anchors.centerIn: parent
                    text: getIcon(isActive)
                    color: isActive ? "#ebdbb2" : "#504945"
                    font {
                        family: "Hack Nerd Font"
                        weight: Font.Bold
                        pixelSize: 26
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace", modelData.id)
                }
            }
        }
    }
    
    function getIcon(isActive) {
        if (isActive) {
            return ""  // активный
        } else {
            return "󰧟"  // неактивный с окнами
        }
    }
}

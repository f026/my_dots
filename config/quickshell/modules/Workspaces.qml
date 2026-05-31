import QtQuick
import Quickshell
import Quickshell.Hyprland

Item {
    height: 30  // Высота контейнера
    width: childrenRect.width
    
    Row {
        id: row
        spacing: -4   // положительный отступ между иконками
        
        anchors {
            top: parent.top
            topMargin: -2 // отступ сверху
            left: parent.left
            leftMargin: 8  // отступ слева
        }
        
        Repeater {
            model: 10
            
            Rectangle {
                width: 24   // фиксированная ширина
                height: 24  // фиксированная высота
                radius: 12  // круглые иконки
                
                property bool isActive: Hyprland.focusedWorkspace?.id === index + 1
                
                color: isActive ? "transparent" : "transparent"
                
                Text {
                    anchors.centerIn: parent
                    text: getIcon(isActive)
                    color: isActive ? "#ebdbb2" : "white"
                    font {
                        family: "Hack Nerd Font"
                        pixelSize: 16  // увеличен для лучшего отображения иконок
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace", index + 1)
                }
            }
        }
    }
    
    function getIcon(isActive) {
        if (isActive) {
            return ""      // активный
        } else {
            return "󰧞"      // неактивный
        }
    }
}

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Item {
    id: root
    width: 64
    height: 24

    readonly property var battery: UPower.displayDevice

    Rectangle {
        id: outline
        width: 40
        height: 18
        anchors.verticalCenter: parent.verticalCenter

        radius: 3
        color: "transparent"
        border.width: 2
        border.color: "#dcdcdc"

        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: -20
            anchors.verticalCenter: parent.verticalCenter

            width: (parent.width - 4) * (battery.percentage / 100)
            height: parent.height - 4
            radius: 2

            color:
                battery.percentage > 50 ? "#4CAF50" :
                battery.percentage > 20 ? "#FFC107" :
                                          "#F44336"

            Behavior on width {
                NumberAnimation {
                    duration: 250
                }
            }
        }

        Rectangle {
            width: 4
            height: 2
            radius: 1
            // anchors.left: parent.right
            anchors.leftMargin: 2
            anchors.verticalCenter: parent.verticalCenter
            color: "#dcdcdc"
        }
    }

    Text {
        anchors.left: outline.right
        anchors.leftMargin: 2
        anchors.verticalCenter: parent.verticalCenter

        text: Math.round(battery.percentage) + "%"
        color: "#dcdcdc"
        font.pixelSize: 10
    }
}

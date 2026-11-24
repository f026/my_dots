
import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../DynamicTheme"

Item {
    height: 30
    width: childrenRect.width

    Row {
        id: row
        spacing: -2

        anchors {
            top: parent.top
            // topMargin: 0
            left: parent.left
            leftMargin: -2
        }

        Repeater {
            model: Hyprland.workspaces

            Rectangle {
                width: 24
                height: 26
                radius: 12

                visible: isActive || modelData.windows.length > 0

                property bool isActive:
                    modelData.id === Hyprland.focusedWorkspace.id

                property bool hovered: false

                color: "transparent"

                Text {
                    anchors.centerIn: parent

                    text: getIcon(isActive)

                    color: {
                        if (isActive)
                            return Theme.primary

                        if (parent.hovered)
                            return Theme.secondary

                        return Theme.subtext
                    }

                    font {
                        family: "Hack Nerd Font"
                        weight: Font.Bold
                        pixelSize: 20
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 180
                            easing.type: Easing.InOutCubic
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false

                    onClicked: {
                        Hyprland.dispatch(
                            "workspace",
                            modelData.id
                        )
                    }
                }
            }
        }
    }

    function getIcon(isActive) {
        if (isActive)
            return ""

        return "󰧟"
    }
}


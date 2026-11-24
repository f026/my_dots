import QtQuick
import "../DynamicTheme"

Item {
    id: root
    property int clockOffsetY: -1
    width: 18
    height: 4

    Text {
        id: clockText

        anchors {
    verticalCenter: parent.verticalCenter
    verticalCenterOffset: root.clockOffsetY
    right: parent.right
    rightMargin: 4
}

        color: Theme.primary
        font.pixelSize: 14
        font.weight: Font.Bold

        function updateTime() {
            clockText.text = Qt.formatTime(new Date(), "HH:mm")
        }

        Component.onCompleted: updateTime()

        Timer {
            interval: 1000
            repeat: true
            running: true
            onTriggered: clockText.updateTime()
        }

        Behavior on color {
            ColorAnimation {
                duration: Theme.animationDuration
                easing.type: Easing.InOutCubic
            }
        }
    }
}


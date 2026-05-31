import QtQuick

Rectangle {
    width: 20
    height: 30
    color: "transparent"
    radius: 6
    
    Text {
        id: clockText
        color: "#ebdbb2"
        font.pixelSize: 12
        text: "time"
        anchors{
            top:parent.top
            topMargin:2
            rightMargin:12
            right:parent.right
        }

            font.weight: Font.Bold
        
        Timer {
            interval: 10
            repeat: true
            running: true
            onTriggered: {
                var date = new Date()
                var hours = date.getHours()
                var minutes = date.getMinutes()
                var hoursStr = hours < 10 ? "0" + hours : "" + hours
                var minutesStr = minutes < 10 ? "0" + minutes : "" + minutes
                var timeString = hoursStr + ":" + minutesStr
                
                console.log("Time:", timeString)
                
                // Принудительное обновление через Qt.callLater
                Qt.callLater(function() {
                    clockText.text = timeString
                })
            }
        }
    }
}

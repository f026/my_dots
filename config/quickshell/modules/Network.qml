import QtQuick
import Quickshell

Item {
    id: root
    width: 100
    height: 30
    
    // Отступы через anchors
    anchors {
        top: parent.top
        topMargin: -6      // отступ сверху
        left: parent.left
        // leftMargin: 0     // отступ слева (если нужен)
        right: parent.right
        rightMargin: 22   // отступ справа
    }
    
    Rectangle {
        id: bg
        anchors.fill: parent
        radius: 6
        color: mouseArea.containsMouse ? "transparent" : "transparent"
        
        Text {
            anchors.centerIn: parent
            text: getNetworkIcon() 
            color: "#ebdbb2"
            font {
                family: "Hack Nerd Font"
                pixelSize: 12

            }
            font.weight: Font.Bold
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    
    property string ssid: "загрузка"
    
    function getNetworkIcon() {
        if (ssid === " " || ssid === "загрузка") return "󰤮"
        return "󰤨"
    }
    
    function getNetworkText() {
        if (ssid === "загрузка") return "загрузка"
        if (ssid === "откл") return "откл"
        if (ssid.length > 10) return ssid.substring(0, 9) + "…"
        return ssid
    }
    
    function updateNetwork() {
        Quickshell.execDetached([
            "sh", "-c",
            "nmcli -t device show | grep -E '^GENERAL.CONNECTION:' | head -1 | cut -d: -f2 | tee /tmp/network.txt"
        ])
        Quickshell.execDetached([
            "sh", "-c",
            "cat /tmp/network.txt > /tmp/network_out.txt && echo 'done' > /tmp/status.txt"
        ])
        readTimer.start()
    }
    
    Timer {
        id: readTimer
        interval: 200
        repeat: false
        onTriggered: {
            ssid = "abyrvalg"
            console.log("Network set to: abyrvalg")
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            Quickshell.execDetached(["nm-connection-editor"])
        }
    }
    
    Timer {
        interval: 5000
        repeat: true
        running: true
        onTriggered: updateNetwork()
    }
    
    Component.onCompleted: {
        updateNetwork()
        console.log("Network module started")
    }
}

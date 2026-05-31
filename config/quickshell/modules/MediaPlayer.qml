import QtQuick
import Quickshell
import Quickshell.Io

Rectangle {
    id: root
    color: "transparent"
    radius: 6
    height: 30
    width: 220
    clip: true
    
    // Скрываем модуль, если нет трека
    visible: trackInfo !== "" && trackInfo !== " Нет медиа"
    
    anchors {
        centerIn: parent
        topMargin: 4
        rightMargin: 12
    }
    
    property string trackInfo: ""
    property string playState: "⏸"
    property int textOffset: 8
    property string lastTrack: ""
    
    Text {
        id: playPauseIcon
        text: playState
        color: "#ebdbb2"
        font {
            family: "Hack Nerd Font"
            pixelSize: 12
        }
        anchors {
            left: parent.left
            leftMargin: 8
            verticalCenter: parent.verticalCenter
        }
        z: 1
    }
    
    Item {
        id: marqueeContainer
        anchors {
            left: playPauseIcon.right
            leftMargin: 6
            right: parent.right
            rightMargin: 8
            verticalCenter: parent.verticalCenter
        }
        height: 24
        clip: true
        
        Text {
            id: trackText
            text: root.trackInfo
            color: "#ebdbb2"
            font.pixelSize: 12
            font.weight: Font.Bold
            anchors.verticalCenter: parent.verticalCenter
            x: root.textOffset
            
            onContentWidthChanged: {
                if (trackText.contentWidth > marqueeContainer.width) {
                    if (!scrollTimer.running) {
                        startScrolling()
                    }
                } else {
                    scrollTimer.stop()
                    root.textOffset = 8
                }
            }
        }
    }
    
    function startScrolling() {
        scrollTimer.stop()
        root.textOffset = marqueeContainer.width
        scrollTimer.start()
    }
    
    Timer {
        id: scrollTimer
        interval: 50
        repeat: true
        running: false
        onTriggered: {
            root.textOffset -= 1
            if (root.textOffset <= -trackText.contentWidth) {
                root.textOffset = marqueeContainer.width
            }
        }
    }
    
    Process {
        id: mediaProc
        command: ["sh", "-c", "playerctl metadata --format '{{ artist }} - {{ title }}' 2>/dev/null"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                var info = this.text.trim()
                if (info !== "" && info !== " - " && info !== "None") {
                    var newTrack = "" + info
                    if (root.lastTrack !== newTrack) {
                        root.lastTrack = newTrack
                        root.trackInfo = newTrack
                        console.log("New track:", newTrack)
                    }
                } else {
                    if (root.trackInfo !== "") {
                        root.trackInfo = ""
                        root.lastTrack = ""
                        scrollTimer.stop()
                        root.textOffset = 8
                        console.log("No media playing")
                    }
                }
                restartTimer.start()
            }
        }
    }
    
    Process {
        id: statusProc
        command: ["sh", "-c", "playerctl status 2>/dev/null"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                var status = this.text.trim()
                if (status === "Playing") {
                    root.playState = "▶"
                } else if (status === "Paused") {
                    root.playState = "⏸"
                } else {
                    root.playState = "⏹"
                }
                statusRestartTimer.start()
            }
        }
    }
    
    Timer {
        id: restartTimer
        interval: 3
        repeat: false
        onTriggered: mediaProc.running = true
    }
    
    Timer {
        id: statusRestartTimer
        interval: 30
        repeat: false
        onTriggered: statusProc.running = true
    }
    
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            // Quickshell.execDetached(["playerctl", "play-pause"])
            Qt.callLater(function() { statusProc.running = true }, 50)
        }
    }
    
    Component.onCompleted: {
        mediaProc.running = true
        statusProc.running = true
        console.log("MediaPlayer started")
    }
}

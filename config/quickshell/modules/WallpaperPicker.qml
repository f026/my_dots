
import QtQuick
import Quickshell
import Quickshell.Io
import "../DynamicTheme"

Item {
    id: root

    property var walls
    property var panelWindow

    property string wallpaperDir:
        Quickshell.env("HOME") + "/.config/hypr/wallpapers"

    property var wallpapers: []

    width: 30
    height: 30

    function refreshWallpapers() {
        wallpaperList.command = [
            "find",
            wallpaperDir,
            "-maxdepth", "1",
            "-type", "f",
            "(",
            "-iname", "*.png",
            "-o", "-iname", "*.jpg",
            "-o", "-iname", "*.jpeg",
            "-o", "-iname", "*.webp",
            ")",
            "-print"
        ]

        wallpaperList.running = true
    }

    function selectWallpaper(path) {
        if (!walls || !path)
            return

        walls.currentWallpaperPath = path
        popup.visible = false
    }

    Process {
        id: wallpaperList

        stdout: StdioCollector {
            onStreamFinished: {
                root.wallpapers = text
                    .trim()
                    .split("\n")
                    .filter(path => path.length > 0)
                    .sort()
            }
        }

        onExited: (code, status) => {
            if (code !== 0)
                console.warn("Wallpaper list failed:", code)
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 8

        color:"transparent"

        Text {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -2
            text: ""
            color: Theme.primary
            font.pixelSize: 14
}

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                if (!popup.visible)
                    root.refreshWallpapers()

                popup.visible = !popup.visible
            }
        }
    }

    PopupWindow {
        id: popup

        anchor.window: root.panelWindow

        anchor.rect.x:
            trigger.mapToItem(null, 0, 0).x
            + trigger.width / 2 - width / 2

        anchor.rect.y: -height - 8
        anchor.rect.width: 1
        anchor.rect.height: 1

        width: 260

        height: 48 + (
            root.wallpapers.length === 0
                ? 24
                : Math.min(
                    Math.ceil(root.wallpapers.length / 3) * 80,
                    240
                )
        )

        visible: false

        color: "transparent"

        Rectangle {
            anchors.fill: parent
            radius: 12
            color: Theme.surface
            border.width: 1
            border.color: Theme.border

            Column {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 6

                Text {
                    text: "Wallpapers"
                    color: Theme.text
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                }

                GridView {
                    id: wallGrid

                    width: 244

                    height: root.wallpapers.length === 0
                        ? 0
                        : Math.min(
                            Math.ceil(root.wallpapers.length / 3) * 80,
                            240
                        )

                    cellWidth: 80
                    cellHeight: 80

                    clip: true
                    model: root.wallpapers

                    delegate: Item {
                        required property string modelData

                        width: 80
                        height: 80

                        Rectangle {

                            width: 76
                            height: 76

                            radius: 7
                            color: "transparent"
                            clip: true

                            border.width:
                                root.walls &&
                                root.walls.currentWallpaperPath === modelData
                                    ? 2 : 0

                            border.color: Theme.primary

                            Image {
                                anchors.fill: parent
                                anchors.margins: 2

                                source: "file://" + modelData

                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                                cache: true
                            }

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    root.selectWallpaper(modelData)
                                }
                            }
                        }
                    }
                }

                Text {
                    visible: root.wallpapers.length === 0
                    text: "No wallpapers found"
                    color: Theme.subtext
                    font.pixelSize: 11
                }
            }
        }
    }
}


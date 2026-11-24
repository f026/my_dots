
import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import Quickshell.Io
import qs.modules
import "DynamicTheme"

ShellRoot {
    // Обои
    Walls {
        id: mainWalls

        screen: Quickshell.screens.find(s => s.name === "HDMI-A-1")

        onWallpaperReady: path => {
            notifications.showInternal(
                "Обои изменены",
                "Палитра оформления успешно обновлена.",
                5000
            )
        }
    }

    // Меню питания
    PowerMenu {
        id: powerMenu
    }

    // Аудиобэкенд
    AudioBackend {
        id: audioBackend
    }

    // Уведомления
    Notifications {
        id: notifications
    }

    // Switcher — отдельное окно
    Switcher {
        id: switcher

        screen: Quickshell.screens.find(
            screen => screen.name === "HDMI-A-1"
        )

        width: 1200
        height: 20
        color: "transparent"
    }

    // Основная панель
    PanelWindow {
        id: mainPanel

        color: "transparent"

        anchors {
            bottom: true
        }

        width: 1200
        height: 24

        WrapperRectangle {
            anchors.fill: parent

            color: Theme.surface
            radius: 8
            margin: 0

            border.width: 1
            border.color: Theme.primary

            RowLayout {
                anchors.fill: parent
                spacing: 0

                WallpaperPicker {
                    walls: mainWalls
                    panelWindow: mainPanel

                    Layout.preferredWidth: 30
                    Layout.minimumWidth: 30
                    Layout.maximumWidth: 30
                    Layout.preferredHeight: 24
                    Layout.alignment: Qt.AlignVCenter
                }

                Workspaces {}

                Item {
                    Layout.fillWidth: true
                }

                PopupSys {}
                MediaPlayer {}

                // Правые системные модули
                RowLayout {
    spacing: 10
    Layout.alignment: Qt.AlignVCenter

    Caps {}

    KeyboardLayout {}

    // Item {
    //     id: audioButton
    //
    //     Layout.preferredWidth: 28
    //     Layout.preferredHeight: 24
    //
    //     Text {
    //         anchors.centerIn: parent
    //         text: "♫"
    //         color: Theme.primary
    //         font.pixelSize: 14
    //     }
    //
    //     MouseArea {
    //         anchors.fill: parent
    //         cursorShape: Qt.PointingHandCursor
    //
    //         onClicked: audioPopup.visible = !audioPopup.visible
    //     }
    // }

    Clock {}
}
            }
        }
    }

    // Всплывающий аудиомикшер
    PopupWindow {
    id: audioPopup

    anchor.window: mainPanel

    anchor.rect.x: audioButton.mapToItem(
        mainPanel.contentItem, 0, 500
    ).x

    anchor.rect.y: audioButton.mapToItem(
        mainPanel.contentItem, 0, 0
    ).y

    anchor.rect.width: audioButton.width
    anchor.rect.height: audioButton.height

    anchor.edges: Edges.Bottom | Edges.Right
    anchor.gravity: Edges.Top | Edges.Right

    implicitWidth: 380
    implicitHeight: 400

    color: "transparent"

    visible: false
    grabFocus: true

    Playback {
        anchors.fill: parent
        backend: audioBackend
    }
}
}


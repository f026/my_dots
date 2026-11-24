import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../DynamicTheme"

WlrLayershell {
    id: root

    // Пока используем тот же основной монитор, что и shell.qml.
    // Позже можно расширить меню на все экраны.
    screen: Quickshell.screens.find(screen => screen.name === "HDMI-A-1")

    layer: WlrLayer.Overlay
    namespace: "power-menu"
    exclusiveZone: 0
    keyboardFocus: opened ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"

    property bool opened: false
    property string confirmAction: ""
    property string confirmTitle: ""
    property string confirmDescription: ""

    function openMenu() {
        confirmAction = ""
        opened = true
        scene.forceActiveFocus()
    }

    function closeMenu() {
        opened = false
        confirmAction = ""
    }

    function toggleMenu() {
        if (opened)
            closeMenu()
        else
            openMenu()
    }

    function requestAction(action) {
        if (action === "reboot") {
            confirmAction = action
            confirmTitle = "Перезагрузить компьютер?"
            confirmDescription = "Все открытые приложения будут закрыты."
            return
        }

        if (action === "shutdown") {
            confirmAction = action
            confirmTitle = "Выключить компьютер?"
            confirmDescription = "Текущая сессия будет завершена."
            return
        }

        runAction(action)
    }

    function runAction(action) {
        closeMenu()

        switch (action) {
        case "lock":
            Quickshell.execDetached("hyprlock")
            break

        case "logout":
            Quickshell.execDetached(["hyprctl", "dispatch", "exit"])
            break

        case "suspend":
        Quickshell.execDetached([
            "bash",
            "-c",
            "hyprlock &  systemctl suspend"
        ])
            break

        case "reboot":
            Quickshell.execDetached(["systemctl", "reboot"])
            break

        case "shutdown":
            Quickshell.execDetached(["systemctl", "poweroff"])
            break
        }
    }

    IpcHandler {
        target: "power-menu"

        function open() {
            root.openMenu()
        }

        function close() {
            root.closeMenu()
        }

        function toggle() {
            root.toggleMenu()
        }
    }

    Timer {
        id: closeAnimationTimer
        interval: 190
        repeat: false
        onTriggered: {
            // Таймер нужен только для удержания окна на экране
            // во время анимации закрытия.
        }
    }

    visible: opened || closeAnimationTimer.running

    onOpenedChanged: {
        if (!opened)
            closeAnimationTimer.restart()
        else
            closeAnimationTimer.stop()
    }

    Item {
        id: scene
        anchors.fill: parent
        focus: true

        Keys.onPressed: event => {
            // На экране подтверждения доступны только Enter и Escape.
            if (root.confirmAction !== "") {
                if (event.key === Qt.Key_Escape) {
                    root.confirmAction = ""
                    event.accepted = true
                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    root.runAction(root.confirmAction)
                    event.accepted = true
                }
                return
            }

            switch (event.key) {
            case Qt.Key_L:
                root.requestAction("lock")
                break
            case Qt.Key_E:
                root.requestAction("logout")
                break
            case Qt.Key_U:
                root.requestAction("suspend")
                break
            case Qt.Key_R:
                root.requestAction("reboot")
                break
            case Qt.Key_S:
                root.requestAction("shutdown")
                break
            case Qt.Key_Escape:
                root.closeMenu()
                break
            default:
                return
            }

            event.accepted = true
        }

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            opacity: root.opened ? 1 : 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 190
                    easing.type: Easing.OutCubic
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.closeMenu()
            }
        }

        Rectangle {
            id: panel

            width: 520
            height: root.confirmAction === "" ? 370 : 300
            anchors.centerIn: parent

            radius: 24
            color: Theme.background
            border.width: 1
            border.color: Theme.border

            opacity: root.opened ? 1 : 0
            scale: root.opened ? 1 : 0.965

            Behavior on opacity {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 260
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on height {
                NumberAnimation {
                    duration: 180
                    easing.type: Easing.InOutCubic
                }
            }

            Behavior on color {
                ColorAnimation {
                    duration: Theme.animationDuration
                    easing.type: Easing.InOutCubic
                }
            }

            Behavior on border.color {
                ColorAnimation {
                    duration: Theme.animationDuration
                    easing.type: Easing.InOutCubic
                }
            }

            // Основной экран меню
            Column {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 18
                visible: root.confirmAction === ""

                Text {
                    width: parent.width
                    text: "Завершение сеанса"
                    color: Theme.text
                    font.family: "Inter"
                    font.pixelSize: 23
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignHCenter

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.animationDuration
                            easing.type: Easing.InOutCubic
                        }
                    }
                }

                Text {
                    width: parent.width
                    text: "Выберите действие"
                    color: Theme.subtext
                    font.family: "Inter"
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignHCenter

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.animationDuration
                            easing.type: Easing.InOutCubic
                        }
                    }
                }

                Grid {
                    width: parent.width
                    columns: 3
                    spacing: 12

                    PowerAction {
                        width: 144
                        height: 112
                        iconText: "󰌾"
                        title: "Блокировка"
                        description: "Заблокировать экран"
                        accentColor: Theme.primary
                        onClicked: root.requestAction("lock")
                    }

                    PowerAction {
                        width: 144
                        height: 112
                        iconText: "󰍃"
                        title: "Выход"
                        description: "Завершить сеанс"
                        accentColor: Theme.primary
                        onClicked: root.requestAction("logout")
                    }

                    PowerAction {
                        width: 144
                        height: 112
                        iconText: "󰤄"
                        title: "Сон"
                        description: "Приостановить работу"
                        accentColor: Theme.primary
                        onClicked: root.requestAction("suspend")
                    }

                    PowerAction {
                        width: 144
                        height: 112
                        iconText: "󰜉"
                        title: "Перезагрузка"
                        description: "Перезапустить ПК"
                        accentColor: Theme.primary
                        onClicked: root.requestAction("reboot")
                    }

                    PowerAction {
                        width: 144
                        height: 112
                        iconText: "󰐥"
                        title: "Выключение"
                        description: "Завершить работу"
                        accentColor: Theme.primary
                        onClicked: root.requestAction("shutdown")
                    }

                    PowerAction {
                        width: 144
                        height: 112
                        iconText: "󰅖"
                        title: "Отмена"
                        description: "Вернуться на рабочий стол"
                        accentColor: Theme.primary
                        onClicked: root.closeMenu()
                    }
                }
            }

            // Подтверждение перезагрузки / выключения
            Column {
                anchors.fill: parent
                anchors.margins: 28
                spacing: 16
                visible: root.confirmAction !== ""

                Text {
                    width: parent.width
                    text: root.confirmTitle
                    color: Theme.text
                    font.family: "Inter"
                    font.pixelSize: 21
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }

                Text {
                    width: parent.width
                    text: root.confirmDescription
                    color: Theme.subtext
                    font.family: "Inter"
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }

                Item {
                    width: 1
                    height: 12
                }

                Rectangle {
                    width: parent.width
                    height: 48
                    radius: 14
                    color: Theme.primary

                    Text {
                        anchors.centerIn: parent
                        text: "Подтвердить"
                        color: Theme.primaryForeground
                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.runAction(root.confirmAction)
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.animationDuration
                            easing.type: Easing.InOutCubic
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 44
                    radius: 14
                    color: Theme.surfaceVariant

                    Text {
                        anchors.centerIn: parent
                        text: "Назад"
                        color: Theme.text
                        font.family: "Inter"
                        font.pixelSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.confirmAction = ""
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.animationDuration
                            easing.type: Easing.InOutCubic
                        }
                    }
                }
            }
        }
    }

    component PowerAction: Rectangle {
        id: actionRoot

        property string iconText: ""
        property string title: ""
        property string description: ""
        property color accentColor: Theme.primary
        signal clicked()

        radius: 17
        color: mouseArea.containsMouse ? Theme.surfaceVariant : Theme.surface
        border.width: mouseArea.containsMouse ? 1 : 0
        border.color: Theme.border

        Behavior on color {
            ColorAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }

        Behavior on border.color {
            ColorAnimation {
                duration: Theme.animationDuration
                easing.type: Easing.InOutCubic
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: 7

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: actionRoot.iconText
                color: actionRoot.accentColor
                font.family: "Hack Nerd Font"
                font.pixelSize: 29

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.animationDuration
                        easing.type: Easing.InOutCubic
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: actionRoot.title
                color: Theme.text
                font.family: "Inter"
                font.pixelSize: 12
                font.weight: Font.DemiBold

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.animationDuration
                        easing.type: Easing.InOutCubic
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: actionRoot.description
                color: Theme.subtext
                font.family: "Inter"
                font.pixelSize: 9

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.animationDuration
                        easing.type: Easing.InOutCubic
                    }
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: actionRoot.clicked()
        }
    }
}

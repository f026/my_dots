
import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import "../DynamicTheme"

Scope {
    id: root

    property int nextInternalId: 0

    // Внутренние уведомления Quickshell
    ListModel {
        id: internalNotifications
    }

    function showInternal(title, message, timeout) {
        internalNotifications.append({
            notificationId: nextInternalId++,
            title: title,
            message: message,
            timeout: timeout > 0 ? timeout : 5000
        })
    }

    function removeInternal(id) {
        for (let i = 0; i < internalNotifications.count; i++) {
            if (internalNotifications.get(i).notificationId === id) {
                internalNotifications.remove(i)
                return
            }
        }
    }

    // Системные уведомления (Telegram и другие приложения)
    NotificationServer {
        id: notificationServer

        actionsSupported: true

        onNotification: notif => {
            console.log("[Notifications] RECEIVED:", notif.summary)
            notif.tracked = true

            console.log(
                "[Notifications] Timeout:",
                notif.appName,
                notif.expireTimeout
            )
        }
    }

    PanelWindow {
        id: popupWindow

        anchors {
            top: true
            right: true
        }

        margins {
            top: 16
            right: 16
        }

        exclusiveZone: 0
        focusable: false
        color: "transparent"

        implicitWidth: 384
        implicitHeight: notificationColumn.implicitHeight + 24

        visible: notificationServer.trackedNotifications.values.length > 0
            || internalNotifications.count > 0

        Column {
            id: notificationColumn

            anchors {
                top: parent.top
                right: parent.right
                margins: 12
            }

            width: 360
            spacing: 10

            // Telegram и остальные системные уведомления
            Repeater {
                model: notificationServer.trackedNotifications

                delegate: Rectangle {
                    id: card

                    required property var modelData

                    width: notificationColumn.width
                    implicitHeight: content.implicitHeight + 28

                    radius: 14

                    color: Theme.surface
                    border.width: 1
                    border.color: Theme.border

                    opacity: 1
                    scale: 1

                    NumberAnimation on opacity {
                        from: 0
                        to: 1
                        duration: 200
                        easing.type: Easing.OutCubic
                    }

                    NumberAnimation on scale {
                        from: 0.96
                        to: 1
                        duration: 220
                        easing.type: Easing.OutCubic
                    }

                    Timer {
                        id: expirationTimer

                        interval: card.modelData.expireTimeout > 0
                            ? card.modelData.expireTimeout
                            : 6000

                        running: true
                        repeat: false

                        onTriggered: {
                            console.log(
                                "[Notifications] Expiring:",
                                card.modelData.appName,
                                "timeout:",
                                card.modelData.expireTimeout
                            )

                            fadeOut.start()
                        }
                    }

                    NumberAnimation {
                        id: fadeOut

                        target: card
                        property: "opacity"

                        to: 0
                        duration: 250

                        easing.type: Easing.InCubic

                        onFinished: {
                            card.modelData.tracked = false
                        }
                    }

                    Column {
                        id: content

                        anchors {
                            fill: parent
                            margins: 14
                        }

                        spacing: 7

                        Row {
                            width: parent.width
                            spacing: 8

                            Text {
                                id: appLabel

                                width: parent.width - closeButton.width - 8

                                text: card.modelData.appName || "Уведомление"

                                color: Theme.subtext
                                font.pixelSize: 11
                                font.weight: Font.Medium

                                elide: Text.ElideRight

                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Rectangle {
                                id: closeButton

                                width: 22
                                height: 22
                                radius: 7

                                color: closeMouse.containsMouse
                                    ? Theme.surfaceVariant
                                    : "transparent"

                                Text {
                                    anchors.centerIn: parent

                                    text: "×"
                                    color: Theme.subtext
                                    font.pixelSize: 18
                                }

                                MouseArea {
                                    id: closeMouse

                                    anchors.fill: parent
                                    hoverEnabled: true

                                    onClicked: {
                                        expirationTimer.stop()
                                        fadeOut.start()

                                        fadeOut.onFinished = function() {
                                            card.modelData.dismiss()
                                        }
                                    }
                                }
                            }
                        }

                        Text {
                            width: parent.width

                            text: card.modelData.summary || ""

                            color: Theme.text

                            font.pixelSize: 15
                            font.weight: Font.DemiBold

                            wrapMode: Text.Wrap
                            textFormat: Text.PlainText
                        }

                        Text {
                            width: parent.width

                            text: card.modelData.body || ""
                            visible: text.length > 0

                            color: Theme.subtext
                            font.pixelSize: 13

                            wrapMode: Text.Wrap
                            maximumLineCount: 4
                            elide: Text.ElideRight

                            textFormat: Text.PlainText
                        }

                        Row {
                            width: parent.width
                            spacing: 7

                            visible: card.modelData.actions.length > 0

                            Repeater {
                                model: card.modelData.actions

                                delegate: Rectangle {
                                    id: actionButton

                                    required property var modelData

                                    width: actionText.implicitWidth + 20
                                    height: 28

                                    radius: 8
                                    color: Theme.surfaceVariant

                                    Text {
                                        id: actionText

                                        anchors.centerIn: parent

                                        text: actionButton.modelData.text

                                        color: Theme.text
                                        font.pixelSize: 12
                                        font.weight: Font.Medium
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true

                                        onClicked: {
                                            expirationTimer.stop()
                                            actionButton.modelData.invoke()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Внутренние уведомления Quickshell
            Repeater {
                model: internalNotifications

                delegate: Rectangle {
                    id: internalCard

                    required property int notificationId
                    required property string title
                    required property string message
                    required property int timeout

                    width: notificationColumn.width
                    implicitHeight: internalContent.implicitHeight + 28

                    radius: 14

                    color: Theme.surface
                    border.width: 1
                    border.color: Theme.border

                    opacity: 1
                    scale: 1

                    NumberAnimation on opacity {
                        from: 0
                        to: 1
                        duration: 200
                        easing.type: Easing.OutCubic
                    }

                    NumberAnimation on scale {
                        from: 0.96
                        to: 1
                        duration: 220
                        easing.type: Easing.OutCubic
                    }

                    Timer {
                        id: internalTimer

                        interval: internalCard.timeout
                        running: true
                        repeat: false

                        onTriggered: internalFade.start()
                    }

                    NumberAnimation {
                        id: internalFade

                        target: internalCard
                        property: "opacity"

                        to: 0
                        duration: 250

                        easing.type: Easing.InCubic

                        onFinished: {
                            root.removeInternal(internalCard.notificationId)
                        }
                    }

                    Column {
                        id: internalContent

                        anchors {
                            fill: parent
                            margins: 14
                        }

                        spacing: 7

                        Row {
                            width: parent.width
                            spacing: 8

                            Text {
                                width: parent.width - 30

                                text: "Quickshell"

                                color: Theme.subtext
                                font.pixelSize: 11
                                font.weight: Font.Medium

                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Rectangle {
                                width: 22
                                height: 22
                                radius: 7

                                color: internalCloseMouse.containsMouse
                                    ? Theme.surfaceVariant
                                    : "transparent"

                                Text {
                                    anchors.centerIn: parent

                                    text: "×"
                                    color: Theme.subtext
                                    font.pixelSize: 18
                                }

                                MouseArea {
                                    id: internalCloseMouse

                                    anchors.fill: parent
                                    hoverEnabled: true

                                    onClicked: {
                                        internalTimer.stop()
                                        internalFade.start()
                                    }
                                }
                            }
                        }

                        Text {
                            width: parent.width

                            text: internalCard.title

                            color: Theme.text

                            font.pixelSize: 15
                            font.weight: Font.DemiBold

                            wrapMode: Text.Wrap
                            textFormat: Text.PlainText
                        }

                        Text {
                            width: parent.width

                            text: internalCard.message
                            visible: text.length > 0

                            color: Theme.subtext
                            font.pixelSize: 13

                            wrapMode: Text.Wrap
                            maximumLineCount: 4
                            elide: Text.ElideRight

                            textFormat: Text.PlainText
                        }
                    }
                }
            }
        }
    }
}


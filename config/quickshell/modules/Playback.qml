
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../DynamicTheme"

Column {
    id: root

    property var backend: null

    width: 360
    spacing: 10

    Text {
        text: "Воспроизведение"
        color: Theme.text
        font.pixelSize: 18
        font.bold: true
    }

    Text {
        visible: !root.backend || root.backend.playbackNodes.length === 0

        text: "Нет активных аудиопотоков"
        color: Theme.subtext
        font.pixelSize: 13
    }

    Repeater {
        model: root.backend ? root.backend.playbackNodes : []

        delegate: Rectangle {
            id: card

            required property var modelData

            width: root.width
            height: 92

            radius: 12
            color: Theme.surface

            border.width: 1
            border.color: Theme.border

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 6

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Rectangle {
                        width: 34
                        height: 34
                        radius: 9
                        color: Theme.surfaceVariant

                        Text {
                            anchors.centerIn: parent
                            text: "♫"
                            color: Theme.primary
                            font.pixelSize: 20
                        }
                    }

                    Text {
                        Layout.fillWidth: true

                        text: {
                            const props = card.modelData.properties
                            return props["application.name"]
                                || props["node.description"]
                                || card.modelData.description
                                || card.modelData.name
                        }

                        color: Theme.text
                        font.pixelSize: 14
                        font.bold: true
                        elide: Text.ElideRight
                    }

                    Text {
                        text: Math.round(card.modelData.audio.volume * 100) + "%"
                        color: Theme.subtext
                        font.pixelSize: 12
                    }

                    Rectangle {
                        width: 30
                        height: 30
                        radius: 8
                        color: muteArea.containsMouse
                            ? Theme.surfaceVariant
                            : "transparent"

                        Text {
                            anchors.centerIn: parent

                            text: card.modelData.audio.muted ? "×" : "♫"
                            color: card.modelData.audio.muted
                                ? Theme.secondary
                                : Theme.primary

                            font.pixelSize: 17
                        }

                        MouseArea {
                            id: muteArea
                            anchors.fill: parent
                            hoverEnabled: true

                            onClicked: {
                                root.backend.toggleMute(card.modelData)
                            }
                        }
                    }
                }

                Slider {
                    id: volumeSlider

                    Layout.fillWidth: true

                    from: 0
                    to: 1.5
                    stepSize: 0.01

                    value: card.modelData.audio.volume

                    onMoved: {
                        root.backend.setVolume(
                            card.modelData,
                            value
                        )
                    }
                }
            }
        }
    }
}



import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Scope {
    id: root

    // Все узлы PipeWire
    readonly property var nodes: Pipewire.nodes.values

    // Состояние PipeWire
    readonly property bool ready: Pipewire.ready

    // Устройства по умолчанию
    readonly property var defaultOutput: Pipewire.defaultAudioSink
    readonly property var defaultInput: Pipewire.defaultAudioSource

    // Приложения, воспроизводящие звук
    readonly property var playbackNodes: nodes.filter(function(node) {
        return node.isStream && node.isSink && node.audio
    })

    // Приложения, записывающие звук
    readonly property var recordingNodes: nodes.filter(function(node) {
        return node.isStream && !node.isSink && node.audio
    })

    // Устройства вывода
    readonly property var outputDevices: nodes.filter(function(node) {
        return !node.isStream && node.isSink && node.audio
    })

    // Устройства ввода
    readonly property var inputDevices: nodes.filter(function(node) {
        return !node.isStream && !node.isSink && node.audio
    })

    // Отслеживание аудиоузлов
    PwObjectTracker {
        objects: Pipewire.nodes.values
    }

    // Изменение громкости
    function setVolume(node, value) {
        if (!node || !node.audio || !node.ready)
            return

        node.audio.volume = Math.max(0, Math.min(1.5, value))
    }

    // Переключение Mute
    function toggleMute(node) {
        if (!node || !node.audio || !node.ready)
            return

        node.audio.muted = !node.audio.muted
    }

    // Выбор устройства вывода
    function setDefaultOutput(node) {
        if (!node)
            return

        Pipewire.preferredDefaultAudioSink = node
    }

    // Выбор устройства ввода
    function setDefaultInput(node) {
        if (!node)
            return

        Pipewire.preferredDefaultAudioSource = node
    }

    // Название узла
    function nodeName(node) {
        if (!node)
            return "Unknown"

        return node.nickname || node.description || node.name
    }

    // Диагностика
    function dumpNodes() {
        console.log("========== AUDIO BACKEND ==========")
        console.log("Playback:", playbackNodes.length)
        console.log("Recording:", recordingNodes.length)
        console.log("Output:", outputDevices.length)
        console.log("Input:", inputDevices.length)

        for (let i = 0; i < nodes.length; i++) {
            const node = nodes[i]

            console.log(
                nodeName(node),
                "| Stream:", node.isStream,
                "| Sink:", node.isSink
            )
        }

        console.log("===================================")
    }

    Component.onCompleted: {
        if (Pipewire.ready)
            dumpNodes()
    }

    Connections {
        target: Pipewire

        function onReadyChanged() {
            if (Pipewire.ready)
                root.dumpNodes()
        }
    }
}


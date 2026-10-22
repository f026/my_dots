import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

PanelWindow {
    id: root

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    visible: switching

    property bool switching: false
    property int selectedIndex: 0
    property int activeIndex: 0
    property string selectedAddress: ""
    property int focusDelay: 150
    property var pendingWindow: null

    Timer {
        id: focusTimer

        interval: root.focusDelay

        onTriggered: {
            root.applyFocus()
        }
    }

    IpcHandler {
        target: "switcher"

        function next() {
            root.next()
        }

        function previous() {
            root.previous()
        }

        function commit() {
        if (!switching)
            return

        const list = windows()

        if (selectedIndex < 0 || selectedIndex >= list.length) {
            switching = false
            return
        }

        const window = list[selectedIndex]

        if (!window) {
            switching = false
            return
        }

        console.log(
            "Switcher commit:",
            window.title,
            "focus in", focusDelay, "ms"
        )

        pendingWindow = window
        switching = false

        focusTimer.restart()
    }

    function applyFocus() {
        const window = pendingWindow
        pendingWindow = null

        if (!window)
            return

        const address = String(window.address)

        const ipc = window.lastIpcObject
        const sid = ipc
            ? (ipc.stableId || ipc.stableid || "")
            : ""

        console.log(
            "Switcher focus:",
            window.title,
            address,
            "stableid:", sid
        )

        if (sid !== "" && Hyprland.usingLua) {
            Hyprland.dispatch(
                'dispatch hl.dsp.focus({ window = "stableid:' +
                sid +
                '" })'
            )
        } else if (window.wayland) {
            window.wayland.activate()
        } else if (Hyprland.usingLua) {
            Hyprland.dispatch(
                'dispatch hl.dsp.focus({ window = "address:' +
                address +
                '" })'
            )
        } else {
            Hyprland.dispatch(
                "dispatch focuswindow address:" +
                address
            )
        }

        activeIndex = currentIndex()
        selectedIndex = activeIndex
        selectedAddress = ""
    }

    function clear() {
            root.clear()
        }

        function cancel() {
            root.cancel()
        }
    }

    function windows() {
        return Hyprland.toplevels.values
    }

    function windowCount() {
        return Hyprland.toplevels.values.length
    }

    function currentIndex() {
        const list = windows()

        for (let i = 0; i < list.length; ++i) {
            const window = list[i]

            if (window && window.activated)
                return i
        }

        return 0
    }

    function updateSelectedAddress() {
        const list = windows()

        if (
            selectedIndex >= 0 &&
            selectedIndex < list.length &&
            list[selectedIndex]
        ) {
            selectedAddress =
                list[selectedIndex].address

            console.log(
                "Switcher selected:",
                list[selectedIndex].title,
                selectedAddress
            )
        }
    }

    function start() {
        const count = windowCount()

        console.log("Switcher count:", count)

        if (count === 0)
            return

        Hyprland.refreshToplevels()

        activeIndex = currentIndex()

        if (count > 1) {
            selectedIndex =
                (activeIndex + 1) % count
        } else {
            selectedIndex = activeIndex
        }

        updateSelectedAddress()

        switching = true

        console.log(
            "Switcher started:",
            "active =", activeIndex,
            "selected =", selectedIndex
        )
    }

    function next() {
        const count = windowCount()

        if (count === 0)
            return

        if (!switching) {
            start()
            return
        }

        if (count === 1)
            return

        selectedIndex =
            (selectedIndex + 1) % count

        updateSelectedAddress()

        console.log(
            "Switcher next:",
            selectedIndex
        )
    }

    function previous() {
        const count = windowCount()

        if (count === 0)
            return

        if (!switching) {
            start()
            return
        }

        if (count === 1)
            return

        selectedIndex =
            (selectedIndex - 1 + count) % count

        updateSelectedAddress()

        console.log(
            "Switcher previous:",
            selectedIndex
        )
    }

    function commit() {
        if (!switching)
            return

        const list = windows()

        if (
            selectedIndex < 0 ||
            selectedIndex >= list.length
        ) {
            switching = false
            return
        }

        const window = list[selectedIndex]

        if (!window) {
            switching = false
            return
        }

        const address = String(window.address)

        console.log(
            "Switcher commit:",
            window.title,
            address
        )

        const ipc = window.lastIpcObject
        const sid = ipc
            ? (ipc.stableId || ipc.stableid || "")
            : ""

        console.log("Switcher stableid:", sid)

        if (sid !== "" && Hyprland.usingLua) {
            Hyprland.dispatch(
                'dispatch hl.dsp.focus({ window = "stableid:' +
                sid +
                '" })'
            )
        } else if (window.wayland) {
            window.wayland.activate()
        } else if (Hyprland.usingLua) {
            Hyprland.dispatch(
                'dispatch hl.dsp.focus({ window = "address:' +
                address +
                '" })'
            )
        } else {
            Hyprland.dispatch(
                "dispatch focuswindow address:" +
                address
            )
        }

        switching = false

        activeIndex = currentIndex()
        selectedIndex = activeIndex
        selectedAddress = ""
    }

    function clear() {
        console.log("Switcher cleared")

        focusTimer.stop()
        pendingWindow = null
        switching = false

        activeIndex = currentIndex()
        selectedIndex = activeIndex
        selectedAddress = ""
    }

    function cancel() {
        clear()
    }

    Connections {
        target: Hyprland.toplevels

        function onValuesChanged() {
            const count = root.windowCount()

            if (count === 0) {
                focusTimer.stop()
                root.pendingWindow = null
                root.switching = false
                root.selectedIndex = 0
                root.activeIndex = 0
                root.selectedAddress = ""
                return
            }

            if (root.selectedIndex >= count)
                root.selectedIndex = count - 1

            if (root.activeIndex >= count)
                root.activeIndex = root.currentIndex()

            if (
                root.switching &&
                root.selectedAddress !== ""
            ) {
                const list = root.windows()

                let found = false

                for (let i = 0; i < list.length; ++i) {
                    if (
                        list[i] &&
                        list[i].address === root.selectedAddress
                    ) {
                        root.selectedIndex = i
                        found = true
                        break
                    }
                }

                if (!found)
                    root.updateSelectedAddress()
            }
        }
    }

    Rectangle {
        anchors.centerIn: parent

        width: Math.min(
            parent.width - 80,
            Math.max(
                500,
                root.windowCount() * 160
            )
        )

        height: 150

        radius: 16

        color: "#202020"

        border.width: 1
        border.color: "#454545"

        Row {
            anchors.centerIn: parent

            spacing: 10

            Repeater {
                model: Hyprland.toplevels

                delegate: Rectangle {
                    required property int index
                    required property var modelData

                    width: 145
                    height: 100

                    radius: 10

                    color: {
                        if (index === root.selectedIndex)
                            return "#505050"

                        if (index === root.activeIndex)
                            return "#303030"

                        return "#2b2b2b"
                    }

                    border.width: {
                        if (index === root.selectedIndex)
                            return 3

                        if (index === root.activeIndex)
                            return 1

                        return 0
                    }

                    border.color: {
                        if (index === root.selectedIndex)
                            return "white"

                        return "#777777"
                    }

                    Rectangle {
                        visible:
                            index === root.activeIndex

                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                        }

                        height: 4

                        radius: 2

                        color: "#aaaaaa"
                    }

                    Text {
                        anchors.centerIn: parent

                        width: parent.width - 16

                        text: modelData.title

                        color: "white"

                        horizontalAlignment:
                            Text.AlignHCenter

                        verticalAlignment:
                            Text.AlignVCenter

                        elide:
                            Text.ElideRight

                        maximumLineCount: 2
                    }

                    Text {
                        anchors {
                            bottom: parent.bottom
                            horizontalCenter: parent.horizontalCenter
                            bottomMargin: 6
                        }

                        text: (index + 1).toString()

                        color: "#999999"

                        font.pixelSize: 12
                    }
                }
            }
        }
    }

    Shortcut {
        sequence: "Return"

        onActivated: {
            if (root.switching)
                root.commit()
        }
    }

    Shortcut {
        sequence: "Escape"

        onActivated: {
            if (root.switching)
                root.clear()
        }
    }
}
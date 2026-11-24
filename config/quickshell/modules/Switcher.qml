
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "../DynamicTheme"

PanelWindow {
    id: root

    // ==========================================
    // SWITCHER ENGINE
    // ==========================================

    property var windows: []

    property string activeAddress: ""
    property string selectedAddress: ""
    property int selectedIndex: -1

    property bool isActive: false
    property bool loading: false
    property bool pendingBegin: false
    property bool pendingStickyMode: true
    // Получение окон Hyprland
    function refresh() {
        if (clientsProcess.running)
            return

        loading = true
        clientsProcess.running = true
    }

    // Разбор JSON
    function parseWindows(data) {
        try {
            const clients = JSON.parse(data)

            const result = clients
                .filter(window =>
                    window.mapped === true
                    && window.address
                )
                .sort((a, b) =>
                    a.focusHistoryID - b.focusHistoryID
                )

            windows = result

            const focused = result.find(
                window => window.focusHistoryID === 0
            )

            activeAddress = focused
                ? focused.address
                : ""

            if (isActive) {
                const index = result.findIndex(
                    window => window.address === selectedAddress
                )

                if (index !== -1) {
                    selectedIndex = index
                } else {
                    selectedIndex = 0
                    updateSelection()
                }
            }

            console.log(
                "[Switcher] Windows:",
                windows.length
            )

        } catch (error) {
            console.warn(
                "[Switcher] JSON error:",
                error
            )
        }

        loading = false

        if (pendingBegin) {
            pendingBegin = false
            startSelection(pendingStickyMode)
        }
    }

    // Обновление выбранного окна
    function updateSelection() {
        if (windows.length === 0) {
            selectedIndex = -1
            selectedAddress = ""
            return
        }
        selectedIndex =
            (selectedIndex + windows.length)
            % windows.length

        selectedAddress =
            windows[selectedIndex].address

        console.log(
            "[Switcher] Selected:",
            windows[selectedIndex].class,
            windows[selectedIndex].title
        )
    }

    // Поиск иконки приложения по desktop entry
    function appIcon(window) {
        const candidates = [
            window.class,
            window.initialClass
        ]

        for (const candidate of candidates) {
            if (!candidate)
                continue

            const entry = DesktopEntries.heuristicLookup(candidate)

            if (entry && entry.icon)
                return Quickshell.iconPath(entry.icon)
        }

        return ""
    }

    // Начало переключения
function begin(stickyMode) {
    pendingBegin = true
    pendingStickyMode = stickyMode

    refresh()
}

// Выбор начального окна после обновления списка
function startSelection(stickyMode) {
    if (windows.length === 0) {
        isActive = false
        return
    }

    isActive = true

    let currentIndex = windows.findIndex(
        window => window.address === activeAddress
    )

    if (currentIndex === -1)
        currentIndex = 0

    selectedIndex = stickyMode
        ? currentIndex
        : currentIndex + 1

    updateSelection()

    console.log("[Switcher] Started")
}

            // Alt + Tab
        function tab() {
    if (!isActive)
        begin(true)
    else
        cycle(1)
  }

    // Навигация между окнами
    function cycle(direction) {
        if (!isActive || windows.length === 0)
            return

        selectedIndex += direction > 0 ? 1 : -1
        updateSelection()
    }

    // Подтверждение выбора
    function commit() {
        if (!isActive || !selectedAddress)
            return

        const address = selectedAddress
        isActive = false
        focusWindow(address)
    }

    // Отмена переключения
    function cancel() {
        isActive = false
        pendingBegin = false
        selectedAddress = ""
        selectedIndex = -1
    }

    // Фокусировка через Lua API Hyprland 0.57.2
    function focusWindow(address) {
        if (!address || focusProcess.running)
            return

        focusProcess.command = [
            "hyprctl",
            "dispatch",
            "hl.dsp.focus({ window = \"address:" + address + "\" })"
        ]

        focusProcess.running = true
    }

    // ==========================================
    // PROCESSES
    // ==========================================

    property Process clientsProcess: Process {
        command: [
            "hyprctl",
            "-j",
            "clients"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                root.parseWindows(text)
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text.length > 0)
                    console.warn("[Switcher]", text)
            }
        }
    }

    property Process focusProcess: Process {
        command: []
    }

    // ==========================================
    // IPC
    // ==========================================

    property IpcHandler ipcHandler: IpcHandler {
        target: "switcher"

        function refresh(): void {
            root.refresh()
        }

        function begin(stickyMode: bool): void {
            root.begin(stickyMode)
        }

        function next(): void {
            root.cycle(1)
        }
        function tab(): void {
            root.tab()
        }
        
function confirm() {
    commit()
}

function dismiss() {
    cancel()
}

        function prev(): void {
            root.cycle(-1)
        }

        function commit(): void {
            root.commit()
        }

        function cancel(): void {
            root.cancel()
        }

        function getSelection(): string {
            return root.selectedAddress
        }

        function getWindowCount(): int {
            return root.windows.length
        }
    }

    Component.onCompleted: refresh()

    // ==========================================
    // WINDOW SETTINGS
    // ==========================================

    visible: isActive

    screen: Quickshell.screens[0]

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    exclusiveZone: -1
    color: "transparent"

    WlrLayershell.layer: WlrLayershell.Overlay
    WlrLayershell.keyboardFocus: WlrLayershell.OnDemand
    Item {
    id: keyboardHandler

    anchors.fill: parent
    focus: root.isActive

    Keys.onPressed: event => {
        if (!root.isActive)
            return

        if (event.key === Qt.Key_Return ||
            event.key === Qt.Key_Enter) {
            root.commit()
            event.accepted = true
        }
        else if (event.key === Qt.Key_Escape) {
            root.cancel()
            event.accepted = true
        }
    }
}

    // ==========================================
    // BACKGROUND
    // ==========================================

    Rectangle {
        anchors.fill: parent

        color: "#80000000"

        opacity: root.isActive ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 180
                easing.type: Easing.OutCubic
            }
        }
    }

    // ==========================================
    // SWITCHER PANEL
    // ==========================================

    Rectangle {
        id: switcherPanel

        anchors.centerIn: parent

        // Максимум 5 карточек в строке, дальше перенос
        // Ширина панели зависит от фактического количества колонок.
        // Одна карточка не растягивает панель на две колонки.
        width: Math.min(
            root.width - 40,
            Math.max(
                220,
                Math.min(root.windows.length, 5) * 145
                    + (Math.min(root.windows.length, 5) - 1) * 10
                    + 36
            )
        )

        height: Math.min(
            root.height - 40,
            Math.max(205, cardGrid.implicitHeight + 112)
        )

        radius: 18

        color: Theme.background

        border.width: 1
        border.color: Theme.border

        opacity: root.isActive ? 1 : 0
        scale: root.isActive ? 1 : 0.94

        Behavior on opacity {
            NumberAnimation {
                duration: 180
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18

            spacing: 14

            // Заголовок
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Window Switcher"

                    color: Theme.text

                    font.pixelSize: 15
                    font.weight: Font.Bold
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    text: root.windows.length + " windows"

                    color: Theme.subtext

                    font.pixelSize: 11
                }
            }

            // Карточки: адаптивная сетка с вертикальной прокруткой
            Flickable {
                id: cards

                Layout.fillWidth: true
                Layout.fillHeight: true

                contentWidth: width
                contentHeight: cardGrid.implicitHeight

                clip: true
                flickableDirection: Flickable.VerticalFlick

                Grid {
                    id: cardGrid

                    columns: Math.max(1, Math.min(5, root.windows.length))
                    spacing: 10

                    // Сетка имеет ширину только по своим колонкам
                    // и центрируется внутри Flickable.
                    width: columns * 145 + (columns - 1) * spacing
                    x: Math.max(0, (cards.width - width) / 2)

                    Repeater {
                        model: root.windows

                        delegate: Rectangle {
                            id: card

                            required property var modelData
                            required property int index

                            width: 145
                            height: 132

                            radius: 13

                            property bool selected:
                                modelData.address === root.selectedAddress

                            color: selected
                                ? Theme.primary
                                : Theme.surface

                            border.width: selected ? 2 : 1
                            border.color: selected
                                ? Theme.accent
                                : Theme.border

                            Behavior on color {
                                ColorAnimation { duration: 180 }
                            }

                            Behavior on border.color {
                                ColorAnimation { duration: 180 }
                            }

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 7

                                Item {
                                    Layout.alignment: Qt.AlignHCenter
                                    width: 48
                                    height: 48

                                    Rectangle {
                                        anchors.fill: parent
                                        radius: 13
                                        color: card.selected
                                            ? Theme.primaryForeground
                                            : Theme.surfaceVariant
                                    }

                                    Image {
                                        id: appIconImage
                                        anchors.centerIn: parent
                                        width: 34
                                        height: 34
                                        source: root.appIcon(card.modelData)
                                        sourceSize.width: 96
                                        sourceSize.height: 96
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                        visible: status === Image.Ready
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        visible: !appIconImage.visible
                                        text: {
                                            const app = card.modelData.class || "?"
                                            return app.charAt(0).toUpperCase()
                                        }
                                        color: card.selected
                                            ? Theme.primary
                                            : Theme.text
                                        font.pixelSize: 23
                                        font.weight: Font.Bold
                                    }
                                }

                                // Класс приложения
                                Text {
                                    Layout.fillWidth: true
                                    text: card.modelData.title || card.modelData.class || "Unknown"
                                    color: card.selected
                                        ? Theme.primaryForeground
                                        : Theme.text
                                    font.pixelSize: 12
                                    font.weight: Font.Bold
                                    horizontalAlignment: Text.AlignHCenter
                                    elide: Text.ElideRight
                                }

                                // Заголовок окна
                                Text {
                                    Layout.fillWidth: true
                                    text: card.modelData.title || "Untitled"
                                    color: card.selected
                                        ? Theme.primaryForeground
                                        : Theme.subtext
                                    font.pixelSize: 10
                                    horizontalAlignment: Text.AlignHCenter
                                    elide: Text.ElideRight
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: "Workspace " +
                                        (card.modelData.workspace
                                            ? card.modelData.workspace.name
                                            : "?")
                                    color: card.selected
                                        ? Theme.primaryForeground
                                        : Theme.subtext
                                    font.pixelSize: 9
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }

                            scale: card.selected ? 1.035 : 1
                            Behavior on scale {
                                NumberAnimation { duration: 160 }
                            }
                        }
                    }
                }
            }

            // Нижняя подсказка
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "ALT + TAB"

                    color: Theme.accent

                    font.pixelSize: 10
                    font.weight: Font.Bold
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    text: "ENTER  Select    ESC  Cancel"

                    color: Theme.subtext

                    font.pixelSize: 10
                }
            }
        }
    }
}


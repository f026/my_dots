
import Quickshell
import Quickshell.Wayland
import QtQuick
import Quickshell.Io
import "../DynamicTheme"

WlrLayershell {
    id: wallpaper

    signal wallpaperReady(string path)

    layer: WlrLayer.Background
    namespace: "wallpaper"
    exclusiveZone: -1

    anchors {
        bottom: true
        top: true
        left: true
        right: true
    }

    color: "#1b1b1b"

    property int type: 1
    property string staticBust: ""
    property string shaderName: ""

    property string defaultWallpaperPath:
        Quickshell.env("HOME")
        + "/.config/hypr/wallpapers/cachyos.png"

    property string currentWallpaperPath: defaultWallpaperPath
    property bool initialized: false

    // Crossfade
    property bool activeA: true
    property bool transitionRunning: false

    property string pathA: ""
    property string pathB: ""

    property string pendingTarget: ""
    property string queuedWallpaperPath: ""

    property int transitionDuration: 750

    // Синхронизация с DynamicTheme
    property string imageReadyPath: ""
    property string themeReadyPath: ""

    property bool notificationSentForCurrent: false
    property bool notifyOnCurrentLoad: false

    FileView {
        id: wallpaperState

        path: Quickshell.statePath("wallpaper.txt")
        blockLoading: true
    }

    function wallpaperUrl(path) {
        return "file://" + path + staticBust
    }

    function maybeNotifyWallpaperChanged() {
        if (!initialized || !notifyOnCurrentLoad)
            return

        if (notificationSentForCurrent)
            return

        if (currentWallpaperPath === "")
            return

        if (imageReadyPath !== currentWallpaperPath)
            return

        if (themeReadyPath !== currentWallpaperPath)
            return

        notificationSentForCurrent = true
        notifyOnCurrentLoad = false

        console.log("[Walls] Wallpaper and theme ready:", currentWallpaperPath)
        wallpaperReady(currentWallpaperPath)
    }

    function loadNextWallpaper() {
        if (type !== 1)
            return

        if (transitionRunning || pendingTarget !== "")
            return

        if (queuedWallpaperPath !== "")
            return

        const target = currentWallpaperPath

        if (target === "")
            return

        if (activeA && pathA === target)
            return

        if (!activeA && pathB === target)
            return

        pendingTarget = target

        if (activeA) {
            pathB = target
            imageB.source = wallpaperUrl(target)

            if (imageB.status === Image.Ready)
                handleImageReady(false, target)
        } else {
            pathA = target
            imageA.source = wallpaperUrl(target)

            if (imageA.status === Image.Ready)
                handleImageReady(true, target)
        }

        console.log("[Walls] Loading:", target)
    }

    function handleImageReady(isA, path) {
        if (path === "")
            return

        // Первоначальная загрузка
        if (isA && activeA && path === currentWallpaperPath
                && pendingTarget === "") {
            imageReadyPath = path
            maybeNotifyWallpaperChanged()
            return
        }

        if (!isA && !activeA && path === currentWallpaperPath
                && pendingTarget === "") {
            imageReadyPath = path
            maybeNotifyWallpaperChanged()
            return
        }

        if (path !== pendingTarget)
            return

        if (transitionRunning)
            return

        console.log("[Walls] Image ready:", path)
        startCrossfade()
    }

    function startCrossfade() {
        if (pendingTarget === "" || transitionRunning)
            return

        transitionRunning = true
        fadeAnimation.start()
    }

    function handleImageError(isA, path) {
        if (path === "" || path !== pendingTarget)
            return

        console.warn("[Walls] Failed to load:", path)

        pendingTarget = ""
        transitionRunning = false

        if (isA)
            pathA = ""
        else
            pathB = ""

        loadQueuedWallpaper()
    }

    function loadQueuedWallpaper() {
        if (transitionRunning || pendingTarget !== "")
            return

        if (queuedWallpaperPath === "")
            return

        const nextPath = queuedWallpaperPath
        queuedWallpaperPath = ""

        if (nextPath === currentWallpaperPath) {
            loadNextWallpaper()
            return
        }

        if (activeA && pathA === nextPath)
            return

        if (!activeA && pathB === nextPath)
            return

        pendingTarget = nextPath

        if (activeA) {
            pathB = nextPath
            imageB.source = wallpaperUrl(nextPath)

            if (imageB.status === Image.Ready)
                handleImageReady(false, nextPath)
        } else {
            pathA = nextPath
            imageA.source = wallpaperUrl(nextPath)

            if (imageA.status === Image.Ready)
                handleImageReady(true, nextPath)
        }

        console.log("[Walls] Loading queued wallpaper:", nextPath)
    }

    function finishCrossfade() {
        const finishedPath = pendingTarget

        activeA = !activeA
        imageReadyPath = finishedPath

        console.log("[Walls] Transition finished:", finishedPath)

        pendingTarget = ""
        transitionRunning = false

        maybeNotifyWallpaperChanged()

        loadQueuedWallpaper()

        if (queuedWallpaperPath === ""
                && currentWallpaperPath !== imageReadyPath) {
            loadNextWallpaper()
        }
    }

    Image {
        id: imageA

        anchors.fill: parent

        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true

        opacity: wallpaper.activeA ? 1 : 0

        onStatusChanged: {
            if (status === Image.Ready)
                wallpaper.handleImageReady(true, wallpaper.pathA)
            else if (status === Image.Error)
                wallpaper.handleImageError(true, wallpaper.pathA)
        }
    }

    Image {
        id: imageB

        anchors.fill: parent

        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true

        opacity: wallpaper.activeA ? 0 : 1

        onStatusChanged: {
            if (status === Image.Ready)
                wallpaper.handleImageReady(false, wallpaper.pathB)
            else if (status === Image.Error)
                wallpaper.handleImageError(false, wallpaper.pathB)
        }
    }

    ParallelAnimation {
        id: fadeAnimation

        NumberAnimation {
            target: imageA
            property: "opacity"
            to: wallpaper.activeA ? 0 : 1
            duration: wallpaper.transitionDuration
            easing.type: Easing.InOutCubic
        }

        NumberAnimation {
            target: imageB
            property: "opacity"
            to: wallpaper.activeA ? 1 : 0
            duration: wallpaper.transitionDuration
            easing.type: Easing.InOutCubic
        }

        onFinished: wallpaper.finishCrossfade()
    }

    Connections {
        target: Theme

        function onPaletteApplied(path) {
            wallpaper.themeReadyPath = path

            console.log("[Walls] Palette ready:", path)

            wallpaper.maybeNotifyWallpaperChanged()
        }
    }

    Component.onCompleted: {
        const savedPath = wallpaperState.text().trim()

        if (savedPath.length > 0)
            currentWallpaperPath = savedPath

        pathA = currentWallpaperPath
        imageA.source = wallpaperUrl(currentWallpaperPath)

        Theme.setWallpaper(currentWallpaperPath)

        initialized = true
    }

    onCurrentWallpaperPathChanged: {
        if (!initialized)
            return

        console.log("[Walls] Wallpaper requested:", currentWallpaperPath)

        imageReadyPath = ""
        themeReadyPath = ""

        notificationSentForCurrent = false
        notifyOnCurrentLoad = true

        Theme.setWallpaper(currentWallpaperPath)
        wallpaperState.setText(currentWallpaperPath)

        if (transitionRunning || pendingTarget !== "") {
            queuedWallpaperPath = currentWallpaperPath

            console.log("[Walls] Queued wallpaper:", queuedWallpaperPath)
            return
        }

        queuedWallpaperPath = currentWallpaperPath
        loadQueuedWallpaper()
    }
}



pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: theme

    signal paletteApplied(string wallpaperPath)

    readonly property string generatorPath:
        Quickshell.env("HOME")
        + "/.config/quickshell/DynamicTheme/scripts/generate-palette.py"

    // ========================================================
    // PALETTE MODES
    // ========================================================

    property string defaultPaletteMode: "auto"

    property var coldWallpapers: [
        "heralt.jpg"
    ]

    property var monoWallpapers: [
    ]

    function getPaletteMode(path) {
        const filename = path.split("/").pop().toLowerCase()

        if (monoWallpapers.includes(filename))
            return "mono"

        if (coldWallpapers.includes(filename))
            return "cold"

        return defaultPaletteMode
    }

    // ========================================================
    // GENERATION STATE
    // ========================================================

    property string pendingWallpaper: ""
    property string runningWallpaper: ""
    property string outputData: ""

    // ========================================================
    // THEME COLORS
    // ========================================================

    property color background: "#1b1b1b"
    property color surface: "#252530"
    property color surfaceVariant: "#343443"

    property color primary: "#a78bfa"
    property color secondary: "#7dd3fc"
    property color accent: "#c4b5fd"

    property color text: "#f1f0f5"
    property color subtext: "#aaa9ba"

    property color border: "#414154"
    property color primaryForeground: "#17151d"

    readonly property int animationDuration: 450

    // ========================================================
    // COLOR ANIMATIONS
    // ========================================================

    Behavior on background {
        ColorAnimation {
            duration: theme.animationDuration
            easing.type: Easing.InOutCubic
        }
    }

    Behavior on surface {
        ColorAnimation {
            duration: theme.animationDuration
            easing.type: Easing.InOutCubic
        }
    }

    Behavior on surfaceVariant {
        ColorAnimation {
            duration: theme.animationDuration
            easing.type: Easing.InOutCubic
        }
    }

    Behavior on primary {
        ColorAnimation {
            duration: theme.animationDuration
            easing.type: Easing.InOutCubic
        }
    }

    Behavior on secondary {
        ColorAnimation {
            duration: theme.animationDuration
            easing.type: Easing.InOutCubic
        }
    }

    Behavior on accent {
        ColorAnimation {
            duration: theme.animationDuration
            easing.type: Easing.InOutCubic
        }
    }

    Behavior on text {
        ColorAnimation {
            duration: theme.animationDuration
            easing.type: Easing.InOutCubic
        }
    }

    Behavior on subtext {
        ColorAnimation {
            duration: theme.animationDuration
            easing.type: Easing.InOutCubic
        }
    }

    Behavior on border {
        ColorAnimation {
            duration: theme.animationDuration
            easing.type: Easing.InOutCubic
        }
    }

    Behavior on primaryForeground {
        ColorAnimation {
            duration: theme.animationDuration
            easing.type: Easing.InOutCubic
        }
    }

    // ========================================================
    // WALLPAPER REQUEST
    // ========================================================

    function setWallpaper(path) {
        if (!path || path.length === 0)
            return

        if (path === runningWallpaper && !generator.running)
            return

        pendingWallpaper = path
        debounce.restart()
    }

    // ========================================================
    // START GENERATION
    // ========================================================

    function startGeneration() {
        if (generator.running || pendingWallpaper.length === 0)
            return

        runningWallpaper = pendingWallpaper
        pendingWallpaper = ""
        outputData = ""

        const mode = getPaletteMode(runningWallpaper)

        console.log("[Theme] Palette mode:", mode)
        console.log("[Theme] Generating palette:", runningWallpaper)

        generator.command = [
            "python3",
            generatorPath,
            runningWallpaper,
            mode
        ]

        generator.running = true
    }

    // ========================================================
    // APPLY PALETTE
    // ========================================================

    function applyPalette(json) {
        try {
            const palette = JSON.parse(json)

            if (palette.background)
                background = palette.background

            if (palette.surface)
                surface = palette.surface

            if (palette.surfaceVariant)
                surfaceVariant = palette.surfaceVariant

            if (palette.primary)
                primary = palette.primary

            if (palette.secondary)
                secondary = palette.secondary

            if (palette.accent)
                accent = palette.accent

            if (palette.text)
                text = palette.text

            if (palette.subtext)
                subtext = palette.subtext

            if (palette.border)
                border = palette.border

            if (palette.onPrimary)
                primaryForeground = palette.onPrimary

            console.log("[Theme] Palette updated")

            return true

        } catch (error) {
            console.warn("[Theme] Invalid palette:", error)
            return false
        }
    }

    // ========================================================
    // DEBOUNCE
    // ========================================================

    property Timer debounce: Timer {
        interval: 250
        repeat: false

        onTriggered: {
            theme.startGeneration()
        }
    }

    // ========================================================
    // PALETTE GENERATOR
    // ========================================================

    property Process generator: Process {
        command: []

        stdout: StdioCollector {
            onStreamFinished: {
                theme.outputData = text
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text.length > 0)
                    console.warn("[Theme generator]", text)
            }
        }

        onExited: (exitCode, exitStatus) => {
            const hasNewerRequest =
                theme.pendingWallpaper.length > 0
                && theme.pendingWallpaper !== theme.runningWallpaper

            if (
                exitCode === 0
                && theme.outputData.length > 0
                && !hasNewerRequest
            ) {
                if (theme.applyPalette(theme.outputData)) {
                    theme.paletteApplied(theme.runningWallpaper)
                }
            } else if (exitCode !== 0) {
                console.warn(
                    "[Theme] Generator failed:",
                    exitCode
                )
            } else if (hasNewerRequest) {
                console.log("[Theme] Skipping outdated palette")
            }

            if (theme.pendingWallpaper.length > 0) {
                theme.startGeneration()
            }
        }
    }
}


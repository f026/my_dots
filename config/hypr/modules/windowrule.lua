local dec = require("modules.declorations")
hl.window_rule({
    name = "Terminal",
    match = {
        class = "kitty"
    },
    opacity = 0.8 ,
    border_size = 0,
    workspace = 1
})
hl.window_rule({
    name = "ff",
    match = {
        class = "ff"
    },
    opacity = 0.6,
    border_size = 0,
    size = dec.SIZE_WINDOW,
    float = true,
    workspace = 1
})
hl.window_rule({
    name = "yazi",
    match = {
        class = "filemanager"
    },
    opacity = 0.8,
    border_size = 0,
    size = dec.SIZE_WINDOW,
    float = true,
    workspace = 1
})
hl.window_rule({
    name = "nvim",
    match = {
        class = "editor"

    },
    border_size = 0,
    workspace = 9,
    opacity = 0.8
})
hl.window_rule({
    name = "wl-color-picker",
    match = {
        title = ".*Copy color to Clipboard.*"
    },
    border_size = 0,
    size = "520 360",
    float = true,
    center = true,
    workspace = 1
})

hl.window_rule({
    name = "zen-browser",
    match = {
        class = "zen"
    },

    border_size = 0,
    workspace = 2
})
hl.window_rule({
    name = "DeepSeek",
    match = {
        title = ".*DeepSeek.*"
    },
    opacity = 0.85
})
hl.window_rule({
    name = "Library",
    match = {
        title = ".*Library.*"
    },
    float = true,
    size = dec.SIZE_WINDOW
})
hl.window_rule({
    name = "upload",
    match = {
        title = "*.Выгрузка файла... .*"
    },
    opacity = 0.85,
    float = true,
    size = dec.SIZE_WINDOW,
    border_size = 0
})

hl.window_rule({
    name = "steam",
    match = {
        class = "steam"
    },
    center = true,
    border_size = 0,
    workspace = 3
})
hl.window_rule({
    name = "ETS2",
    match={
        title = ".*Euro Truck Simulator 2.*",
    },
    border_size = 0,
    workspace = 3,
    fullscreen = true

})

hl.window_rule({
    name = "prismlauncher",
    match = {
        class = "org.prismlauncher.PrismLauncher"
    },
    border_size = 0,
    opacity = 0.85,
    size = dec.SIZE_WINDOW,
    float = true,
    workspace = 3
})
hl.window_rule({
    name = "prismlauncher*",
    match = {
        title = "prismlauncher*"
    },
    float = true,
    size = dec.SIZE_WINDOW,
    float = 1,
    workspace = 3
})
hl.window_rule({
    name = "prismlauncher*",
    match = {
        title = ".*Подождите*.*"
    },
    float = true,
    center = true,
    size = dec.SIZE_WINDOW,
    workspace = 3
})


hl.window_rule({
    name = "Minecraft",
    match = {
        class ="Minecraft.*"
    },
    border_size = 0,
    workspace = 3
})

hl.window_rule({
    name = "telegram",
    match = {
        class = "org.telegram.desktop"
    },
    border_size = 0,
    opacity = 0.9,
    workspace = 4
})

hl.window_rule({
    name = "discord",
    match = {
        class = "discord"
    },
    border_size = 0,
    opacity = 0.85,
    center = true,
    workspace = 4
})

hl.window_rule({
    name = "ruscord",
    match = {
        class = "Ruscord Net"
    },
    border_size = 0,
    opacity = 0.85,
    center = true,
    workspace = 4
})

hl.window_rule({
    name = "ONLYOFFICE",
    match = {
        class = "ONLYOFFICE"
    },
    border_size = 0,
    center = true,
    workspace = 5
})

hl.window_rule({
    name = "obsidian",
    match = {
        class = "obsidian"
    },
    border_size = 0,
    workspace = 6
})

hl.window_rule({
    name = "vlc",
    match = {
        class = "vlc"
    },
    border_size = 0,
    workspace = 7
})
hl.window_rule({
    name = "vlc*",
    match = {
        title = "Select|Simple Preferences"
    },
    float = true,
    center = 1,
    size = dec.SIZE_WINDOW
})

hl.window_rule({
    name = "krita",
    match = {
        class = "krita"
    },
    border_size = 0,
    workspace = 8
})

hl.window_rule({
    name = "happ",
    match = {
        class = "Happ"
    },
    border_size = 0,
    float = 1,
    center = 1,
    size = dec.SIZE_WINDOW,
    workspace = 11,
})

-- hl.window_rule({
--     name = "picture in picture",
--     match = {
--         title = ".*Picture-in-Picture.*"
--     },
--     rounding = 0,
--     workspace = 10
-- })

hl.window_rule({
    name = "files",
    match = {
        title = ".*Открыть документ|Сохранить как.*"
    },
    float = 1,
    border_size = 0,
    center = 1,
    size = dec.SIZE_WINDOW,
})


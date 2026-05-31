hl.window_rule({
    name = "foot",
    match = {
        class = "foot"
    },
    opacity = 0.85,
    border_size = 0,
    workspace = 1
})
hl.window_rule({
    name = "ff",
    match = {
        class = "ff"
    },
    opacity = 0.8,
    border_size = 0,
    size = "740 460",
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
    size = "940 560",
    float = true,
    workspace = 1
})

hl.window_rule({
    name = "zen",
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
        title = ".*Библиотека.*"
    },
    float = true,
    size = "740 560"
})
hl.window_rule({
    name = "upload",
    match = {
        title = "*.Выгрузка файла - VK Мессенджер — Zen Browser.*"
    },
    opacity = 0.85,
    float = true,
    size = "740 560",
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
    name = "prismlauncher",
    match = {
        class = "org.prismlauncher.PrismLauncher"
    },
    border_size = 0,
    opacity = 0.85,
    size = "940 560",
    float = true,
    workspace = 3
})
hl.window_rule({
    name = "prismlauncher*",
    match = {
        title = ".*Новый экземпляр.*|.*Подождите.*"
    },
    float = true,
    size = "740 560",
    float = 1,
    workspace = 3
})


hl.window_rule({
    name = "minecraft",
    match = {
        class ="Minecraft*"
    },
    workspace = 3
})

hl.window_rule({
    name = "telegram",
    match = {
        class = "org.telegram.desktop"
    },
    border_size = 0,
    opacity = 0.85,
    workspace = 4
})

hl.window_rule({
    name = "discord",
    match = {
        class = "discord"
    },
    border_size = 0,
    opacity = 0.85,
    workspace = 4
})

hl.window_rule({
    name = "ONLYOFFICE",
    match = {
        class = "ONLYOFFICE"
    },
    border_size = 0,
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
    size = "740 560"
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
    name = "btop",
    match = {
        class = "btop"
    },
    workspace = 9
})

hl.window_rule({
    name = "happ",
    match = {
        class = "Happ"
    },
    float = true,
    size = "740 560",
    center = true,
    workspace = 9
})

hl.window_rule({
    name = "picture in picture",
    match = {
        title = ".*Картинка в картинке.*"
    },
    workspace = 10
})

hl.window_rule({
    name = "files",
    match = {
        title = ".*Открыть документ|Сохранить как.*"
    },
    float = 1,
    center = 1,
    size = "740 560"
})

-- hl.window_rule({
--     name = "no-border-dwindle-window",
--     match = {
--         workspace = "w[tv1]"
--     },
--     border_size = 0
-- })

require("gruvbox").setup({
    transparent_mode = true,          -- Сделать фон редактора прозрачным
    palette_overrides = {             -- Глобальное изменение цветов палитры
        bright_green = "#ebdbb2",      -- Меняем ярко-зеленый на темно-красный
    },
    overrides = {                      -- Переопределение конкретных групп подсветки
        SignColumn = { bg = "#ebdbb2" }, -- Фон колонки знаков
        ["@comment.lua"] = { fg = "#7c6f64" }, -- Цвет комментариев в Lua
        ["@function"]={fg = "#ebdbb2" }
    },
})

vim.cmd.colorscheme("gruvbox")
vim.opt.termguicolors = true
function Setcolor(color)
	color = color or "gruvbox"
	vim.cmd.colorscheme(color)
--vim.api.nvim_set_hl(0,"Normal",{bg = "#120E27"})
	--vim.api.nvim_set_hl(0,"NormalFloat",{bg = "#120E27"})
end 
Setcolor()

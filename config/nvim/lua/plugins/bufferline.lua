require("bufferline").setup {
    options = {
        buffer_close_icon = '',
        mode = 'buffers',
              offsets = {
            {
                filetype = "neo-tree",
                separator = true,
            }
        },
        diagnostics = "nvim_lsp",
        indicator = {
            icon = '  ', -- this should be omitted if indicator style is not 'icon'
            style = 'icon'
        },
    }
}

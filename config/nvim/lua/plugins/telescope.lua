require('telescope').setup{
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
            i = {
                ["<C-n>"] = "move_selection_next",
                ["<C-p>"] = "move_selection_previous",
            },
        },
    },
    require('telescope').load_extension('fzy_native')
    pickers = {
        find_files = {
            theme = "dropdown",
        },
        -- Add more pickers here
    },
    extensions = {
        -- Add extensions here
    }
}


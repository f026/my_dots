require("neo-tree").setup({
    filesystem = {
        filtered_items = {
            hide_dotfiles = false,  -- Set to false to show hidden files
        }
    },
	event_handlers = 
    {
        {
            event = "file_opened",
		    handler = function(_)
		      require('neo-tree.command').execute({action="close"})
			end,

		},
	},
})

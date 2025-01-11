local lazypath = vim.fn.stdpath("data") .. "lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    {"tomasiser/vim-code-dark"},
    {"hrsh7th/nvim-cmp"},
    { 
         "nvim-neo-tree/neo-tree.nvim",
          branch = "v3.x",
          dependencies ={
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        }
    },
    {'nvim-treesitter/nvim-treesitter'},
    {"akinsho/bufferline.nvim"},
    {"neovim/nvim-lspconfig"},
     {"hrsh7th/cmp-nvim-lsp"},
     {"hrsh7th/cmp-buffer"},
     {"hrsh7th/cmp-path"},
    {"hrsh7th/cmp-cmdline"},
    {"hrsh7th/nvim-cmp"},
    {
       "nvim-lualine/lualine.nvim",
       dependencies = {
       "nvim-tree/nvim-web-devicons", "linrongbin16/lsp-progress.nvim"
    }
   },
    {"williamboman/mason.nvim"},
     {"akinsho/toggleterm.nvim", version = "*", config = true},
     {
         "windwp/nvim-autopairs",
         event = "InsertEnter",
         config = true
    },
    {'windwp/nvim-ts-autotag'},
})

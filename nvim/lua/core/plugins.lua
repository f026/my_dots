local lazypath = vim.fn.stdpath("data").. "lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

-- Initialise Lazy by installing some basic plugins
require("lazy").setup({
{
 "nvim-neo-tree/neo-tree.nvim",
 branch = "v3.x",
 dependencies = {
 "nvim-lua/plenary.nvim",
 "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
 -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
 }
},
{'Mofiqul/dracula.nvim'},
{'nvim-treesitter/nvim-treesitter'},
{'deathbeam/autocomplete.nvim'},
 -- "folke/which-key.nvim",
  --{ "folke/neoconf.nvim", cmd = "Neoconf" },
  --"folke/neodev.vim",
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
},
{'akinsho/bufferline.nvim'},
{
	'psjay/buffer-closer.nvim'
},
{
  'nvimdev/dashboard-nvim',

 event = 'VimEnter',
  },
  {'williamboman/mason.nvim'},
  {'akinsho/toggleterm.nvim', version = "*", config = true},
{
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
},
{'hrsh7th/nvim-cmp'},
{'windwp/nvim-ts-autotag'},
})

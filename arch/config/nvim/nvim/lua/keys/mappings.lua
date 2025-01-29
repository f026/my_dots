vim.g.mapleader = " "
--Neotree
vim.keymap.set('n' ,'<leader>e', ':Neotree left toggle<CR>')
--bufferline
vim.keymap.set('n','<leader>q',':BufferLinePickClose<CR>')
vim.keymap.set('n','<leader>n',':BufferLineCycleNext<CR>') 
vim.keymap.set('n','<leader>p',':BufferLineCyclePrev<CR>')
--toggleterm
vim.keymap.set('n','<leader>t',':ToggleTerm dir=%:p:h<CR>')
--telesope
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { noremap = true, silent = true })


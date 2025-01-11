vim.g.mapleader = " "
--Neotree
vim.keymap.set('n' ,'<leader>e', ':Neotree left toggle<CR>')
--bufferline
vim.keymap.set('n','<leader>q',':BufferLinePickClose<CR>')
vim.keymap.set('n','<leader>n',':BufferLineCycleNext<CR>') 
vim.keymap.set('n','<leader>p',':BufferLineCyclePrev<CR>')
--toggleterm
vim.keymap.set('n','<leader>t',':ToggleTerm dir=%:p:h<CR>')

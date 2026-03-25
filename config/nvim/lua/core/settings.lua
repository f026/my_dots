local arrows = function(mode,key,result)
	vim.api.nvim_set_keymap(
		mode,
		key,
		result,
		{noremap = true, silent = true}
    )
end
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.syntax = 'on'
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.tabpagemax = 50
vim.opt.termguicolors = true
vim.opt.formatoptions=ro
vim.opt.foldmethod=syntax
vim.opt.foldlevelstart=99
-- disable arrows 
arrows('','<up>','<nop>')
arrows('','<down>','<nop>')
arrows('','<left>','<nop>')
arrows('','<right>','<nop>')

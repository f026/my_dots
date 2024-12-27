local opt = vim.opt
local arrows = function(mode,key,result)
	vim.api.nvim_set_keymap(
		mode,
		key,
		result,
		{noremap = true, silent = true}
	)
end
opt.number = true
opt.relativenumber = true 
opt.termguicolors = true
opt.formatoptions=ro
-- disable arrows 
arrows('','<up>','<nop>')
arrows('','<down>','<nop>')
arrows('','<left>','<nop>')
arrows('','<right>','<nop>')

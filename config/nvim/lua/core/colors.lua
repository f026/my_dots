vim.opt.termguicolors = true
function Setcolor(color)
	color = color or "codedark"
	vim.cmd.colorscheme(color)
--vim.api.nvim_set_hl(0,"Normal",{bg = "#120E27"})
	--vim.api.nvim_set_hl(0,"NormalFloat",{bg = "#120E27"})
end 
Setcolor()

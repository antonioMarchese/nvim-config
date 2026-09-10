return {
	"mg979/vim-visual-multi",
	branch = "master",
	event = "VeryLazy",
	init = function()
		vim.g.VM_maps = {
			["BS"] = "<BS>", -- backspace deletes selected text in multi-cursor mode
			["Select Cursor Down"] = "",
			["Select Cursor Up"] = "",
			["Select h"] = "",
			["Select l"] = "",
		}
	end,
}

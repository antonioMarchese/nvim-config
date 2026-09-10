return {
	"lervag/vimtex",
	lazy = false,
	ft = { "tex", "plaintex", "bib" },
	init = function()
		vim.g.vimtex_view_method = "skim"
		vim.g.vimtex_view_skim_sync = 1
		vim.g.vimtex_view_skim_activate = 1
		vim.g.vimtex_compiler_method = "latexmk"
		vim.g.vimtex_quickfix_mode = 0
		vim.g.vimtex_mappings_prefix = "<localleader>l"
	end,
}

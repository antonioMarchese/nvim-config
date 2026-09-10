return {
	"nvim-pack/nvim-spectre",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = { "Spectre" },
	keys = {
		{
			"<leader>S",
			function()
				require("spectre").toggle()
			end,
			desc = "Spectre: toggle panel",
		},
		{
			"<leader>sw",
			function()
				require("spectre").open_visual({ select_word = true })
			end,
			desc = "Spectre: search current word",
		},
		{
			"<leader>sw",
			function()
				require("spectre").open_visual()
			end,
			mode = "v",
			desc = "Spectre: search selection",
		},
		{
			"<leader>sp",
			function()
				require("spectre").open_file_search({ select_word = true })
			end,
			desc = "Spectre: search in current file",
		},
	},
	opts = {},
}

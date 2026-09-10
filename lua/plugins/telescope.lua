return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "v0.1.9",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							--['<C-k>'] = require('telescope.actions').move_selection_previous, -- move to prev result
							--['<C-j>'] = require('telescope.actions').move_selection_next, -- move to next result
							--['<C-l>'] = require('telescope.actions').select_default, -- open file
						},
					},
				},
				pickers = {
					find_files = {
						file_ignore_patterns = { "node_modules", "%.git", "venv" },
						hidden = true,
					},
					live_grep = {
						file_ignore_patterns = { "node_modules", "%.git", "%.venv" },
						additional_args = function(_)
							return { "--hidden" }
						end,
					},
				},
			})

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Search files" })
			vim.keymap.set("n", "<C-f>", builtin.live_grep, { desc = "Search by Grep" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}

return {
	"catppuccin/nvim",
	config = function()
		local is_transparent = true

		function ToggleTransparency()
			is_transparent = not is_transparent

			require("catppuccin").setup({
				flavour = "mocha",
				lazy = false,
				name = "catppuccin",
				priority = 1000,
				transparent_background = is_transparent,
				default_integrations = true,
				integrations = {
					cmp = true,
					gitsigns = true,
					treesitter = true,
					telescope = true,
				},
			})
			vim.cmd("colorscheme catppuccin")
		end

		vim.api.nvim_set_keymap("n", "<leader>bg", ":lua ToggleTransparency()<CR>", { desc = "Toggle Transparency" }) -- Toggle Transparency
		ToggleTransparency()
	end,
}

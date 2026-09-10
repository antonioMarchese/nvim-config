return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	config = function()
		local function smart_filename()
			if vim.bo.buftype == "terminal" then
				local name = vim.api.nvim_buf_get_name(0)
				local shell = name:match(":([^:]+)$") or "shell"
				shell = vim.fn.fnamemodify(shell, ":t")
				return " " .. shell
			end

			local rel = vim.fn.expand("%:.")
			if rel == "" then
				return "[No Name]"
			end
			return rel
		end

		require("lualine").setup({
			options = {
				theme = "auto",
				globalstatus = false,
				section_separators = "",
				component_separators = "|",
				disabled_filetypes = { statusline = { "alpha" } },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { smart_filename, icon = "" } },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { smart_filename } },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			extensions = { "neo-tree" },
		})
	end,
}

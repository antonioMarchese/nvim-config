return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		-- Global variable to track format on save state
		vim.g.format_on_save_enabled = true

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				lua = { "stylua" },
				python = { "ruff_format", "ruff_organize_imports" },
				htmldjango = { "djlint" },
			},
			format_on_save = function(bufnr)
				-- Check if format on save is enabled globally
				if not vim.g.format_on_save_enabled then
					return
				end

				return {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				}
			end,
		})

		-- Keymap for manual formatting
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })

		-- Keymap to toggle format on save
		vim.keymap.set("n", "<leader>tf", function()
			vim.g.format_on_save_enabled = not vim.g.format_on_save_enabled
			if vim.g.format_on_save_enabled then
				print("Format on save: ENABLED")
			else
				print("Format on save: DISABLED")
			end
		end, { desc = "Toggle format on save" })
	end,
}

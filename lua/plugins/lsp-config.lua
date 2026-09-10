return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"pyright",
				"eslint",
			},
		},
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"neovim/nvim-lspconfig",
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"ruff", -- python formatter and linter (replaces black + isort)
				"pylint",
				"eslint_d",
				"djlint", -- django html formatter
			},
		},
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "folke/lazydev.nvim", opts = {} },
		},
		config = function()
			-- Get nvim-cmp capabilities for LSP
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Apply capabilities to all LSP servers
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- Configure pyright to use detected Python interpreter
			vim.lsp.config("pyright", {
				capabilities = capabilities,
				before_init = function(_, config)
					-- Check for venv in current working directory
					local venv_paths = {
						vim.fn.getcwd() .. "/venv/bin/python",
						vim.fn.getcwd() .. "/.venv/bin/python",
						vim.fn.getcwd() .. "/venv/bin/python3",
						vim.fn.getcwd() .. "/.venv/bin/python3",
					}

					for _, path in ipairs(venv_paths) do
						if vim.fn.filereadable(path) == 1 then
							config.settings.python = config.settings.python or {}
							config.settings.python.pythonPath = path
							break
						end
					end
				end,
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
							typeCheckingMode = "basic", -- or "off" if you want less strict checking
							-- Django-specific settings
							extraPaths = {},
							stubPath = vim.fn.getcwd() .. "/typings",
						},
					},
				},
			})
		end,
	},
}

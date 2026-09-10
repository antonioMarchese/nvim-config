return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = false,
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,
			filesystem = {
				-- Let the tree follow vim's cwd, but never write back to it.
				-- Default sidebar = "tab" runs `tcd <root>` whenever the tree
				-- root changes; browsing up to / once left a `tcd /` baked into
				-- the auto-session file, so the project reopened rooted at /.
				cwd_target = {
					sidebar = "none",
					current = "window",
				},
				filtered_items = {
					visible = false,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
				follow_current_file = {
					enabled = true,
				},
				use_libuv_file_watcher = true,
			},
		})
	end,
}

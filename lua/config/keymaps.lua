vim.keymap.set("n", "<C-b>", ":Neotree toggle<CR>")
vim.keymap.set("i", "<C-b>", "<ESC>:Neotree toggle<CR>")
vim.keymap.set("n", "<leader>e", ":Neotree focus<CR>", { desc = "Focus file explorer" })

-- Split navigation
vim.keymap.set("n", "<M-q>", "<c-w>h")
vim.keymap.set("n", "<M-e>", "<c-w>l")

-- Undo
vim.keymap.set("n", "<C-z>", "u")
vim.keymap.set("i", "<C-z>", "<ESC>u")

-- Select all
vim.keymap.set("n", "<C-a>", "ggVG")

-- Erase all line
vim.keymap.set("i", "<D-BS>", function()
	local col = vim.fn.col(".")
	if col <= 1 then
		return ""
	end
	return "<Esc>v0di"
end, { expr = true })

-- Ctrl + S to save
vim.keymap.set("n", "<C-s>", ":w<CR>", { silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { silent = true })
vim.keymap.set("v", "<C-s>", "<Esc>:w<CR>gv", { silent = true })

-- LSP config
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", {}) -- show lsp implementations
vim.keymap.set({ "n", "v" }, "<C-LeftMouse>", vim.lsp.buf.definition, {})

-- Copy (visual mode)
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })

-- Cut (visual mode): copy and then delete
vim.keymap.set("v", "<C-x>", '"+d', { noremap = true, silent = true })

-- Shift + Down: select down
vim.keymap.set("n", "<S-Down>", "v<Down>", { silent = true })
vim.keymap.set("v", "<S-Down>", "<Down>", { silent = true })

-- Shift + Up: select up
vim.keymap.set("n", "<S-Up>", "v<Up>", { silent = true })
vim.keymap.set("v", "<S-Up>", "<Up>", { silent = true })

-- Shift + Right: select right
vim.keymap.set("n", "<S-Right>", "v<Right>", { silent = true })
vim.keymap.set("v", "<S-Right>", "<Right>", { silent = true })

-- Shift + Left: select left
vim.keymap.set("n", "<S-Left>", "v<Left>", { silent = true })
vim.keymap.set("v", "<S-Left>", "<Left>", { silent = true })

-- Delete selected content
vim.keymap.set("v", "<BS>", "d", { silent = true })

-- Tab
vim.keymap.set("v", "<Tab>", ">gv", { silent = true })

-- Untab selection (shift + tab)
vim.keymap.set("v", "<S-Tab>", "<gv", { silent = true })

-- Untab line
vim.keymap.set("n", "<S-Tab>", "<<", { silent = true })

-- Terminal mode: Alt+Esc to go to normal mode.
-- Plain <Esc> is left unmapped so it passes through to the program running in
-- the terminal (e.g. Claude Code, where ESC interrupts). <C-\><C-n> also works.
vim.keymap.set("t", "<M-Esc>", "<C-\\><C-n>", { silent = true })

-- Moving cursor between windows
-- Move down
vim.keymap.set("n", "<M-]>", "<C-w><C-j>")
-- Move up
vim.keymap.set("n", "<M-[>", "<C-w><C-k>")

-- Move selection up
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

-- Move selection down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })

-- Move line up
vim.keymap.set("n", "<M-k>", ":m .-2<CR>")

-- Move line down
vim.keymap.set("n", "<M-j>", ":m .+1<CR>")

-- Git with Telescope
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Git status (changed files)" })
vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
vim.keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Git branches" })

-- Multi-cursor (vim-visual-multi)
-- Alt + Click to add cursor
vim.keymap.set("n", "<M-LeftMouse>", "<Plug>(VM-Mouse-Cursor)", {})
vim.keymap.set("i", "<M-LeftMouse>", "<Plug>(VM-Mouse-Cursor)", {})
-- Ctrl + D to select next occurrence (like VS Code)
vim.keymap.set("n", "<C-d>", "<Plug>(VM-Find-Under)", {})
vim.keymap.set("x", "<C-d>", "<Plug>(VM-Find-Subword-Under)", {})

-- Create terminals
vim.keymap.set("n", "<leader>ht", "<cmd>belowright new | term<CR>", {})

-- Floating terminal
local float_term_state = { buf = -1, win = -1 }

local function toggle_floating_terminal()
	if vim.api.nvim_win_is_valid(float_term_state.win) then
		vim.api.nvim_win_hide(float_term_state.win)
		return
	end

	if not vim.api.nvim_buf_is_valid(float_term_state.buf) then
		float_term_state.buf = vim.api.nvim_create_buf(false, true)
	end

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	float_term_state.win = vim.api.nvim_open_win(float_term_state.buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		style = "minimal",
		border = "rounded",
	})

	if vim.bo[float_term_state.buf].buftype ~= "terminal" then
		vim.cmd.terminal()
	end
	vim.cmd.startinsert()
end

vim.keymap.set({ "n" }, "<leader>ft", toggle_floating_terminal, { desc = "Toggle floating terminal" })

-- Toggle Codeium
vim.keymap.set("n", "<leader>tc", "<cmd>CodeiumToggle<CR>", { desc = "Toggle Codeium" })

-- Duplicate line/selection down
vim.keymap.set("n", "<M-S-Down>", ":t.<CR>", { silent = true })
vim.keymap.set("v", "<M-S-Down>", ":<C-u>'<,'>t'><CR>`[V`]", { silent = true })

-- Surround
vim.keymap.set("v", "(", 'c(<C-r>")<Esc>', { noremap = true })

-- Open file in a vertical split, avoiding terminal windows
local function focus_non_terminal_window()
	if vim.bo.buftype ~= "terminal" then
		return
	end
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].buftype ~= "terminal" then
			vim.api.nvim_set_current_win(win)
			return
		end
	end
end

local function pick_file_vsplit()
	focus_non_terminal_window()
	local actions = require("telescope.actions")
	require("telescope.builtin").find_files({
		attach_mappings = function(_, map)
			map("i", "<CR>", actions.select_vertical)
			map("n", "<CR>", actions.select_vertical)
			return true
		end,
	})
end

local function pick_file_split()
	focus_non_terminal_window()
	local actions = require("telescope.actions")
	require("telescope.builtin").find_files({
		attach_mappings = function(_, map)
			map("i", "<CR>", actions.select_horizontal)
			map("n", "<CR>", actions.select_horizontal)
			return true
		end,
	})
end

vim.keymap.set("n", "<leader>sv", pick_file_vsplit, { desc = "Pick file → vertical split" })
vim.keymap.set("n", "<leader>sh", pick_file_split, { desc = "Pick file → horizontal split" })

-- Live grep including hidden + gitignored files
vim.keymap.set("n", "<leader>fG", function()
	require("telescope.builtin").live_grep({
		additional_args = function()
			return { "--hidden", "--no-ignore" }
		end,
	})
end, { desc = "Grep (incl. gitignored)" })

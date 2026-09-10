-- kill terminal processes when closing the window
vim.api.nvim_create_autocmd("WinClosed", {
	callback = function(event)
		local winid = tonumber(event.match)
		local bufnr = vim.api.nvim_win_get_buf(winid)

		-- Only affect terminal buffers
		if vim.bo[bufnr].buftype == "terminal" then
			local chan = vim.b[bufnr].terminal_job_id -- job ID of the terminal

			if chan then
				vim.fn.jobstop(chan) -- Kill the running process
			end

			-- Safely delete the buffer
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(bufnr) then
					vim.api.nvim_buf_delete(bufnr, { force = true })
				end
			end)
		end
	end,
})

-- Disable Spell Check in LSP References
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lspinfo,qf",
	callback = function()
		vim.opt_local.spell = false
	end,
})

-- Function to find and set Python interpreter from venv
local function set_python_venv(silent)
	local cwd = vim.fn.getcwd()
	local venv_paths = {
		cwd .. "/venv/bin/python",
		cwd .. "/.venv/bin/python",
		cwd .. "/venv/bin/python3",
		cwd .. "/.venv/bin/python3",
	}

	for _, path in ipairs(venv_paths) do
		if vim.fn.filereadable(path) == 1 then
			vim.g.python3_host_prog = path

			-- Update pyright settings for the current buffer
			local clients = vim.lsp.get_clients({ bufnr = 0, name = "pyright" })
			if #clients > 0 then
				for _, client in ipairs(clients) do
					client.config.settings = vim.tbl_deep_extend("force", client.config.settings or {}, {
						python = {
							pythonPath = path,
						},
					})
					client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
				end
				if not silent then
					print("Python venv detected: " .. path)
				end
			else
				if not silent then
					print("Python venv found: " .. path .. " (LSP will use it on attach)")
				end
			end
			return path
		end
	end

	return nil
end

-- Command to manually set Python venv
vim.api.nvim_create_user_command("SetPythonVenv", function()
	local venv = set_python_venv()
	if not venv then
		print("No venv found in current directory (./venv/ or ./.venv/)")
	end
end, {})

-- Show vertical line on specific file types
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.opt_local.colorcolumn = "79"
		vim.cmd([[highlight ColorColumn guibg=#2f2f2f]])

		-- Automatically detect and set venv
		set_python_venv()
	end,
})

-- Disable spell check on terminals and activate venv
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.opt_local.spell = false

		local venv = set_python_venv(true)
		if venv then
			local activate = vim.fn.fnamemodify(venv, ":h") .. "/activate"
			if vim.fn.filereadable(activate) == 1 then
				vim.fn.chansend(vim.b.terminal_job_id, "source " .. activate .. "\n")
			end
		end

		vim.cmd("startinsert")
	end,
})

-- Detect Django templates and set filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.html", "*.htm" },
	callback = function()
		local content = vim.api.nvim_buf_get_lines(0, 0, 50, false)
		local file_content = table.concat(content, "\n")

		-- Check for Django template tags
		if file_content:match("{%%") or file_content:match("{{") or file_content:match("{#") then
			vim.bo.filetype = "htmldjango"
		end
	end,
})

-- Heal tab-local working directories after a session restore.
--
-- 'sessionoptions' contains curdir, so auto-session writes a tab-local `tcd`
-- next to the global `cd` for any tab that has one. A single stray `tcd /`
-- then survives forever: restore sets the tab cwd to /, exit saves it again.
-- Neo-tree roots itself at getcwd(), so the sidebar rendered the whole of /.
local function realign_tab_cwds()
	local root = vim.fn.getcwd(-1, -1) -- global cwd, set by the session's `cd`
	if root == "" then
		return
	end

	local current = vim.api.nvim_get_current_tabpage()
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local tabnr = vim.api.nvim_tabpage_get_number(tab)
		-- Equal means the tab has no tab-local dir; don't create one.
		if vim.fn.getcwd(-1, tabnr) ~= root then
			vim.api.nvim_set_current_tabpage(tab)
			vim.cmd("tcd " .. vim.fn.fnameescape(root))
		end
	end
	if vim.api.nvim_tabpage_is_valid(current) then
		vim.api.nvim_set_current_tabpage(current)
	end
end

vim.api.nvim_create_autocmd("SessionLoadPost", {
	callback = function()
		vim.schedule(realign_tab_cwds)
	end,
})

-- Auto show Neo tree
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.cmd("Neotree show")
	end,
})

-- Auto toggle bg transaparency
-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	callback = function()
-- 		vim.cmd("lua ToggleTransparency()")
-- 	end,
-- })

-- Autoscroll terminal buffer
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter" }, {
	callback = function()
		if vim.bo.buftype ~= "terminal" then
			return
		end

		-- Only act if this buffer is visible in a window
		local win = vim.fn.bufwinid(0)
		if win == -1 then
			return
		end

		local current = vim.fn.line(".")
		local last = vim.fn.line("$")

		-- Only follow if already at bottom
		if current == last then
			vim.api.nvim_win_call(win, function()
				vim.cmd("normal! G")
			end)
		end
	end,
})

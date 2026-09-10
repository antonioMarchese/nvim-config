vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.cmd("filetype plugin indent on")

vim.o.sessionoptions = "buffers,curdir,tabpages,winsize"

-- Line numbers
vim.opt.number = true

-- Folding
vim.opt.foldenable = true
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Terminal title
vim.o.title = true
vim.o.titlelen = 0
vim.o.titlestring = "%{fnamemodify(getcwd(), ':t')}"

-- Clipboard: force pbcopy/pbpaste to run under a real UTF-8 locale.
--
-- macOS builds LANG from AppleLocale, which is "en_BR" here (English language +
-- Brazil region). No such locale exists, so every LC_* category falls back to
-- "C" and pbcopy reads incoming UTF-8 as Mac OS Roman: "ç" (C3 A7) is stored as
-- "√ß", "·" (C2 B7) as "¬∑". kitty gets this broken LANG from launchd, so it
-- survives shell config and app restarts -- pin it at the provider instead.
vim.g.clipboard = {
  name = "pbcopy-utf8",
  copy = {
    ["+"] = { "env", "LC_ALL=en_US.UTF-8", "pbcopy" },
    ["*"] = { "env", "LC_ALL=en_US.UTF-8", "pbcopy" },
  },
  paste = {
    ["+"] = { "env", "LC_ALL=en_US.UTF-8", "pbpaste" },
    ["*"] = { "env", "LC_ALL=en_US.UTF-8", "pbpaste" },
  },
  cache_enabled = 0,
}

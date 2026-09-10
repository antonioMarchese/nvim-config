return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local parsers = {
      "lua",
      "python",
      "javascript",
      "typescript",
      "vimdoc",
      "vim",
      "regex",
      "sql",
      "dockerfile",
      "toml",
      "json",
      "java",
      "gitignore",
      "graphql",
      "yaml",
      "make",
      "cmake",
      "markdown",
      "markdown_inline",
      "bash",
      "tsx",
      "css",
      "html",
      "htmldjango",
      "latex",
      "bibtex",
    }

    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local filetype = args.match
        local lang = vim.treesitter.language.get_lang(filetype)
        if not lang then
          return
        end
        if not vim.treesitter.language.add(lang) then
          return
        end

        vim.treesitter.start(args.buf, lang)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}

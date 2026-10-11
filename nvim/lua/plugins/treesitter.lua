-- nvim-treesitter (main branch = the v2 rewrite).
--
-- The v2 rewrite dropped every option the old config used: `setup()` now only
-- accepts `install_dir`, parsers are installed with `install()`, and highlighting
-- is no longer enabled automatically - it needs `vim.treesitter.start()`.
--
-- Requirement: tree-sitter-cli 0.26.1+ and a C compiler in PATH.
-- mason.nvim already provides `tree-sitter-cli`.

require("nvim-treesitter").setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

local parsers = {
  -- Go
  "go",
  "gomod",
  "gowork",
  "gosum",
  "gotmpl",
  -- Config / docs written in this repo
  "json",
  "yaml",
  "toml",
  "markdown",
  "markdown_inline",
  "dockerfile",
  "make",
  "regex",
  -- Editors and configuration files
  "lua",
  "luadoc",
  "vim",
  "vimdoc",
  "query",
  "bash",
  -- Other languages used regularly
  "python",
  "c",
  "rust",
  "java",
  "scala",
  "javascript",
  "typescript",
  "tsx",
  "html",
  "css",
  -- Diffs and commit messages
  "diff",
  "gitcommit",
}

-- Async; a no-op for parsers that are already installed.
require("nvim-treesitter").install(parsers)

-- Highlighting and folding, for every filetype that has a parser installed.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
  callback = function(ev)
    local ok = pcall(vim.treesitter.start, ev.buf)
    if not ok then
      -- No parser for this filetype: fall back to regex highlighting.
      return
    end
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldmethod = "expr"
    vim.wo.foldlevel = 99
  end,
})

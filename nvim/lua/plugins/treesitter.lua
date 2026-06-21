require("nvim-treesitter").setup({
  ensure_installed = {
    "bash",
    "css",
    "dockerfile",
    "go",
    "html",
    "java",
    "javascript",
    "json",
    "json5",
    "lua",
    "rust",
    "scala",
    "vim",
    "yaml",
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

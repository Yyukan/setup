local telescope = require("telescope")
local actions = require("telescope.actions")
local sorters = require("telescope.sorters")

telescope.setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    file_ignore_patterns = { "node_modules", ".git", ".venv", "target"},
    path_display = { "smart" },
    sorting_strategy = "ascending",
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-c>"] = actions.close,
      },
      n = {
        ["<C-c>"] = actions.close,
      },
    },
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = false,
    },
  },
  extensions = {},
  sorters = sorters,
  layout_config = {
    width = 0.75,
    height = 0.85,
    vertical = {
      mirror = false,
    },
  },
})

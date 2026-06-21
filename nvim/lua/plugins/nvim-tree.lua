local nvim_tree = require("nvim-tree")

nvim_tree.setup({
  hijack_cursor = false,
  auto_reload_on_write = true,
  disable_netrw = true,
  hijack_netrw = true,
  sync_root_with_cwd = false,
  respect_buf_cwd = false,
  select_prompts = false,

  sort = {
    sorter = "name",
    folders_first = true,
    files_first = false,
  },

  view = {
    centralize_selection = false,
    cursorline = true,
    cursorlineopt = "both",
    side = "left",
    preserve_window_proportions = true,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
    width = 30,
  },

  renderer = {
    add_trailing = false,
    group_empty = false,
    full_name = false,
    root_folder_label = ":~:s?$?/..?",
    indent_width = 2,
    special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
    highlight_git = "none",
    highlight_opened_files = "none",
    highlight_modified = "none",
    highlight_diagnostics = "none",
    highlight_hidden = "none",
    highlight_bookmarks = "none",
    highlight_clipboard = "name",
    hidden_display = "none",
    indent_markers = {
      enable = false,
      inline_arrows = true,
    },
    icons = {
      web_devicons = {
        file = { enable = true, color = true },
        folder = { enable = false, color = true },
      },
      git_placement = "before",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
        modified = true,
        hidden = false,
        diagnostics = true,
        bookmarks = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        modified = "●",
        hidden = "󰜌",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },

  hijack_directories = {
    enable = true,
    auto_open = true,
  },

  update_focused_file = {
    enable = true,
    update_root = true,
  },

  git = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = true,
    timeout = 400,
  },

  diagnostics = {
    enable = false,
    show_on_dirs = false,
    show_on_open_dirs = true,
  },

  modified = {
    enable = false,
    show_on_dirs = true,
    show_on_open_dirs = true,
  },

  filters = {
    enable = true,
    git_ignored = true,
    dotfiles = false,
    git_clean = false,
  },

  live_filter = {
    prefix = "[FILTER]: ",
    always_show_folders = true,
  },

  filesystem_watchers = {
    enable = true,
    debounce_delay = 50,
  },

  actions = {
    use_system_clipboard = true,
    expand_all = {
      max_folder_discovery = 300,
    },
    change_dir = {
      enable = true,
      global = false,
    },
    open_file = {
      quit_on_open = false,
      eject = true,
      resize_window = true,
      relative_path = true,
      window_picker = {
        enable = true,
        picker = "default",
      },
    },
    remove_file = {
      close_window = true,
    },
  },

  tab = {
    sync = {
      open = false,
      close = false,
    },
  },

  notify = {
    threshold = vim.log.levels.INFO,
  },

  ui = {
    confirm = {
      remove = true,
      trash = true,
    },
  },
})

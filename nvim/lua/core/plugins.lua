-- Plugin manager (lazy.nvim) setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- solarized.nvim (Lua native Solarized)
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.background = "dark"
      vim.opt.termguicolors = true
      require("solarized").setup({
        variant = "winter",
      })
      vim.cmd("colorscheme solarized")
    end,
  },

  -- nvim-tree
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },

  -- nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
  },

  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- mason (LSP installer)
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
  },

  -- nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },

  -- nvim-cmp (completion)
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },

  -- which-key
  {
    "folke/which-key.nvim",
    lazy = false,
    config = function()
      require("which-key").setup()
    end,
  },

  -- diffview
  {
    "sindrets/diffview.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- gitsigns
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- neogit
  {
    "NeogitOrg/neogit",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "sindrets/diffview.nvim",
    },
    config = function()
      require("neogit").setup({})
    end,
  },
})

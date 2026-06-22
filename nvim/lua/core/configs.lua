-- Basic Settings
vim.g.did_load_filetypes = 1
vim.g.formatoptions = "qrn1"
vim.opt.showmode = false
vim.opt.updatetime = 100
vim.wo.signcolumn = "yes"
vim.opt.wrap = false
vim.wo.linebreak = true
vim.opt.virtualedit = "block"
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.encoding = "utf-8"
vim.opt.cursorline = true
vim.opt_global.fileformat = "unix"

-- Nvim-Tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Scroll
vim.opt.so = 30

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Mouse
vim.opt.mouse = "a"
vim.opt.mousefocus = true

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = false
vim.wo.number = true
vim.wo.relativenumber = false

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Shorter messages
vim.opt.shortmess:append("c")

-- Disable whitespace indicators
vim.opt.list = false

-- Indent Settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.smarttab = true

-- Fillchars
vim.opt.fillchars = {
    vert = "│",
    fold = "⠀",
    eob = " ",
    msgsep = "‾",
    foldopen = "▾",
    foldsep = "│",
    foldclose = "▸"
}

vim.cmd([[highlight clear SignColumn]])

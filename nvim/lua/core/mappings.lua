vim.g.mapleader = " "

-- Quit
vim.keymap.set('n', '<C-q>', '<cmd>:q<CR>')

-- Copy all text
vim.keymap.set('n', '<C-a>', '<cmd>%y+<CR>')

-- Saving a file via Ctrl+S
vim.keymap.set('i', '<C-s>', '<cmd>:w<CR>')
vim.keymap.set('n', '<C-s>', '<cmd>:w<CR>')

-- NvimTree
vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>tf', ':NvimTreeFocus<CR>')

-- Telescope
vim.keymap.set('n', '<leader>f', '<cmd>Telescope find_files<CR>')
vim.keymap.set('n', '<leader>g', '<cmd>Telescope live_grep<CR>')
vim.keymap.set('n', '<leader>b', '<cmd>Telescope buffers<CR>')

-- Neogit
vim.keymap.set('n', '<leader>ng', '<cmd>Neogit<CR>')

-- Diffview
vim.keymap.set('n', '<leader>dv', '<cmd>DiffviewOpen<CR>')
vim.keymap.set('n', '<leader>dc', '<cmd>DiffviewClose<CR>')

-- Gitsigns
vim.keymap.set('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>')
vim.keymap.set('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>')
vim.keymap.set('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
vim.keymap.set('n', '<leader>hb', '<cmd>Gitsigns blame_line<CR>')

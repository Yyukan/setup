-- Go indents with tabs (gofmt enforces it), so undo the global expandtab/shiftwidth
-- from lua/core/configs.lua for this filetype.
vim.bo.expandtab = false
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 0
vim.bo.smartindent = true

-- `gq` should reflow within the indent, not re-tab lines (mirrors Vim's ftplugin).
vim.opt_local.formatoptions:remove("t")

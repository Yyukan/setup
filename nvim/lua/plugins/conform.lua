-- Formatting.
--
-- Formatters are installed by mason (see `ensure_installed` in plugins.lua) and
-- resolved from ~/.local/share/nvim/mason/bin, which is on PATH.
--
-- Go uses goimports (adds/removes imports) followed by gofumpt (stricter gofmt).

local formatters_by_ft = {
  go = { "goimports", "gofumpt" },
  gomod = { "gofmt" },
  lua = { "stylua" },
  sh = { "shfmt" },
  bash = { "shfmt" },
  rust = { "rustfmt" },
}

require("conform").setup({
  formatters_by_ft = formatters_by_ft,

  format_on_save = function(bufnr)
    local conform = require("conform")
    local formatters = formatters_by_ft[vim.bo[bufnr].filetype] or {}
    local usable = vim.tbl_filter(function(name)
      return conform.get_formatter_info(name, bufnr).available
    end, formatters)

    -- No formatter configured or installed for this filetype: leave the buffer
    -- alone unless an LSP can format it.
    if #usable == 0 then
      local lsp_can_format = #vim.lsp.get_clients({
        bufnr = bufnr,
        method = "textDocument/formatting",
      }) > 0
      if not lsp_can_format then
        return nil
      end
    end

    return { lsp_format = "fallback", timeout_ms = 3000 }
  end,
})

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { noremap = true, silent = true, desc = "Format buffer" })

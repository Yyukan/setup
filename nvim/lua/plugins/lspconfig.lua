-- LSP wiring.
--
-- mason-lspconfig v2 (we are on 2.3.0) removed the `handlers` option and renamed
-- `automatic_installation` to `automatic_enable`. Configs are therefore registered
-- explicitly through Neovim's native `vim.lsp.config()` / `vim.lsp.enable()` API.

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Merged into every server config, so nvim-cmp gets snippet + resolve support.
vim.lsp.config("*", { capabilities = capabilities })

-- Mason-installed binaries (gopls, goimports, ...) live in a private bin dir;
-- `require("mason").setup()` prepends it to PATH.

-- Diagnostics presentation.
vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  virtual_text = { spacing = 2, prefix = "●" },
  float = { border = "rounded", source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
  jump = { float = true },
})

-- Buffer-local keymaps, applied once per attached client.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
  callback = function(ev)
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, {
        buffer = ev.buf,
        noremap = true,
        silent = true,
        desc = desc,
      })
    end

    local function telescope(builtin, desc)
      return function()
        local ok, tb = pcall(require, "telescope.builtin")
        if not ok then
          vim.notify("telescope.nvim is not available", vim.log.levels.WARN)
          return
        end
        tb[builtin]({ desc = desc })
      end
    end

    map("n", "gd", vim.lsp.buf.definition, "LSP: definition")
    map("n", "gD", vim.lsp.buf.declaration, "LSP: declaration")
    map("n", "gi", vim.lsp.buf.implementation, "LSP: implementation")
    map("n", "gr", telescope("lsp_references", "LSP: references"), "LSP: references")
    map("n", "K", vim.lsp.buf.hover, "LSP: hover")
    map("n", "<C-k>", vim.lsp.buf.signature_help, "LSP: signature help")
    map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: rename")
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "LSP: code action")
    map("n", "<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, "LSP: format buffer")

    map("n", "<leader>d", vim.diagnostic.open_float, "Diagnostics: line float")
    map("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "Diagnostics: previous")
    map("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "Diagnostics: next")
    map("n", "<leader>ld", telescope("diagnostics", "Diagnostics: all"), "Diagnostics: picker")
    map("n", "<leader>ls", telescope("lsp_document_symbols", "Symbols: document"), "Symbols: document")

    -- Inlay hints: gopls and rust-analyzer both support them.
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
      map("n", "<leader>lh", function()
        local buf = vim.api.nvim_get_current_buf()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
      end, "LSP: toggle inlay hints")
    end
  end,
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "gopls",
    "lua_ls",
    "rust_analyzer",
  },
  -- Enabled explicitly below so the set of active servers stays greppable.
  automatic_enable = false,
})

-- Go -------------------------------------------------------------------------
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true,
      usePlaceholders = true,
      completeUnimported = true,
      -- gopls >= 0.22 no longer advertises semantic tokens by default.
      semanticTokens = false,
      analyses = {
        unusedparams = true,
        shadow = true,
        nilness = true,
        unusedwrite = true,
        useany = true,
        staticcheck = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})

-- Lua ------------------------------------------------------------------------
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

-- Rust -----------------------------------------------------------------------
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      check = { command = "clippy" },
      cargo = { allFeatures = true },
      inlayHints = { bindingModeHints = { enable = true } },
    },
  },
})

vim.lsp.enable({ "gopls", "lua_ls", "rust_analyzer" })

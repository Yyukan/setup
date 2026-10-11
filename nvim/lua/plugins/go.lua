-- Go workflow: build / vet / test / run plus the two generators worth having.
--
-- Deliberately plugin-free: every command shells out to `go <subcommand>` and
-- drops the output into the quickfix list. `gotests` and `gomodifytags` are
-- installed by mason.
--
-- Keymaps live under <leader>G (<leader>g is Telescope live_grep).

--- Directory of the nearest go.mod above the current buffer.
local function project_root()
  local name = vim.api.nvim_buf_get_name(0)
  local start = name ~= "" and vim.fs.dirname(name) or vim.uv.cwd()
  local mod = vim.fs.find("go.mod", { path = start, upward = true, type = "file" })[1]
  return mod and vim.fs.dirname(mod) or start
end

--- Absolute path of the current buffer.
local function current_file()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    return nil
  end
  return vim.fs.normalize(name)
end

--- Turn `go` output into quickfix items.
--- Matches "file.go:12:34: msg" (compiler, vet) and "file.go:12: msg" (testing).
---@param output string
---@param cwd string
---@return table[]
local function to_quickfix(output, cwd)
  local items = {}
  for line in vim.gsplit(output, "\n", { plain = true }) do
    if line ~= "" then
      -- Leading whitespace is part of the "indented failure" layout of `testing`.
      local file, lnum, col, msg = line:match("^%s*(%S-%.go):(%d+):(%d+):%s*(.*)$")
      if not file then
        file, lnum, msg = line:match("^%s*(%S-%.go):(%d+):%s*(.*)$")
      end
      if file then
        local abs = file:sub(1, 1) == "/" and file or vim.fs.joinpath(cwd, file)
        items[#items + 1] = {
          filename = abs,
          lnum = tonumber(lnum),
          col = col and tonumber(col) or nil,
          text = msg,
          type = "E",
        }
      else
        items[#items + 1] = { text = line }
      end
    end
  end
  return items
end

--- Run a shell command in the project root and report the result in the quickfix
--- list. `args` is the full argv; `title` labels the quickfix.
---@param args string[]
---@param title string
local function run(args, title)
  local cwd = project_root()
  vim.notify(title, vim.log.levels.INFO)

  vim.system(args, { cwd = cwd, text = true }, vim.schedule_wrap(function(out)
    local output = (out.stdout or "") .. (out.stderr or "")
    local items = to_quickfix(output, cwd)
    vim.fn.setqflist({}, " ", { title = title, items = items })

    -- Plain "ok  pkg  0.1s" lines should not pop the quickfix open on success.
    local located = vim.tbl_filter(function(item)
      return item.filename ~= nil
    end, items)

    if (out.code or 0) ~= 0 or #located > 0 then
      vim.cmd("copen")
    else
      vim.notify(title .. ": ok", vim.log.levels.INFO)
    end
  end))
end

--- Name of the enclosing Go function, or nil.
local function current_go_func()
  local bufnr = vim.api.nvim_get_current_buf()
  local ok, node = pcall(vim.treesitter.get_node, { bufnr = bufnr })
  if not ok or not node then
    return nil
  end
  while node do
    local kind = node:type()
    if kind == "function_declaration" or kind == "method_declaration" then
      local name = node:field("name")[1]
      return name and vim.treesitter.get_node_text(name, bufnr) or nil
    end
    node = node:parent()
  end
  return nil
end

--- Refuse to run generators while the buffer has unsaved changes, because they
--- read and rewrite the file on disk.
local function require_clean_buffer()
  if vim.bo.modified then
    vim.notify("Save the buffer first", vim.log.levels.WARN)
    return false
  end
  return true
end

-- Commands -------------------------------------------------------------------

local function go_cmd(name, fn)
  vim.api.nvim_create_user_command(name, fn, { desc = "go: " .. name, nargs = "*", bang = true })
end

go_cmd("GoBuild", function(args)
  local target = args.args ~= "" and args.args or "./..."
  run({ "go", "build", target }, "go build " .. target)
end)

go_cmd("GoVet", function(args)
  local target = args.args ~= "" and args.args or "./..."
  run({ "go", "vet", target }, "go vet " .. target)
end)

go_cmd("GoTest", function(args)
  local target = args.args ~= "" and args.args or "./..."
  run({ "go", "test", target }, "go test " .. target)
end)

go_cmd("GoTestFunc", function()
  local fn = current_go_func()
  if not fn or not fn:match("^%u") then
    vim.notify("Cursor is not inside a test function", vim.log.levels.WARN)
    return
  end
  run({ "go", "test", "-run", "^" .. fn .. "$", "." }, "go test -run '^" .. fn .. "$'")
end)

go_cmd("GoCoverage", function(args)
  local target = args.args ~= "" and args.args or "./..."
  run({ "go", "test", "-cover", target }, "go test -cover " .. target)
end)

go_cmd("GoRun", function(args)
  local target = args.args ~= "" and args.args or "."
  run({ "go", "run", target }, "go run " .. target)
end)

go_cmd("GoTidy", function()
  run({ "go", "mod", "tidy" }, "go mod tidy")
end)

go_cmd("GoGenerateTests", function(args)
  if not require_clean_buffer() then
    return
  end
  local file = current_file()
  if not file then
    return
  end
  local flags = args.args ~= "" and vim.split(args.args, "%s+") or { "-all" }
  local argv = vim.list_extend({ "gotests" }, flags)
  vim.list_extend(argv, { "-w", file })
  run(argv, "gotests")
end)

go_cmd("GoAddTags", function(args)
  local file = current_file()
  if not file or not require_clean_buffer() then
    return
  end
  local tags = args.args ~= "" and args.args or "json,yaml"
  local offset = vim.fn.line2byte(vim.fn.line(".")) + vim.fn.col(".") - 2
  run({
    "gomodifytags",
    "-file", file,
    "-offset", tostring(offset),
    "-w",
    "-add-tags", tags,
    "-transform", "camelcase",
  }, "gomodifytags " .. tags)
end)

go_cmd("GoRestartLsp", function()
  vim.cmd("LspRestart gopls")
end)

-- Switch between foo.go and foo_test.go --------------------------------------

local function toggle_test_file()
  local file = current_file()
  if not file or not file:match("%.go$") then
    vim.notify("Not a Go file", vim.log.levels.WARN)
    return
  end
  local target = file:match("_test%.go$") and file:gsub("_test%.go$", ".go") or file:gsub("%.go$", "_test.go")
  if vim.uv.fs_stat(target) then
    vim.cmd.edit(vim.fn.fnameescape(target))
  else
    vim.notify(vim.fs.basename(target) .. " does not exist", vim.log.levels.WARN)
  end
end

go_cmd("GoToggleTest", toggle_test_file)

-- Keymaps --------------------------------------------------------------------

local function map(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { noremap = true, silent = true, desc = desc })
end

map("<leader>Gb", "<cmd>GoBuild<CR>", "Go: build")
map("<leader>Gr", "<cmd>GoRun<CR>", "Go: run")
map("<leader>Gt", "<cmd>GoTest<CR>", "Go: test package tree")
map("<leader>Gf", "<cmd>GoTestFunc<CR>", "Go: test enclosing function")
map("<leader>Gv", "<cmd>GoVet<CR>", "Go: vet")
map("<leader>Gc", "<cmd>GoCoverage<CR>", "Go: coverage")
map("<leader>Gm", "<cmd>GoTidy<CR>", "Go: mod tidy")
map("<leader>Gg", "<cmd>GoGenerateTests<CR>", "Go: generate tests (gotests)")
map("<leader>Ga", "<cmd>GoAddTags<CR>", "Go: add struct tags")
map("<leader>GT", toggle_test_file, "Go: toggle test file")
map("<leader>GR", "<cmd>GoRestartLsp<CR>", "Go: restart gopls")

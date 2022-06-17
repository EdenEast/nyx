local default_opts = { noremap = true }
local M = {}

local function err(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

local function validate(input, exec)
  vim.validate({
    input = { input, { "string", "table" } },
    exec = { exec, { "string", "function" } },
  })
end

local function merge_opts(opts)
  if opts and type(opts) == "table" then
    opts = vim.tbl_extend("force", default_opts, opts)
  else
    opts = default_opts
  end

  return opts
end

local function mapper(mode, input, exec, opts)
  local ok, errmsg = pcall(validate, input, exec)
  if not ok then
    err(errmsg)
    return
  end

  opts = merge_opts(opts)

  ok, errmsg = pcall(vim.keymap.set, mode, input, exec, opts)
  if not ok then
    err(errmsg)
  end
end

---Create a keymap with either a string or table of modes.
---@param mode string|table
---@param input string
---@param exec string|function
---@param opts table
function M.map(mode, input, exec, opts)
  mapper(mode, input, exec, opts)
end

---Create a normal mode keymap. See :help mapmode-n
---@param input string
---@param exec string|function
---@param opts table
function M.nmap(input, exec, opts)
  mapper("n", input, exec, opts)
end

---Create a insert mode keymap. See :help mapmode-n
---@param input string
---@param exec string|function
---@param opts table
function M.imap(input, exec, opts)
  mapper("i", input, exec, opts)
end

---Create a visual mode keymap. See :help mapmode-v
---@param input string
---@param exec string|function
---@param opts table
function M.vmap(input, exec, opts)
  mapper("v", input, exec, opts)
end

---Create a command mode keymap. See :help mapmode-c
---@param input string
---@param exec string|function
---@param opts table
function M.cmap(input, exec, opts)
  mapper("c", input, exec, opts)
end

---Create a visual and select mode keymap. See :help mapmode-x
---@param input string
---@param exec string|function
---@param opts table
function M.xmap(input, exec, opts)
  mapper("x", input, exec, opts)
end

---Create a operator-pending mode keymap. See :help mapmode-o
---@param input string
---@param exec string|function
---@param opts table
function M.omap(input, exec, opts)
  mapper("o", input, exec, opts)
end

---Create a select mode keymap. See :help mapmode-s
---@param input string
---@param exec string|function
---@param opts table
function M.smap(input, exec, opts)
  mapper("s", input, exec, opts)
end

---Create a terminal mode keymap. See :help mapmode-t
---@param input string
---@param exec string|function
---@param opts table
function M.tmap(input, exec, opts)
  mapper("t", input, exec, opts)
end

return M

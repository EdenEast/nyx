local debug = false

local fmt = string.format
local cmd = debug and print or vim.api.nvim_command

local M = {}

-- function store
local store = {}

local function store_fn(fn)
  table.insert(store, fn)
  local index = #store
  return fmt([[lua require('core.event').exec(%d)]], index)
end

local function construct_group(name, cmds)
  cmd("augroup " .. name)
  cmd("autocmd!")
  for _, au in ipairs(cmds) do
    local event = au[1]
    local spec = #au == 2 and au[2] or { au[2], au[3] }
    M.au(event, spec)
  end
  cmd("augroup END")
end

M.exec = function(index)
  store[index]()
end

M.au = function(event, spec)
  local is_table = type(spec) == "table"
  local pattern = is_table and spec[1] or "*"
  local action = is_table and spec[2] or spec

  if type(action) == "function" then
    action = store_fn(action)
  end

  event = type(event) == "table" and table.concat(event, ",") or event
  cmd(fmt([[autocmd %s %s %s]], event, pattern, action))
end

M.group = function(...)
  local wrap = { ... }

  if type(wrap[1]) == "string" then
    construct_group(wrap[1], wrap[2])
    return
  end

  for name, opts in pairs(wrap[1]) do
    construct_group(name, opts)
  end
end

vim.au = setmetatable({}, {
  __index = M,
  __newindex = function(_, key, value)
    M.au(key, value)
  end,
  __call = function(_, event, pattern, action)
    M.au(event, action == nil and pattern or { pattern, action })
  end,
})

vim.aug = setmetatable({}, {
  __index = M,
  __newindex = function(_, key, value)
    construct_group(key, value)
  end,
  __call = function(_, ...)
    M.group(...)
  end,
})

--
-- Debug / Testing
--

local debug_tests = function()
  -- stylua: ignore
  local function header(name)
    name = "-- " .. name .. " "
    local pad_len, padding = 80 - #name, "-"
    for _ = 1, pad_len, 1 do padding = padding .. "-" end
    print(name .. padding)
  end

  -- Autocmd ------------------------------------------------------------------
  header("au __newindex")
  vim.au.TextYankPost = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 120 })
  end

  header("au __newindex with pattern")
  vim.au.BufEnter = { ".txt", "echo &ft" }

  header("au call()")
  vim.au("VimEnter", [[lua require('core.theme').reload()]])

  header("au call() with pattern")
  vim.au("BufWritePre", "/tmp/*", "setlocal noundofile")

  header("au call() with table for events")
  vim.au({ "BufEnter", "FocusGained", "InsertLeave" }, [[lua require('core.util').set_relnumber()]])

  -- Augrous ------------------------------------------------------------------
  header("aug __newindex")
  vim.aug.bufs = {
    { "BufWritePre", "/tmp/*", "setlocal noundofile" },
    { "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
    { "BufWinEnter", "match Error /\\s\\+%#@<!$/" },
  }

  header("aug call() with single group")
  vim.aug("whitespace", {
    { "BufWinEnter", "*", "match Error /\\s\\+%#@<!$/" },
    { "InsertEnter", "*", "match Error /\\s\\+%#@<!$/" },
    { "InsertLeave", "match Error /\\s\\+$/" },
  })

  header("aug call with multiple groups")
  vim.aug({
    bufs = {
      { "BufWritePre", "/tmp/*", "setlocal noundofile" },
      { "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
    },
    numtoggle = {
      { { "BufEnter", "FocusGained", "InsertLeave" }, "*", [[lua require('core.util').set_relnumber()]] },
      { { "BufEnter", "FocusGained", "InsertLeave" }, [[lua require('core.util').set_no_relnumber()]] },
    },
    linereturn = {
      { "BufReadPost", [[if line("'\"") > 0 && line("'\"") <= line("$") | execute 'normal! g`"zvzz' | endif]] },
    },
  })
end

if debug then
  debug_tests()
end

return M

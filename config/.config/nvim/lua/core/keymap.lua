-- Modified version of nest.nvim (https://github.com/LionC/nest.nvim)
local fmt = string.format

local M = {}

M.defaults = {
  mode = "n",
  prefix = "",
  buffer = false,
  opts = {
    noremap = true,
    silent = true,
  },
}

local store = {}

M._callFn = function(index)
  store[index]()
end

M._execExpr = function(index)
  local keys = store[index]()
  return vim.api.nvim_replace_termcodes(keys, true, true, true)
end

local function funcToRhs(func, expr)
  table.insert(store, func)
  local index = #store
  return expr and fmt([[v:lua vim.keymap._execExpr(%d)]], index) or fmt([[<cmd>lua vim.keymap._callFn(%d)<cr>]], index)
end

local function mergeOpts(left, right)
  local ret = vim.deepcopy(left)

  if right == nil then
    return ret
  end

  if right.mode ~= nil then
    ret.mode = right.mode
  end

  if right.buffer ~= nil then
    ret.buffer = right.buffer
  end

  if right.prefix ~= nil then
    ret.prefix = ret.prefix .. right.prefix
  end

  if right.silent ~= nil then
    ret.opts.silent = right.silent
  end

  if right.expr ~= nil then
    ret.opts.expr = right.expr
  end

  if right.noremap ~= nil then
    ret.opts.noremap = right.noremap
  end

  if right.unique ~= nil then
    ret.opts.unique = right.unique
  end

  if right.script ~= nil then
    ret.opts.script = right.script
  end

  return ret
end

M.new = function(...)
  local resolved = M.resolve({ ... })
  for _, r in ipairs(resolved) do
    -- TODO: Validate that there is a lhs and rhs
    if r.buffer then
      local bufnr = (r.buffer == 0) and 0 or r.buffer
      vim.api.nvim_buf_set_keymap(bufnr, r.mode, r.prefix, r.rhs, r.opts)
    else
      vim.api.nvim_set_keymap(r.mode, r.prefix, r.rhs, r.opts)
    end
  end
end

M.resolve = function(config, presets)
  local merged = mergeOpts(presets or M.defaults, config)

  local lhs = config[1]
  if type(lhs) == "table" then
    local ret = {}
    for _, value in ipairs(config) do
      local resolve_results = M.resolve(value, merged)
      for _, r in ipairs(resolve_results) do
        table.insert(ret, r)
      end
    end

    return ret
  end

  merged.prefix = merged.prefix .. lhs

  local rhs = config[2]
  rhs = type(rhs) == "function" and funcToRhs(rhs, merged.opts.expr) or rhs

  if type(rhs) == "table" then
    local ret = {}
    for _, value in ipairs(rhs) do
      local result = M.resolve(value, merged)
      for _, r in ipairs(result) do
        table.insert(ret, r)
      end
    end

    return ret
  end

  local ret = {}
  for mode in string.gmatch(merged.mode, ".") do
    local m = mode == "_" and "" or mode
    local copy = vim.deepcopy(merged)
    copy.mode = m
    copy.rhs = rhs
    table.insert(ret, copy)
  end

  return ret
end

setmetatable(M, {
  __call = function(t, ...)
    t.new(...)
  end,
})

-- local function test(...)
--   return M.resolve({ ... })
-- end

-- P(test("<leader>x", {
--   { "x", [[<cmd>TroubleToggle<cr>]] },
--   { "w", [[<cmd>TroubleToggle lsp_workspace_diagnostics<cr>]] },
--   { "d", [[<cmd>TroubleToggle lsp_document_diagnostics<cr>]] },
--   { "l", [[<cmd>TroubleToggle locallist<cr>]] },
--   { "q", [[<cmd>TroubleToggle quickfix<cr>]] },
-- }))

-- P(M.resolve({
--   {
--     "<leader>x",
--     {
--       { "x", [[<cmd>TroubleToggle<cr>]] },
--       { "w", [[<cmd>TroubleToggle lsp_workspace_diagnostics<cr>]] },
--       { "d", [[<cmd>TroubleToggle lsp_document_diagnostics<cr>]] },
--       { "l", [[<cmd>TroubleToggle locallist<cr>]] },
--       { "q", [[<cmd>TroubleToggle quickfix<cr>]] },
--     },
--   },
-- }))

vim.keymap = M

return M

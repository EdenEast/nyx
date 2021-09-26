local fmt = string.format
local cmd = vim.api.nvim_command

-- Function store -------------------------------------------------------------
local store = {}

local function store_fn(fn)
  table.insert(store, fn)
  local index = #store
  return fmt([[lua require('core.event')._exec(%d)]], index)
end

local function exec_fn(index)
  store[index]()
end

local function construct_cmd(event, spec)
  local is_table = type(spec) == "table"
  local pattern = is_table and spec[1] or "*"
  local action = is_table and spec[2] or spec

  if type(action) == "function" then
    action = store_fn(action)
  end

  event = type(event) == "table" and table.concat(event, ",") or event
  cmd(fmt([[autocmd %s %s %s]], event, pattern, action))
end

local function construct_group(name, cmds)
  cmd("augroup " .. name)
  cmd("autocmd!")
  for _, au in ipairs(cmds) do
    local event = au[1]
    local spec = #au == 2 and au[2] or { au[2], au[3] }
    construct_cmd(event, spec)
  end
  cmd("augroup END")
end

local au = setmetatable({}, {
  __newindex = function(_, event, cmds)
    construct_cmd(event, cmds)
  end,
  __call = function(_, event, pattern, action)
    construct_cmd(event, action == nil and pattern or { pattern, action })
  end,
})

local aug = setmetatable({}, {
  __newindex = function(_, name, cmds)
    construct_group(name, cmds)
  end,
  __call = function(_, ...)
    local wrap = { ... }

    if type(wrap[1]) == "string" then
      construct_group(wrap[1], wrap[2])
      return
    end

    for name, opts in pairs(wrap[1]) do
      construct_group(name, opts)
    end
  end,
})

edn.au = au
edn.aug = aug

return { au = au, aug = aug, _exec = exec_fn }

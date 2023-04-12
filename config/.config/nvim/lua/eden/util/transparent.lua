local path = require("eden.core.path")
local U = require("eden.util")

local none = "NONE"
local cache_file = path.join(path.cachehome, "transparent_cache")
local cache = {}

local function read_cache()
  local exists, lines = pcall(vim.fn.readfile, cache_file)
  vim.g.eden_transparent_enabled = exists and #lines > 0 and vim.trim(lines[1]) == "true" or false
end

local function write_cache() vim.fn.writefile({ tostring(vim.g.eden_transparent_enabled) }, cache_file) end

local function copy(t)
  local r = {}
  for k, v in pairs(t) do
    r[k] = v
  end
  return r
end

if vim.g.eden_transparent_enabled == nil then read_cache() end

local M = {
  groups = {
    "Normal",
    "NormalNC",
  },
}

function M.clear()
  print("clear")
  for _, group in ipairs(M.groups) do
    local hl = vim.api.nvim_get_hl(0, { name = group })
    cache[group] = copy(hl)
    if hl.bg then hl.bg = none end
    vim.api.nvim_set_hl(0, group, hl)
  end
end

function M.restore()
  print("clear")
  for _, group in ipairs(M.groups) do
    local hl = cache[group]
    if hl then
      vim.api.nvim_set_hl(0, group, hl)
      cache[group] = nil
    end
  end
end

---@param value boolean?
function M.toggle(value)
  vim.g.eden_transparent_enabled = value == nil and not vim.g.eden_transparent_enabled or value
  write_cache()

  if vim.g.eden_transparent_enabled then
    M.clear()
    U.info("Enabled", { title = "Transparency" })
  else
    M.restore()
    U.info("Disable", { title = "Transparency" })
  end
end

function M.init()
  vim.api.nvim_create_user_command("ToggleTransparency", function() require("eden.util.transparent").toggle() end, {})
  vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = vim.api.nvim_create_augroup("eden_transparent_toggle", { clear = true }),
    callback = function()
      print("in transparent autocmd")
      if vim.g.eden_transparent_enabled then require("eden.util.transparent").clear() end
    end,
  })
end

return M

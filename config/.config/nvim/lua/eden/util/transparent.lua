local cache_file = require("eden.core.path")
local U = require("eden.util")

local none = "NONE"
local cache_file = cache_file.join(cache_file.cachehome, "transparent_cache")

local function read_cache()
  local exists, lines = pcall(vim.fn.readfile, cache_file)
  vim.g.eden_transparent_enabled = exists and #lines > 0 and vim.trim(lines[1]) == "true" or false
end

local function write_cache() vim.fn.writefile({ tostring(vim.g.eden_transparent_enabled) }, cache_file) end

if vim.g.eden_transparent_enabled == nil then read_cache() end

local M = {
  groups = {
    "Normal",
    "NormalNC",
  },
}

function M.clear()
  for _, group in ipairs(M.groups) do
    local hl = vim.api.nvim_get_hl(0, { name = group })
    if hl.bg then hl.bg = none end
    vim.api.nvim_set_hl(0, group, hl)
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
    vim.cmd.colorscheme(vim.g.colors_name)
    U.info("Disable", { title = "Transparency" })
  end
end

function M.init()
  vim.api.nvim_create_user_command("ToggleTransparency", function() require("eden.util.transparent").toggle() end, {})
  vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
    group = vim.api.nvim_create_augroup("eden_transparent_toggle", { clear = true }),
    callback = function()
      if vim.g.eden_transparent_enabled then require("eden.util.transparent").clear() end
    end,
  })
end

return M

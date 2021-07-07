local global = require("core.global")
local path = require("core.path")
local augroup = require("core.event")

local default = "zephyr"
local cache = path.join(global.cachehome, "theme.txt")

local theme = {}

local event_group = {
  theme = {
    { "ColorScheme", "*", [[lua require('core.theme').hook()]] },
    { "User", "PackerComplete", [[lua require('core.theme').reload()]] },
  },
}

theme.hook = function()
  if vim.g.colors_name then
    vim.fn.writefile({ vim.g.colors_name }, cache)
  end
end

theme.init = function()
  if not vim.g.colors_name then
    theme.reload()
  end

  augroup(event_group)
end

theme.reload = function()
  local scheme = (path.exists(cache)) and vim.fn.readfile(cache)[1] or default
  theme.set(scheme)
end

theme.set = function(scheme)
  local installed_schemes = vim.fn["getcompletion"]("", "color")
  if vim.tbl_contains(installed_schemes, scheme) then
    vim.cmd("colorscheme " .. scheme)
  end
end

return theme

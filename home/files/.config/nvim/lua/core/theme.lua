local global = require('core.global')
local path   = require('core.path')
local event  = require('core.event')

local default = 'zephyr'
local cache = path.join({global.cachehome, 'theme.txt'})

local theme = {}

local event_group = {
  theme = {
    {'ColorScheme', '*', [[lua require('core.theme').hook()]]};
  }
}

theme.hook = function()
  if vim.g.colors_name then
    vim.fn.writefile({vim.g.colors_name}, cache)
  end
end

theme.init = function()
  if not vim.g.colors_name then
    local scheme = (path.exists(cache)) and vim.fn.readfile(cache)[1] or default
    vim.cmd('colorscheme ' .. scheme)
  end

  event.create_augroups(event_group)
end

return theme

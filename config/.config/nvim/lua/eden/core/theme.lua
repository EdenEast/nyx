local path = require("eden.core.path")
local event = require("eden.core.event")

local default = "nightfox"
local cache = path.join(path.cachehome, "theme.txt")

local theme = {}

local function init()
  if not vim.g.colors_name then
    theme.reload()
  end

  event.aug.user_theme = {
    {
      "ColorScheme",
      function()
        require("eden.core.theme").hook()
      end,
    },
  }
end

theme.hook = function()
  if vim.g.colors_name then
    vim.fn.writefile({ vim.g.colors_name }, cache)
  end
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

init()

return theme

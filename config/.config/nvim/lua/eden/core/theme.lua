local path = require("eden.core.path")

local default = "nightfox"
local cache = path.join(path.cachehome, "theme.txt")

local theme = {}

local function init()
  vim.opt.termguicolors = true
  if not vim.g.colors_name then
    theme.reload()
  end

  augroup("UserTheme", {
    {
      event = "ColorScheme",
      exec = function()
        require("eden.core.theme").hook()
      end,
    },
  })
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
  pcall(vim.cmd, "colorscheme " .. scheme)
end

init()

return theme

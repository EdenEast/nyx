local path = require("eden.core.path")

local default = "nightfox"
local cache = path.join(path.cachehome, "theme.txt")

local theme = {}

local function init()
  vim.opt.termguicolors = true
  if not vim.g.colors_name then
    theme.reload()
  end

  local group = vim.api.nvim_create_augroup("eden_theme_handler", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      require("eden.core.theme").hook()
    end,
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
  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, "colorscheme " .. scheme)
end

init()

return theme

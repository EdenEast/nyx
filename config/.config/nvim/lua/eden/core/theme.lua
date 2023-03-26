local path = require("eden.core.path")
local default = "nightfox"
local cache = path.join(path.cachehome, "theme.txt")

local Theme = {}

function Theme.init()
  vim.opt.termguicolors = true
  local group = vim.api.nvim_create_augroup("eden_theme_handler", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      require("eden.core.theme").hook()
    end,
  })
end

function Theme.hook()
  if vim.g.colors_name then
    vim.fn.writefile({ vim.g.colors_name }, cache)
  end
end

function Theme.read_cache()
  return path.exists(cache) and vim.fn.readfile(cache)[1] or default
end

function Theme.set(scheme)
  scheme = scheme or Theme.read_cache()
  pcall(vim.cmd, "colorscheme " .. scheme)
end

return Theme

-- Debug printing with vim.inspect. This needs to be defined before anything
-- else as I use this throughout my config when debugging.
_G.P = function(...)
  for _, v in ipairs({ ... }) do
    print(vim.inspect(v))
  end
  return ...
end

_G.bench = function(label, f, iter)
  iter = iter or 1000
  local sum = 0
  for _ = 1, iter do
    local start = vim.loop.hrtime()
    f()
    sum = sum + (vim.loop.hrtime() - start)
  end
  print(label, sum / iter / 1000000)
end

require("eden.core.clipboard")
require("eden.core.autocmds")
require("eden.core.options")
require("eden.core.keymaps")
local theme = require("eden.core.theme")
theme.init()
require("eden.core.pack")
theme.set(theme.read_cache())

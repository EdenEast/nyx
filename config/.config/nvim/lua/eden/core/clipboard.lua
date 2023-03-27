local platform = require("eden.core.platform")

local name
local copy, paste = {}, {}
local function set(t, value)
  t["+"] = value
  t["*"] = value
end
if platform.is.wsl or platform.is.win then
  name = "win32yank"
  set(copy, "win32yank.exe -i --crlf")
  set(paste, "win32yank.exe -o --lf")
elseif platform.is.mac then
  name = "pbcopy"
  set(copy, "pbcopy")
  set(paste, "pbpaste")
else
  name = "xsel"
  copy["+"] = "xclip -quiet -i -selection clipboard"
  copy["*"] = "xclip -quiet -i -selection primary"
  paste["+"] = "xclip -o -selection clipboard"
  paste["*"] = "xclip -o -selection primary"
end

vim.opt.clipboard = { "unnamed", "unnamedplus" }
vim.g.clipboard = { name = name, copy = copy, paste = paste, cache_enabled = 1 }

local home = os.getenv("HOME")
vim.opt.runtimepath = vim.tbl_filter(function(path)
  return path:find(home, 1, true) ~= 1
end, vim.opt.runtimepath:get())
local root = vim.fn.fnamemodify(".", ":p")
local cache_root = root .. ".nvim"
local lazy_path = cache_root .. "/plugins/lazy.nvim"
for _, name in ipairs({ "config", "data", "state", "cache" }) do
  vim.env[("XDG_%s_HOME"):format(name:upper())] = cache_root .. "/" .. name
end

vim.opt.runtimepath:prepend(lazy_path)
vim.opt.runtimepath:prepend(root:sub(1, #root - 1))

if not vim.loop.fs_stat(lazy_path) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazy_path })
end

local path = require("eden.core.path")
require("eden.core")
require("lazy").setup("eden.mod", {
  root = cache_root .. "/plugins",
  dev = {
    path = path.join(path.home, "dev", "plugins"),
    patterns = { "edeneast", "EdenEast" },
    fallback = true,
  },
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      reset = false,
      -- paths = {
      --   root:sub(1, #root - 1),
      -- },
      disabled_plugins = {
        "gzip",
        "matchit",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

require("eden.core.theme")

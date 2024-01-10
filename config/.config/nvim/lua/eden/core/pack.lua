local path = require("eden.core.path")

local dev_root = path.join(path.home, "dev", "plugins")
local lazy_root = path.join(path.cachehome, "lazy")
local lazy_pack = path.join(lazy_root, "pack")
local lazy_cache = path.join(lazy_root, "cache")
local lazy_readme = path.join(lazy_root, "readme")

-- Use dev version of lazy if in my dev plugins folder
local should_bootstrap = true
local lazy_plugin = path.join(dev_root, "lazy.nvim")
if path.exists(lazy_plugin) then
  should_bootstrap = false
else
  lazy_plugin = path.join(lazy_pack, "lazy.nvim")
end

local scheme = require("eden.core.theme").name

-- Bootstrap lazy if not exists
if should_bootstrap and not path.exists(lazy_plugin) then
  vim.fn.system({
    "git",
    "clone",
    "--single-branch",
    "--depth=1",
    "https://github.com/folke/lazy.nvim.git",
    lazy_plugin,
  })
end

vim.opt.runtimepath:prepend(lazy_plugin)

require("lazy").setup("eden.mod", {
  root = lazy_pack,
  dev = {
    path = dev_root,
    patterns = { "edeneast", "EdenEast" },
    fallback = true,
  },
  change_detection = {
    notify = false,
  },
  install = {
    colorscheme = { scheme, "habamax" },
  },
  performance = {
    cache = {
      path = lazy_cache,
    },
    rtp = {
      paths = {
        path.datahome,
        path.join(path.datahome, "after"),
      },
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
  readme = {
    root = lazy_readme,
  },
})

local root = vim.fn.fnamemodify("./.nvim", ":p")
-- set stdpaths to use .nvim
for _, name in ipairs({ "config", "data", "state", "cache" }) do
  vim.env[("XDG_%s_HOME"):format(name:upper())] = root .. "/" .. name
end

-- bootstrap lazy
local lazypath = root .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.runtimepath:prepend(vim.fn.fnamemodify(".", ":p"))
vim.opt.runtimepath:prepend(lazypath)

require("eden.core")

-- call pack manually for now
require("lazy").setup("eden.mod", {
  root = root .. "/plugins",
  -- dev = {
  --   path = dev_root,
  --   patterns = { "edeneast", "EdenEast" },
  --   fallback = true,
  -- },
  performance = {
    rtp = {
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

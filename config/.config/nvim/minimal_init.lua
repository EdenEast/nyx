-- `minimal_init.lua` used for reproducing neovim issues
-- Open with `nvim --clean -u minimal_init.lua`

local install_path = "/tmp/nvim/site/pack/packer/start/packer.nvim"
local compile_path = install_path .. "/plugin/packer_compiled.lua"
vim.opt.packpath = "/tmp/nvim/site"

local function load_plugins()
  local packer = require("packer")
  local use = packer.use
  packer.reset()
  packer.init({ compile_path = compile_path, package_root = "/tmp/nvim/site/pack" })

  use("wbthomason/packer.nvim")
  -- ADD PLUGINS THAT ARE _NECESSARY_ FOR REPRODUCING THE ISSUE

  packer.sync()
end

_G.load_config = function()
  -- ADD INIT.LUA SETTINGS THAT ARE _NECESSARY_ FOR REPRODUCING THE ISSUE
end

if vim.fn.isdirectory(install_path) == 0 then
  vim.fn.system({ "git", "clone", "--depth=1", "https://github.com/wbthomason/packer.nvim", install_path })
end
load_plugins()
vim.cmd([[autocmd User PackerComplete ++once echo "Ready!" | lua load_config()]])

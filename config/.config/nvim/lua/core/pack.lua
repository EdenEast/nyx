local global = require("core.global")
local path = require("core.path")

local fn, api, el = vim.fn, vim.api, vim.loop

local packer = nil
local module_path = path.join(global.confighome, "lua", "modules")
local packer_compiled = path.join(global.datahome, "plugin", "packer_compiled.lua")
local package_root = path.join(global.cachehome, "site", "pack")
local packpath = path.join(package_root, "packer")

local Packer = {}
Packer.__index = Packer

function Packer:load_plugins()
  self.repos = {}

  local get_plugins = function()
    local list = {}
    local tmp = vim.split(fn.globpath(module_path, "*/plugins.lua"), "\n")
    for _, f in ipairs(tmp) do
      list[#list + 1] = f:sub(#module_path - 6, -1)
    end

    return list
  end

  local plugin_files = get_plugins()
  for _, mod in ipairs(plugin_files) do
    local reqpath = mod:sub(0, #mod - 4)
    local repos = require(reqpath)
    for repo, conf in pairs(repos) do
      self.repos[#self.repos + 1] = vim.tbl_extend("force", { repo }, conf)
    end
  end
end

function Packer:load_packer()
  if not packer then
    api.nvim_command("packadd packer.nvim")
    packer = require("packer")
  end

  packer.init({
    compile_path = packer_compiled,
    package_root = package_root,
    git = { clone_timeout = 120 },
    disable_commands = true,
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "single" })
      end,
    },
  })

  packer.reset()

  local use = packer.use
  use({ "wbthomason/packer.nvim", opt = true })
  self:load_plugins()

  for _, repo in ipairs(self.repos) do
    use(repo)
  end
end

function Packer:ensure_plugins()
  local packer_dir = path.join(packpath, "opt", "packer.nvim")
  local packer_url = "https://github.com/wbthomason/packer.nvim"
  local state = el.fs_stat(packer_dir)
  if not state then
    local cmd = string.format("!git clone %s %s", packer_url, packer_dir)
    api.nvim_command(cmd)

    -- Create plugin dir
    el.fs_mkdir(path.join(global.datahome, "plugin"), 511, function()
      assert("make packer compile dir failed")
    end)

    -- If packer_compiled exists but packer plugin does not then the cache was
    -- deleted and needs to be resynced. Kill the compiled file and have it regenerate
    if vim.fn.exists(packer_compiled) then
      vim.cmd(string.format("call delete('%s')", packer_compiled))
    end

    self:load_packer()
    self:install_sync()
    packer.compile()
  end
end

function Packer:exec_func_sync(func)
  vim.g.packer_finished_exec_function = false
  packer.on_complete = function()
    vim.g.packer_finished_exec_function = true
    vim.cmd([[doautocmd User PackerComplete]])
  end

  func()
  vim.wait(120000, function()
    return vim.g.packer_finished_exec_function
  end, 300)
end

function Packer:install_sync()
  if not packer then
    self:load_packer()
  end
  self:exec_func_sync(packer.install)
end

function Packer:update_sync()
  if not packer then
    self:load_packer()
  end
  self:exec_func_sync(packer.update)
end

function Packer:clean_sync()
  if not packer then
    self:load_packer()
  end
  self:exec_func_sync(packer.clean)
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    if not packer then
      Packer:load_packer()
    end
    return packer[key]
  end,
})

function plugins.install_sync()
  Packer:install_sync()
end

function plugins.update_sync()
  Packer:update_sync()
end

function plugins.clean_sync()
  Packer:clean_sync()
end

function plugins.ensure_plugins()
  Packer:ensure_plugins()
end

function plugins.reload_plugins()
  Packer:load_packer()
  packer.install()
  packer.compile()
end

function plugins.auto_compile()
  local file = vim.fn.expand("%:p")
  if file:match(module_path) then
    plugins.clean()
    plugins.compile()
  end
end

function plugins.init_commands()
  vim.cmd([[command! PackerInstall  lua require('core.pack').install()]])
  vim.cmd([[command! PackerUpdate   lua require('core.pack').update()]])
  vim.cmd([[command! PackerSync     lua require('core.pack').sync()]])
  vim.cmd([[command! PackerClean    lua require('core.pack').clean()]])
  vim.cmd([[command! -nargs=* PackerCompile  lua require('core.pack').compile(<q-args>)]])
  vim.cmd([[command! PackerStatus  lua require('core.pack').status()]])
  vim.cmd([[command! PackerProfile  lua require('core.pack').profile_output()]])
  vim.cmd(
    [[command! -nargs=+ -complete=customlist,v:lua.require'packer'.loader_complete PackerLoad lua require('core.pack').loader(<q-args>)]]
  )

  vim.cmd([[command! PackerInstallSync lua require('core.pack').install_sync()]])
  vim.cmd([[command! PackerUpdateSync lua require('core.pack').update_sync()]])
  vim.cmd([[command! PackerCleanSync lua require('core.pack').clean_sync()]])
end

function plugins.local_load(repo_path)
  local name = string.match(repo_path, ".*/(.*)")
  local abs = path.join(global.datahome, "dev-plugins", name)
  local exists = path.exists(abs)
  return exists and abs or repo_path
end

return plugins

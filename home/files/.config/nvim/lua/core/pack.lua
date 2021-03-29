local global = require('core.global')
local path = require('core.path')

local fn,api,el = vim.fn,vim.api,vim.loop;

local packer = nil
local module_path = path.join({global.confighome, 'lua', 'modules'})
local packer_compiled = path.join({global.datahome, 'plugin', 'packer_compiled.vim'})
local package_root = path.join({global.cachehome, 'site', 'pack'})
local packpath = path.join({package_root, 'packer'})

local Packer = {}
Packer.__index = Packer

function Packer:load_plugins()
  self.repos = {}

  local get_plugins = function()
    local list = {}
    local tmp = vim.split(fn.globpath(module_path, '*/plugins.lua'), '\n')
    for _, f in ipairs(tmp) do
      list[#list+1] = f:sub(#module_path - 6,-1)
    end

    return list
  end

  local plugin_files = get_plugins()
  for _, mod in ipairs(plugin_files) do
    local reqpath = mod:sub(0,#mod-4)
    local repos = require(reqpath)
    for repo, conf in pairs(repos) do
      self.repos[#self.repos+1] = vim.tbl_extend('force', {repo}, conf)
    end
  end
end

function Packer:load_packer()
  if not packer then
    api.nvim_command('packadd packer.nvim')
    packer = require('packer')
  end

  packer.init({
    compile_path = packer_compiled,
    package_root = package_root,
    git = { clone_timeout = 120 },
    disable_commands = true
  })

  packer.reset()

  local use = packer.use
  use {'wbthomason/packer.nvim', opt = true}
  self:load_plugins()

  for _, repo in ipairs(self.repos) do
    use(repo)
  end
end

function Packer:ensure_plugins()
  local packer_dir = path.join({packpath, 'opt', 'packer.nvim'})
  local packer_url = 'https://github.com/wbthomason/packer.nvim'
  local state =  el.fs_stat(packer_dir)
  if not state then
    local cmd = string.format('!git clone %s %s', packer_url, packer_dir)
    api.nvim_command(cmd)

    -- Create plugin dir 
    el.fs_mkdir(path.join({global.datahome, 'plugin'}), 511, function()
      assert('make packer compile dir failed')
    end)

    self:load_packer()
    packer.install()
    packer.compile()
  end
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    if not packer then
      Packer:load_packer()
    end
    return packer[key]
  end
})

function plugins.ensure_plugins()
  Packer:ensure_plugins()
end

function plugins.reload_plugins()
  Packer:load_packer()
  packer.install()
  packer.compile()
end

function plugins.auto_compile()
  local file = vim.fn.expand('%:p')
  if file:match(module_path) then
    plugins.clean()
    plugins.compile()
  end
end

function plugins.init_commands()
  vim.cmd [[command! PackerCompile lua require('core.pack').compile()]]
  vim.cmd [[command! PackerInstall lua require('core.pack').install()]]
  vim.cmd [[command! PackerUpdate lua require('core.pack').update()]]
  vim.cmd [[command! PackerSync lua require('core.pack').sync()]]
  vim.cmd [[command! PackerClean lua require('core.pack').clean()]]
end

return plugins


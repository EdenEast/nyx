local packer = nil
local packer_config = {
  package_root = string.format("%s/site/pack", vim.g.cache_root),
  compile_path = string.format("%s/plugin/packer_compiled.vim", vim.g.local_config_root)
}

local packer_repo_url = 'https://github.com/wbthomason/packer.nvim'
local packer_path = vim.fn['eden#path#join']({vim.g.cache_root, 'site', 'pack', 'packer', 'opt', 'packer.nvim'})
local packer_pack_root = vim.fn['eden#path#join']({vim.g.config_root, 'lua', 'pack'})

function install_packer()
  -- Checking if packer exists
  vim.fn.mkdir(vim.fn.fnamemodify(packer_path, ':p:h'), "p")
  vim.fn.system(string.format("git clone %s %s", packer_repo_url, packer_path))
  local out = vim.fn.system(string.format(
    'git clone %s %s',
    packer_repo_url,
    packer_path
  ))
end

if vim.fn['isdirectory'](packer_path) == 0 then
  install_packer()
end

local function init()
  if packer == nil then
    packer = require('packer')
    packer.init(packer_config)
  end

  packer.reset()

 local source_file = function(file)
   local status, result = pcall(dofile, file)
   if not status then
     print(result)
     return nil
   end
   return result
 end

  -- Packer manage packer as an optional plugin
  packer.use {
    'wbthomason/packer.nvim',
    opt = true,
  }

  local files = vim.fn.split(vim.fn.globpath(packer_pack_root, '**/*.lua'), '\n')
  for _, file in pairs(files) do
    source_file(file)
  end
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end
})

return plugins

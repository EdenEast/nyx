local has, wk = pcall(require, 'which-key')

P = function(a)
  print(vim.inspect(a))
end

-- Reload a lua module
RELOAD = function(pack)
  package.loaded[pack] = nil
  return require(pack)
end

-- Unload a lua module
UNLOAD = function(pack)
  package.loaded[pack] = nil
end

local global = require('core.global')
local path = require('core.path')

path.init()

local disable_distibution_plugins = function()
  vim.g.loaded_gzip              = 1
  vim.g.loaded_tar               = 1
  vim.g.loaded_tarPlugin         = 1
  vim.g.loaded_zip               = 1
  vim.g.loaded_zipPlugin         = 1
  vim.g.loaded_getscript         = 1
  vim.g.loaded_getscriptPlugin   = 1
  vim.g.loaded_vimball           = 1
  vim.g.loaded_vimballPlugin     = 1
  vim.g.loaded_matchit           = 1
  vim.g.loaded_matchparen        = 1
  vim.g.loaded_2html_plugin      = 1
  vim.g.loaded_logiPat           = 1
  vim.g.loaded_rrhelper          = 1
  vim.g.loaded_netrw             = 1
  vim.g.loaded_netrwPlugin       = 1
  vim.g.loaded_netrwSettings     = 1
  vim.g.loaded_netrwFileHandlers = 1
end

local leader_map = function()
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','

  -- Clear mappings for leader keys to be reassigned later
  -- on in the config
  vim.api.nvim_set_keymap('n', ' ', '', {noremap = true})
  vim.api.nvim_set_keymap('x', ' ', '', {noremap = true})
  vim.api.nvim_set_keymap('n', ',', '', {noremap = true})
  vim.api.nvim_set_keymap('x', ',', '', {noremap = true})

  vim.whichkey = function(keys, value)
    if has then wk.register({[keys] = value}) end
  end

  -- Defining the maps for whichkey to use when it is loaded here
  -- so that it can be populated.
  vim.which_leader = {
    b = { name = '+buffer' },
    c = { name = '+code' },
    f = { name = '+find' },
    g = { name = '+git' },
    t = { name = '+toggle' },
  }
  vim.which_localleader = {}
  vim.which_prev = {
    name = '+previous'
  }
  vim.which_next = {
    name = '+next'
  }
end

-- There is currently an issue with this solution as you cannot call `vim.fn` functions
-- inside `vim.loop` functions.
-- Issue: https://github.com/neovim/nvim-lspconfig/issues/899
local windows_spawn_hotfix = function()
  if not global.is_windows then
    return
  end

  -- Note: Currently there is an issue with luv on windows where it does not
  -- execute `.cmd` executables. This work around is taken from
  -- `neovim/nvim-lspconfig` https://github.com/neovim/nvim-lspconfig#windows
  vim.loop.spawn = (function ()
    local spawn = vim.loop.spawn
    return function(p, options, on_exit)

      local full_path = vim.fn.exepath(p)
        return spawn(full_path, options, on_exit)
    end
  end)()
end

local load_core = function()
  disable_distibution_plugins()
  leader_map()

  local pack = require('core.pack')
  pack.ensure_plugins()
  pack.init_commands()

  require('core.theme').init()

  -- Load keymap in vim.keymap
  require('core.keymap')

  -- Load opt into vim.opt
  require('core.options')
  require('core.event')

  -- load base neovim user configuration
  require('user.options')
  require('user.keymap')
  require('user.event')

  -- execute `lua/plugin/*.lua` and `lua/ftplugin/*.lua`
  require('core.luaplug').setup()
end

load_core()

-- https://github.com/vim-save/dotfile/blob/f3b8653d9d144ead46a03e9de5ad28af4d9cd2c6/nvim/.config/nvim/lua/core/init.lua
-- https://github.com/martinsione/dotfiles/tree/541932826fd6e736145e2c5ea1787e606486b0fa/src/.config/nvim
-- vim: sw=2 ts=2 sts=2 et

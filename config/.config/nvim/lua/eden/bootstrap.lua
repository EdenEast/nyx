-- This is the entry point for my neovim configuration. This file is meant to
-- initialize / bootstrap the rest of my configuration. This would include
-- setting up the following:
--   - Disable builtin/shipped neovim plugins
--   - Initialize my runtimepath/packpath variable to include $XDG_CACHE_HOME
--   - Set leader key and remove all mappings attached to it (`space`)
--   - Load custom api's for working with keymaps, and autocommands
--   - Ensure that required bootstrapping plugins are installed
--   - Setup/Load packer modules
--     - Install plugins if ensured plugins were missing
--   - Load main configuration after packer setup is complete

-- Global state, config and function store for my config
_G.edn = {}

-- Debug printing with vim.inspect. This needs to be defined before anything
-- else as I use this throughout my config when debugging.
_G.P = function(...)
  for _, v in ipairs({ ... }) do
    print(vim.inspect(v))
  end

  return ...
end

-- Debug print with vim.inspect and yank the printed results into a register.
-- The default register is `*`
_G.Y = function(value, reg)
  reg = reg or [[*]]
  local inspect = vim.inspect(value)
  vim.fn.setreg(reg, inspect, "l")
  print(inspect)
  return value
end

-- Debugging module by reloading it. Convenience wrapper
-- around `eden.core.reload`.
_G.R = function(name)
  require("eden.lib.reload").reload_module(name)
  return require(name)
end

local path = require("eden.core.path")
local pack = require("eden.core.pack")

-- Disable some of the distributed plugins that are
-- shipped with neovim
local function disable_distibution_plugins()
  vim.g.loaded_gzip = true
  vim.g.loaded_tar = true
  vim.g.loaded_tarPlugin = true
  vim.g.loaded_zip = true
  vim.g.loaded_zipPlugin = true
  vim.g.loaded_getscript = true
  vim.g.loaded_getscriptPlugin = true
  vim.g.loaded_vimball = true
  vim.g.loaded_vimballPlugin = true
  vim.g.loaded_2html_plugin = true
  vim.g.loaded_rrhelper = true
  vim.g.loaded_netrw = true
  vim.g.loaded_netrwPlugin = true
  vim.g.loaded_netrwSettings = true
  vim.g.loaded_netrwFileHandlers = true
end

-- Initalize runtimepath to contain the following locations
--   - confighome
--   - datahome
--   - cachehome
--
-- This is required because some platforms *cough windows* Do not look in
-- confighome and datahome. This also adds cachehome as that is where all the
-- downloaded cached files are added (plugins, etc).
local function init_runtimepath()
  local rtp = vim.opt.runtimepath:get()

  local result = {
    path.confighome,
    path.datahome,
    path.cachehome,
    path.join(path.datahome, "site"),
    path.join(path.cachehome, "site"),
  }

  local after = {}
  for _, v in ipairs(result) do
    table.insert(after, path.join(v, "after"))
  end

  for _, v in ipairs(rtp) do
    if v:match("[\\/]after$") then
      if not vim.tbl_contains(after, v) then
        table.insert(after, v)
      end
    else
      if not vim.tbl_contains(result, v) then
        table.insert(result, v)
      end
    end
  end

  for _, v in ipairs(after) do
    table.insert(result, v)
  end

  vim.opt.runtimepath = result
  vim.opt.packpath = result
end

-- Initialize leader key to <space>, and `,` to localleader
local function init_leader_keys()
  vim.g.mapleader = " "
  vim.g.maplocalleader = ","

  -- Clear mappings for leader keys to be reassigned later on in the config
  vim.api.nvim_set_keymap("n", " ", "", { noremap = true })
  vim.api.nvim_set_keymap("x", " ", "", { noremap = true })
  vim.api.nvim_set_keymap("n", ",", "", { noremap = true })
  vim.api.nvim_set_keymap("x", ",", "", { noremap = true })
end

-- Entry point
local function init()
  disable_distibution_plugins()
  init_runtimepath()
  init_leader_keys()

  -- Assign the global keymap, and comand function
  require("eden.lib.event")
  require("eden.lib.keymap")
  require("eden.lib.command")

  -- Create default autogroup
  augroup("user_events", {})

  pack.bootstrap(function(installed)
    if installed then
      autocmd({
        event = "User",
        pattern = "PackerComplete",
        exec = function()
          require("eden.main")
        end,
        once = true,
      })

      pack.sync()
    else
      -- Packer is not required to be first time installed so require main configuration file
      require("eden.main")
    end
  end)
end

init()

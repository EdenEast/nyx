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
_G.edn = {
  display = require("eden.extend.display").new(),
}

-- Debug printing with vim.inspect. This needs to be defined before anything
-- else as I use this throughout my config when debugging.
_G.P = function(...)
  for _, v in ipairs({ ... }) do
    print(vim.inspect(v))
  end
  return ...
end

-- Debug printing with vim.inspect. This needs to be defined before anything
-- else as I use this throughout my config when debugging.
_G.D = function(...)
  local info = debug.getinfo(2, "Sl")
  local header = string.format("%s:%s", info.short_src, info.currentline)
  edn.display:write_with_header(header, ...)
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

_G.bench = function(label, f, iter)
  iter = iter or 1000
  local sum = 0
  for _ = 1, iter do
    local start = vim.loop.hrtime()
    f()
    sum = sum + (vim.loop.hrtime() - start)
  end
  print(label, sum / iter / 1000000)
end

-- Disable some of the distributed plugins that are
-- shipped with neovim
local function disable_distibution_plugins()
  vim.g.loaded_gzip = 1
  vim.g.loaded_tar = 1
  vim.g.loaded_tarPlugin = 1
  vim.g.loaded_zip = 1
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_getscript = 1
  vim.g.loaded_getscriptPlugin = 1
  vim.g.loaded_vimball = 1
  vim.g.loaded_vimballPlugin = 1
  -- vim.g.loaded_matchit = 1
  -- vim.g.loaded_matchparen = 1
  vim.g.loaded_2html_plugin = 1
  vim.g.loaded_logiPat = 1
  vim.g.loaded_rrhelper = 1
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1
  vim.g.loaded_tutor_mode_plugin = 1
  vim.g.loaded_remote_plugins = 1
  vim.g.loaded_spellfile_plugin = 1
  vim.g.loaded_shada_plugin = 1
end

-- Initalize runtimepath to contain the following locations
--   - confighome
--   - datahome
--   - cachehome
--
-- This is required because some platforms *cough windows* Do not look in
-- confighome and datahome. This also adds cachehome as that is where all the
-- downloaded cached files are added (plugins, etc).
local function set_runtime_path()
  local path = require("eden.core.path")
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
local function set_leader_keys()
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
  -- set_runtime_path()
  set_leader_keys()

  -- local pack = require("eden.core.pack")

  -- Ensuring that impatient is installed and required before any plugins have been required
  -- Only required until pr is merged https://github.com/neovim/neovim/pull/15436
  -- pack.ensure("lewis6991", "impatient.nvim", {
  --   callback = function()
  --     require("impatient")
  --   end,
  -- })

  require("eden.core.clipboard")
  require("eden.lib.command")
  require("eden.core.event")
  -- require("eden.core.filetype")
  require("eden.core.keymap")
  require("eden.core.options")

  require("eden.core.pack")

  -- pack.ensure_plugins()
  -- pack.trigger_before()
  -- pack.load_compile()
  -- pack.trigger_after()

  -- Once plugins have heen installed set the theme
  require("eden.core.theme")
  -- require("eden.lib.defer").load(20)
end

init()

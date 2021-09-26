-- Global state, config and function store for my config
_G.edn = {}

-- Debug printing with vim.inspect. This needs to be
-- defined before anything else as I use this thoughout
-- my config when debugging.
_G.P = function(...)
  for _, v in ipairs({ ... }) do
    print(vim.inspect(v))
  end

  return ...
end

local path = require("eden.core.path")
local pack = require("eden.core.pack")

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
  vim.g.loaded_2html_plugin = 1
  vim.g.loaded_rrhelper = 1
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1
end

-- Initalize runtimepath to contain the following locations
--   - confighome
--   - datahome
--   - cachehome
--
-- This is required because some platforms *cough windows*
-- Do not look in confighome and datahome. This also adds
-- cachehome as that is where all the downloaded cached files
-- are added (plugins, etc).
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

  pack.bootstrap(function(installed)
    if installed then
      vim.cmd([[autocmd User PackerComplete ++once lua require("eden.main")]])
      pack.sync()
    else
      -- Packer is not required to be first time installed so require main configuration file
      require("eden.main")
    end
  end)
end

init()

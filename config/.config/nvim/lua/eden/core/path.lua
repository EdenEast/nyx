local platform = require("eden.core.platform")
local home = os.getenv("HOME")
local uv = vim.loop
local fmt = string.format

local M = {}

M.sep = platform.is_windows and [[\]] or "/"

-- Join a list of paths together
-- @param ... string list
-- @return string
M.join = function(...)
  return table.concat({ ... }, M.sep)
end

-- Define default values for important path locations
M.home = home
M.confighome = M.join(home, ".config", "nvim")
M.datahome = M.join(home, ".local", "share", "nvim")
M.cachehome = M.join(home, ".cache", "nvim")
M.packroot = M.join(M.cachehome, "site", "pack")
M.packer_compiled = M.join(M.datahome, "lua", "packer_compiled.lua")
M.module_path = M.join(M.confighome, "lua", "eden", "modules")

-- Create a directory
-- @param dir string
M.create_dir = function(dir)
  local state = vim.loop.fs_stat(dir)
  if not state then
    vim.loop.fs_mkdir(dir, 511, function()
      assert("Failed to make path:" .. dir)
    end)
  end
end

-- Returns if the path exists on disk
-- @param p string
-- @return bool
M.exists = function(p)
  local state = vim.loop.fs_stat(p)
  return not (state == nil)
end

-- Get the filepath of a module name
-- Assumes runtimepath of confighome if no runtimepath passed
-- @param modpath string
-- @param runtimepath [string]
-- @return string
M.get_mod_filepath = function(modpath, runtimepath)
  runtimepath = runtimepath or m.confighome
  local partialpath = vim.split(modpath, ".", true)
  return M.join(runtimepath, table.concat(partialpath, M.sep))
end

-- Get all module names in the file directory
M.get_mod_list = function(modpath, runtimepath)
  runtimepath = runtimepath or M.confighome
  runtimepath = M.join(runtimepath, "lua")

  local filepath = M.get_mod_filepath(modpath, runtimepath)
  local fs, fail = uv.fs_scandir(filepath)
  if fail then
    vim.api.nvim_err_writeln(fail)
  end

  -- Load modules in the modpath, found in the file system
  local list = {}
  local name, fstype = uv.fs_scandir_next(fs)
  while name ~= nil do
    if fstype == "file" then
      local filename = name:match("(.+).lua")
      local pluginmod = fmt("%s.%s", modpath, filename)
      table.insert(list, pluginmod)
    end

    name, fstype = uv.fs_scandir_next(fs)
  end

  return list
end

edn.path = M

return M

local platform = require("eden.core.platform")
local home = os.getenv("HOME")

local M = {}

-- Join a list of paths together
-- @param ... string list
-- @return string
M.join = function(...)
  return table.concat({ ... }, platform.sep)
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

edn.path = M

return M

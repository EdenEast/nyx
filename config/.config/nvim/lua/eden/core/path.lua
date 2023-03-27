local platform = require("eden.core.platform")
local home = os.getenv("HOME")

local M = {}

M.seperator = package.config:sub(1, 1)

-- Join a list of paths together
-- @param ... string list
-- @return string
M.join = function(...) return table.concat({ ... }, M.seperator) end

-- Define default values for important path locations
M.home = home
M.confighome = M.join(home, ".config", "nvim")
M.datahome = M.join(home, ".local", "share", "nvim")
M.cachehome = M.join(home, ".cache", "nvim")
M.module_path = M.join(M.confighome, "lua", "eden", "mod")

-- Create a directory
-- @param dir string
M.create_dir = function(dir)
  local state = vim.loop.fs_stat(dir)
  if not state then vim.loop.fs_mkdir(dir, 511, function() assert("Failed to make path:" .. dir) end) end
end

-- Returns if the path exists on disk
-- @param p string
-- @return bool
M.exists = function(p)
  local state = vim.loop.fs_stat(p)
  return not (state == nil)
end

---Remove file from file system
---@param path string
M.remove_file = function(path) os.execute("rm " .. path) end

M.ensure = function(path)
  if not M.exists(path) then M.create_dir(path) end
end

M.read_file = function(path, mode)
  mode = mode or "*a"
  local file = io.open(path, "r")
  if file then
    local content = file:read(mode)
    file:close()
    return content
  end
end

M.write_file = function(path, content, mode)
  mode = mode or "w"
  local file = io.open(path, mode)
  if file then
    file:write(content)
    file:close()
  end
end

return M

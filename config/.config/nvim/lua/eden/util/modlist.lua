local Path = require("eden.core.path")
local fmt = string.format

local M = {}

local function get_filepath(modpath, runtimepath) return Path.join(runtimepath, unpack(vim.split(modpath, ".", true))) end

---Get all the module names in the file directory
---@param modpath string
---@param opts table?
---@return table
function M.getmodlist(modpath, opts)
  opts = opts or {}
  local runtimepath = Path.join(opts.runtimepath or Path.confighome, "lua")

  local function inner(mod, list)
    local filepath = get_filepath(mod, runtimepath)
    local fs, fail = vim.loop.fs_scandir(filepath)
    if fail then
      vim.api.nvim_err_write(fail)
      return {}
    end

    local name, fstype = vim.loop.fs_scandir_next(fs)
    while name ~= nil do
      if fstype == "file" then
        if name:sub(1, 1) ~= "_" then
          local filename = name:match("(.+).lua")
          local pluginmod = fmt("%s.%s", mod, filename)
          table.insert(list, pluginmod)
        end
      elseif opts.recurse then
        inner(fmt("%s.%s", mod, name), list)
      end
      name, fstype = vim.loop.fs_scandir_next(fs)
    end
  end

  local list = {}
  inner(modpath, list)

  return list
end

return M

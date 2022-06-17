local path = require("eden.core.path")
local fmt = string.format
local uv = vim.loop

local M = {}

local function get_filepath(modpath, runtimepath)
  return path.join(runtimepath, unpack(vim.split(modpath, ".", true)))
end

---Get all the module names in the file directory
---@param modpath string
---@param opts table
---@return table
function M.getmodlist(modpath, opts)
  opts = opts or {}
  local runtimepath = path.join(path.confighome, "lua")
  if opts.runtimepath then
    runtimepath = opts.runtimepath
  end

  local function inner(mod, list)
    local filepath = get_filepath(mod, runtimepath)
    local fs, fail = uv.fs_scandir(filepath)
    if fail then
      vim.api.nvim_err_write(fail)
      return {}
    end

    local name, fstype = uv.fs_scandir_next(fs)
    while name ~= nil do
      if fstype == "file" then
        local filename = name:match("(.+).lua")
        local pluginmod = fmt("%s.%s", mod, filename)
        table.insert(list, pluginmod)
      elseif opts.recurse then
        inner(fmt("%s.%s", mod, name), list)
      end
      name, fstype = uv.fs_scandir_next(fs)
    end
  end

  local list = {}
  inner(modpath, list)

  return list
end

return M

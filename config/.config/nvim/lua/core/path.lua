local global = require("core.global")
local util = require("core.util")

local path = {}

path.join = function(...)
  return table.concat({ ... }, global.pathsep)
end

path.create = function(p)
  local state = vim.loop.fs_stat(p)
  if not state then
    vim.loop.fs_mkdir(p, 511, function()
      assert("Failed to make path:" .. p)
    end)
  end
end

path.exists = function(p)
  local state = vim.loop.fs_stat(p)
  return not (state == nil)
end

local construct_runtimepath = function()
  local rtsplit = vim.split(vim.o.runtimepath, ",")
  local rtpath = {
    global.confighome,
    global.datahome,
  }
  local rtafter = {
    path.join(global.confighome, "after"),
    path.join(global.datahome, "after"),
  }

  for _, v in pairs(rtsplit) do
    if string.match(v, "[\\/]after$") then
      util.emplace(rtafter, v)
    else
      util.emplace(rtpath, v)
    end
  end

  return util.join(rtpath, ",") .. "," .. util.join(rtafter, ",")
end

-- Packpath
local construct_packpath = function()
  local psplit = vim.split(vim.o.packpath, ",")
  local ppath = {
    path.join(global.cachehome, "site"),
    path.join(global.datahome, "site"),
  }
  local pafter = {
    path.join(global.cachehome, "after", "site"),
    path.join(global.datahome, "after", "site"),
  }

  for _, v in pairs(psplit) do
    if string.match(v, "[\\/]after$") then
      util.emplace(pafter, v)
    else
      util.emplace(ppath, v)
    end
  end
  return util.join(ppath, ",") .. "," .. util.join(pafter, ",")
end

path.init = function()
  vim.o.runtimepath = construct_runtimepath()
  vim.o.packpath = construct_packpath()
end

return path

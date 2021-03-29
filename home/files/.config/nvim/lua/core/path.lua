local global = require('core.global')
local util = require('core.util')

local path = {}

path.join = function(tbl)
  return util.join(tbl, global.pathsep)
end

path.create = function(path)
	local state =  vim.loop.fs_stat(path)
	if not state then
    vim.loop.fs_mkdir(path, 511, function()
      assert('Failed to make path:' .. path)
    end)
	end
end

path.exists = function(path)
  local state =  vim.loop.fs_stat(path)
  return not (state == nil)
end

local emplace = function(tbl, value)
  local exists = false
  for _, v in ipairs(tbl) do
    if v == value then
      exists = true
      break
    end
  end

  if not exists then
    table.insert(tbl, value)
  end
end

local construct_runtimepath = function()
  local rtsplit = vim.split(vim.o.runtimepath, ',')
  local rtpath = {
    global.confighome,
    global.datahome
  }
  local rtafter = {
    path.join({ global.confighome, 'after' }),
    path.join({ global.datahome, 'after' })
  }

  for _, v in pairs(rtsplit) do
    if string.match(v, '[\\/]after$') then
      emplace(rtafter, v)
    else
      emplace(rtpath, v)
    end
  end

  return util.join(rtpath, ',') .. ',' .. util.join(rtafter, ',')
end


-- Packpath
local construct_packpath = function()
  local psplit = vim.split(vim.o.packpath, ',')
  local ppath = {
    path.join({ global.cachehome, 'site' }),
    path.join({ global.datahome, 'site' })
  }
  local pafter = {
    path.join({ global.cachehome, 'after', 'site' }),
    path.join({ global.datahome, 'after', 'site' })
  }

  for _, v in pairs(psplit) do
    if string.match(v, '[\\/]after$') then
      emplace(pafter, v)
    else
      emplace(ppath, v)
    end
  end
  return util.join(ppath, ',') .. ',' .. util.join(pafter, ',')
end

path.init = function()
  vim.o.runtimepath = construct_runtimepath()
  vim.o.packpath = construct_packpath()
end

return path


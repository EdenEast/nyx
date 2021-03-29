function join(tbl, delm)
  local result = tbl[1]
  for i, v in pairs(tbl) do
    if not (i == 1) then
      result = result .. delm .. v
    end
  end

  return result
end

function join_path(paths)
  return join(paths, G.pathsep)
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

-- Define main configuration paths
G.pathsep = G.is_windows and '\\' or '/'
G.home = os.getenv('HOME')
G.confighome = join_path({ G.home, '.config', 'nvim' })
G.datahome   = join_path({ G.home, '.local', 'share', 'nvim' })
G.cachehome  = join_path({ G.home, '.cache', 'nvim' })

local construct_runtimepath = function()
  print('constructing runtimepath')
  local rtsplit = vim.fn.split(vim.o.runtimepath, ',')
  local rtpath = {
    G.confighome,
    G.datahome
  }
  local rtafter = {
    join_path({ G.confighome, 'after' }),
    join_path({ G.datahome, 'after' })
  }

  for _, v in pairs(rtsplit) do
    if string.match(v, '[\\/]after$') then
      emplace(rtafter, v)
    else
      emplace(rtpath, v)
    end
  end

  return join(rtpath, ',') .. ',' .. join(rtafter, ',')
end


-- Packpath
local construct_packpath = function()
  local psplit = vim.fn.split(vim.o.packpath, ',')
  local ppath = {
    join_path({ G.cachehome, 'site' }),
    join_path({ G.datahome, 'site' })
  }
  local pafter = {
    join_path({ G.cachehome, 'after', 'site' }),
    join_path({ G.datahome, 'after', 'site' })
  }

  for _, v in pairs(psplit) do
    if string.match(v, '[\\/]after$') then
      emplace(pafter, v)
    else
      emplace(ppath, v)
    end
  end
  return join(ppath, ',') .. ',' .. join(pafter, ',')
end

local construct_paths = function()
  vim.o.runtimepath = construct_runtimepath()
  vim.o.packpath = construct_packpath()
end

construct_paths()

-- vim: sw=2 ts=2 sts=2 et

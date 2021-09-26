local M = {}

M.reload_module = function(module_name)
  local matcher = function(pack)
    return string.find(pack, module_name, 1, true)
  end

  -- Handle impatient.nvim automatically.
  local luacache = (_G.__luacache or {}).cache

  for pack, _ in pairs(package.loaded) do
    if matcher(pack) then
      package.loaded[pack] = nil

      if luacache then
        luacache[pack] = nil
      end
    end
  end
end

-- Reload all user config lua modules
M.reload_config = function()
  for name, _ in pairs(package.loaded) do
    if name:match("^eden.") then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
end

M.reload_config()

return M

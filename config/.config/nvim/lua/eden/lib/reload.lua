local M = {
  is_reloading = false,
}

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
  -- Handle impatient.nvim automatically.
  local luacache = (_G.__luacache or {}).cache

  local modlist = require("eden.lib.modlist").getmodlist("eden", { recurse = true })
  for _, name in ipairs(modlist) do
    if name ~= "eden.lib.reload" then
      package.loaded[name] = nil
      if luacache then
        luacache[name] = nil
      end
    end
  end

  M.is_reloading = true
  dofile(vim.env.MYVIMRC)
end

M.hook = function(f)
  if M.is_reloading then
    f()
  end
end

M.finish = function()
  if M.is_reloading then
    vim.notify("reload finished")
  end

  M.is_reloading = false
end

return M

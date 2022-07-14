-- Taken from https://github.com/doodleEsc/doodleVim/blob/be1b266/lua/doodleVim/utils/defer.lua
local M = {
  defer_packages = {},
  mod_plug_map = {},
}

local do_load = function()
  if not packer_plugins then
    return
  end

  table.sort(M.defer_packages, function(a, b)
    return a.priority > b.priority
  end)
  for _, item in pairs(M.defer_packages) do
    require("packer").loader(item.plugin)
  end
end

---Add plugin to be defer loaded. The order of loading is based on priority.
---Priority is from highest to lowest
---@param plugin any
---@param priority any
function M.add(plugin, priority)
  if not packer_plugins then
    return
  end
  local p = {
    priority = priority,
    plugin = plugin,
  }
  table.insert(M.defer_packages, p)
end

---Load any defered plugins after a delay
---@param delay any
function M.load(delay)
  if not packer_plugins then
    return
  end
  vim.defer_fn(do_load, delay)
end

---Defer loading of plugin by timer in ms
---@param plugin string
---@param timer number
function M.defer_load(plugin, timer)
  if not packer_plugins then
    return
  end
  if plugin then
    timer = timer or 0
    vim.defer_fn(function()
      require("packer").loader(plugin)
    end, timer)
  end
end

function M.immediate_load(plugins)
  if not packer_plugins then
    return
  end
  if type(plugins) == "string" then
    if not packer_plugins[plugins].loaded then
      require("packer").loader(plugins)
    end
  elseif type(plugins) == "table" then
    for _, value in pairs(plugins) do
      if not packer_plugins[value].loaded then
        require("packer").loader(value)
      end
    end
  end
end

---Register a plugin
---@param module string lua module name
---@param plugin string name of the folder
function M.register(module, plugin)
  if not M.mod_plug_map[module] then
    M.mod_plug_map[module] = plugin
  end
end

---Ensure that a registered plugin is loaded by packer
---@param module string
---@return unknown
function _G.ensure_require(module)
  if not packer_plugins then
    return nil
  end
  local ok, packer = pcall(require, "packer")
  if not ok then
    return nil
  end

  local major_mod = module:match("^([a-z0-9_-]+)%.?")
  if not M.mod_plug_map[major_mod] then
    -- no module and plugin registered
    return nil
  end

  local plugin = M.mod_plug_map[major_mod]
  if not packer_plugins[plugin].loaded then
    packer.loader(plugin)
  end

  local module_loaded_ok, module_loaded = pcall(require, module)
  if not module_loaded_ok then
    return nil
  end

  return module_loaded
end

return M

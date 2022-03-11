local path = require("eden.core.path")
local execute = vim.api.nvim_command
local err = vim.api.nvim_err_writeln
local fmt = string.format

local packer = nil
local ensured = {}

local M = {
  modlist = {},
  modname = "eden.modules",
  init = {
    package_root = path.packroot,
    compile_path = path.packer_compiled,
    git = { clone_timeout = 120 },
    max_jobs = 10,
  },
  local_plugins = path.join(path.home, "dev", "plugins"),
}

-- Ensure that a plugin is installed and execute a callback.
-- Returns if the plugin was cloned.
-- @param user string
-- @param repo string
-- @param cb function
-- @return bool
M.ensure = function(user, repo, cb)
  local install_path = path.join(path.packroot, "packer", "opt", repo)
  local installed = false
  if not path.exists(install_path) then
    execute(fmt("!git clone --depth=1 https://github.com/%s/%s %s", user, repo, install_path))
    installed = true
  end

  execute(fmt("packadd %s", repo))
  table.insert(ensured, fmt("%s/%s", user, repo))

  if cb ~= nil then
    cb()
  end

  return installed
end

-- Execute `PackerCompile` if file exists in `path.module_path`
M.auto_compile = function()
  M.clean()
  M.compile()
end

-- Check local development plugin location (pack.local_plugins)
-- if plugin exists. Returns abs path to local file if it exists.
-- @param slug string
-- @return string
M.dev = function(slug, as)
  local name = as and as or string.match(slug, ".*/(.*)")
  local abs = path.join(M.local_plugins, name)
  local exists = path.exists(abs)
  return exists and abs or slug
end

-- Load plugins from pack.modulename
M.load_plugins = function()
  if not packer then
    packer = require("packer")

    -- Pass some packer commands to the pack module
    local commands = { "install", "sync", "clean", "update", "use", "compile" }
    for _, cmd in ipairs(commands) do
      M[cmd] = packer[cmd]
    end
  end

  if M.modlist == nil then
    M.modlist = path.modlist(M.modname)
  end

  local list = {}
  for _, modname in ipairs(M.modlist) do
    local mod = require(modname)
    if mod.plugins then
      for _, plugin in ipairs(mod.plugins) do
        table.insert(list, plugin)
      end
    else
      err(fmt("plugin module: %s is required to return `plugins` property", modname))
    end
  end

  -- Add ensured plugins to packer
  for _, en in ipairs(ensured) do
    table.insert(list, { en, opt = true })
  end

  packer.init(M.init)
  packer.startup(function(use)
    for _, plugin in ipairs(list) do
      use(plugin)
    end
  end)
end

-- Trigger all plugin modules that contian an before() function
M.trigger_before = function()
  for _, modname in ipairs(M.modlist) do
    local mod = require(modname)
    if mod.before and type(mod.before) == "function" then
      mod.before()
    end
  end
end

-- Trigger all plugin modules that contian an after() function
M.trigger_after = function()
  for _, modname in ipairs(M.modlist) do
    local mod = require(modname)
    if mod.after and type(mod.after) == "function" then
      mod.after()
    end
  end
end

-- Bootstraping plugins.
-- Takes callback function that takes if packer was installed.
-- @param cb function(bool)
M.bootstrap = function(cb)
  -- Ensuring that impatient is installed and required before any plugins have been required
  -- Only required until pr is merged https://github.com/neovim/neovim/pull/15436
  M.ensure("lewis6991", "impatient.nvim", function()
    require("impatient")
  end)

  M.ensure("nathom", "filetype.nvim", function()
    vim.g.did_load_filetypes = 1
    require("filetype").setup({})
  end)

  -- Fill in modlist before the `before` trigger is well... triggered
  M.modlist = path.modlist(M.modname)

  local installed = M.ensure("wbthomason", "packer.nvim", function()
    M.trigger_before()
    M.load_plugins()
  end)

  if cb then
    cb(installed)
  end
end

return M

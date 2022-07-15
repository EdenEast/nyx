local path = require("eden.core.path")
local Lockfile = require("eden.core.lockfile")
local exec = vim.api.nvim_command
local fmt = string.format

local modname = "eden.modules"
local local_plugins = path.join(path.home, "dev", "plugins")

local function info(msg)
  vim.notify(msg, vim.log.levels.INFO, { title = "Pack" })
end

local function err(msg)
  vim.notify(msg, vim.log.levels.ERROR, { title = "Pack" })
end

local function dev(slug, as)
  local name = as and as or string.match(slug, ".*/(.*)")
  local abs = path.join(local_plugins, name)
  local exists = path.exists(abs)
  return exists and abs or slug
end

local handlers = {
  conf = function(_, plugin, value)
    if value:match("^eden.") then
      plugin.config = ([[require('%s')]]):format(value)
    else
      plugin.config = ([[require('eden.modules.%s')]]):format(value)
    end
  end,
}

local packer = nil
local Packer = {}
Packer.__index = Packer

function Packer:ensure(user, repo, callback)
  self.ensured = self.ensured or {}
  local install_path = path.join(path.packroot, "packer", "opt", repo)
  local installed = false

  if not path.exists(install_path) then
    exec(fmt("!git clone --depth=1 https://github.com/%s/%s %s", user, repo, install_path))
    installed = true
  end

  exec(fmt("packadd %s", repo))
  table.insert(self.ensured, fmt("%s/%s", user, repo))

  if callback ~= nil then
    callback()
  end

  return installed
end

function Packer:load_packer()
  if not packer then
    exec("packadd packer.nvim")
    packer = require("packer")
  end

  packer.init({
    package_root = path.packroot,
    compile_path = path.packer_compiled,
    git = { clone_timeout = 120 },
    max_jobs = 10,
    disable_commands = true,
  })
  packer.reset()
  packer.set_handler("conf", handlers.conf)

  self:load_plugins()
  local use = packer.use

  for _, e in ipairs(self.ensured) do
    use({ e, opt = true })
  end

  if Lockfile.should_apply then
    Lockfile:load()
    for _, repo in ipairs(self.repos) do
      use(Lockfile:apply(repo))
    end
  else
    for _, repo in ipairs(self.repos) do
      use(repo)
    end
  end
end

function Packer:load_plugins()
  self.repos = {}
  self.before_funcs = {}
  self.after_funcs = {}

  local plugin_files = require("eden.lib.modlist").getmodlist(modname, {})
  for _, m in ipairs(plugin_files) do
    local ok, mod = pcall(R, m)
    if not ok then
      err(mod)
    else
      if mod.plugins then
        for _, plugin in ipairs(mod.plugins) do
          if plugin.dev and not plugin.slug then
            local name = plugin[1]
            local local_path = dev(name, plugin.as)
            if local_path then
              plugin.slug = name
              plugin[1] = local_path
            end
          end
          table.insert(self.repos, plugin)
        end
      else
        err(fmt("plugin module: %s is required to return `plugins` property", m))
      end
      if mod.before then
        table.insert(self.before_funcs, mod.before)
      end
      if mod.after then
        table.insert(self.after_funcs, mod.after)
      end
    end
  end
end

function Packer:ensure_plugins()
  if Packer:ensure("wbthomason", "packer.nvim") then
    if path.exists(path.packer_compiled) then
      path.remove_file(path.packer_compiled)
    end

    -- Packer has been clonned and should install missing plugins
    self:load_packer()
    packer.install()
  else
    -- NOTE: Because we have plugins, before and after in the module files we require to require the modules
    -- even if we are just loading the compiled file. This might change in the futureso that the module files
    -- just define modules and before and after are handled differently.
    self:load_plugins()
  end
end

function Packer:trigger_before()
  for _, f in ipairs(self.before_funcs or {}) do
    f()
  end
end

function Packer:trigger_after()
  for _, f in ipairs(self.after_funcs or {}) do
    f()
  end
end

local M = setmetatable({}, {
  __index = function(_, key)
    if not packer then
      Packer:load_packer()
    end
    return packer[key]
  end,
})

M.modname = modname

-- Ensure that a plugin is installed and execute a callback.
-- Returns if the plugin was cloned.
-- @param user string
-- @param repo string
-- @param cb function
-- @return bool
function M.ensure(user, repo, callback)
  Packer:ensure(user, repo, callback)
end

-- Ensure plguins are installed
function M.ensure_plugins()
  Packer:ensure_plugins()
end

-- Load packer compiled file if exists. Also
function M.load_compile()
  if path.exists(path.packer_compiled) then
    local ok, errmsg = pcall(require, "eden.compiled")
    if not ok then
      err(errmsg)
    end
  end

  -- Compile after packer operations
  augroup("EdenPack", {
    {
      event = "User",
      pattern = "PackerComplete",
      exec = function()
        require("eden.core.pack").compile()
      end,
    },
  })

  ---Use lockfile to build packer cache to the desired hashes
  command("PackUpdate", function()
    Lockfile.should_apply = true
    require("eden.core.pack").sync()
  end)

  ---Update plugins to their latest versions and update lockfile
  command("PackUpgrade", function()
    Lockfile.should_apply = false
    require("eden.core.pack").sync()
    require("eden.core.pack").set_on_packer_complete(function()
      Lockfile.should_apply = true
      Lockfile:update()
    end)
  end)

  command("PackInstall", function()
    Lockfile.should_apply = true
    require("eden.core.pack").install()
    require("eden.core.pack").set_on_packer_complete(function()
      Lockfile:update()
    end)
  end)

  command("PackClean", function()
    Lockfile.should_apply = true
    require("eden.core.pack").clean()
    require("eden.core.pack").set_on_packer_complete(function()
      info("in clean after function")
      Lockfile:update()
    end)
  end)

  command("PackStatus", function()
    require("eden.core.path").status()
  end)

  command("PackProfile", function()
    require("eden.core.pack").compile("profile=true")
    require("eden.core.pack").set_on_packer_complete(function()
      require("eden.core.pack").profile_output()
    end, "PackerCompileDone")
  end)

  command("LockUpdate", function()
    require("eden.core.pack").lockfile_update()
  end)
end

function M.trigger_before()
  Packer:trigger_before()
end

function M.trigger_after()
  Packer:trigger_after()
end

function M.set_on_packer_complete(fn, pattern)
  augroup("EdenPackUpdate", {
    {
      event = "User",
      pattern = pattern or "PackerComplete",
      exec = function()
        require("eden.core.pack").on_packer_complete(fn)
      end,
    },
  })
end

function M.on_packer_complete(fn)
  vim.api.nvim_del_augroup_by_name("EdenPackUpdate")
  fn()
end

function M.lockfile_update()
  Lockfile:update()
end

return M

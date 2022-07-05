local path = require("eden.core.path")
local exec = vim.api.nvim_command
local err = require("eden.lib.err")
local fmt = string.format

local modname = "eden.modules"
local local_plugins = path.join(path.home, "dev", "plugins")
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
  if not self.repos then
    self:load_plugins()
  end
  local use = packer.use

  for _, e in ipairs(self.ensured) do
    use({ e, opt = true })
  end

  for _, repo in ipairs(self.repos) do
    use(repo)
  end
end

function Packer:load_plugins()
  self.repos = {}
  self.before_funcs = {}
  self.after_funcs = {}

  local plugin_files = require("eden.lib.modlist").getmodlist(modname, {})
  for _, m in ipairs(plugin_files) do
    local ok, mod = pcall(require, m)
    if not ok then
      err(mod)
    else
      if mod.plugins then
        for _, plugin in ipairs(mod.plugins) do
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
    -- Packer has been clonned and should install missing plugins
    self:load_packer()
    packer.install()
    -- else
    --   -- NOTE: Because we have plugins, before and after in the module file we require to require the modules
    --   -- even if we are just loading the compiled file. This might change in the futureso that the module files
    --   -- just define modules and before and after are handled differently.
    --   self:load_plugins()
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

-- Check local development plugin location (pack.local_plugins)
-- if plugin exists. Returns abs path to local file if it exists.
-- @param slug string
-- @return string
function M.dev(slug, as)
  local name = as and as or string.match(slug, ".*/(.*)")
  local abs = path.join(local_plugins, name)
  local exists = path.exists(abs)
  return exists and abs or slug
end

-- Ensure that a plugin is installed and execute a callback.
-- Returns if the plugin was cloned.
-- @param user string
-- @param repo string
-- @param cb function
-- @return bool
function M.ensure(user, repo, callback)
  Packer:ensure(user, repo, callback)
end

function M.ensure_plugins()
  Packer:ensure_plugins()
end

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

  vim.cmd([[command! -nargs=* PackerCompile  lua require('eden.core.pack').compile(<q-args>)]])

  command("PackerClean", function()
    require("eden.core.pack").clean()
  end)
  command("PackerInstall", function()
    require("eden.core.pack").install()
  end)
  command("PackerStatus", function()
    require("eden.core.pack").status()
  end)
  command("PackerSync", function()
    require("eden.core.pack").sync()
  end)
  command("PackerUpdate", function()
    require("eden.core.pack").update()
  end)
  command("PackerProfile", function()
    require("eden.core.pack").profile_output()
  end)
end

function M.trigger_before()
  Packer:trigger_before()
end

function M.trigger_after()
  Packer:trigger_after()
end

return M

local platform = require("eden.core.platform")
local path = require("eden.core.path")
local exec = vim.api.nvim_command
local fmt = string.format

local modname = "eden.modules"
local opt_keys = { "after", "cmd", "ft", "keys", "event", "cond", "setup", "fn", "module", "module_pattern" }
local local_plugins = path.join(path.home, "dev", "plugins")
local lockfile_path = path.join(path.confighome, "lua", "eden", "lockfile.lua")

local function info(msg)
  vim.notify(msg, vim.log.levels.INFO, { title = "Pack" })
end

local function warn(msg)
  vim.notify(msg, vim.log.levels.WARN, { title = "Pack" })
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

local function get_packpath_filelist()
  local paths = {}
  local function get_name_and_path(spec)
    local spec_path = vim.fn.expand(spec[1])
    local name_segments = vim.split(spec_path, platform.sep)
    local segment_idx = #name_segments
    local name = spec.as or name_segments[segment_idx]
    while name == "" and segment_idx > 0 do
      name = name_segments[segment_idx]
      segment_idx = segment_idx - 1
    end
    return name, spec.slug and spec.slug or spec_path
  end

  local function inner(spec)
    local spec_type = type(spec)
    if spec_type == "string" then
      spec = { spec }
    elseif spec_type == "table" and #spec > 1 then
      for _, sp in ipairs(spec) do
        inner(sp)
      end
      return
    end

    for _, key in ipairs(opt_keys) do
      if spec[key] ~= nil then
        spec.opt = true
      end
    end

    local name, spec_path = get_name_and_path(spec)
    local folder = spec.opt and "opt" or "start"
    if not spec.disable then
      if paths[spec_path] then
        -- If we have already saved this path and it was optional but the current one is not
        -- then the `start` path takes priority
        if paths[spec_path].opt and not spec.opt then
          paths[spec_path] = {
            path = path.join(path.packroot, "packer", folder, name),
            opt = spec.opt or false,
          }
        end
      else
        paths[spec_path] = {
          path = path.join(path.packroot, "packer", folder, name),
          opt = spec.opt or false,
        }
      end
    end

    if spec.requires then
      if type(spec.requires) == "string" then
        spec.requires = { spec.requires }
      end

      for _, req in ipairs(spec.requires) do
        if type(req) == "string" then
          req = { req }
        end

        if spec.opt then -- transitive_opt
          req.opt = true
        end

        inner(req)
      end
    end
  end

  local plugin_files = require("eden.lib.modlist").getmodlist(modname, {})
  for _, m in ipairs(plugin_files) do
    local plugins = require(m).plugins
    for _, plugin in ipairs(plugins) do
      inner(plugin)
    end
  end

  return paths
end

local Lockfile = {
  should_apply = true,
}
Lockfile.__index = Lockfile

function Lockfile:load()
  local ok, lf = pcall(R, "eden.lockfile")
  self.data = ok and lf or {}
end

function Lockfile:apply(spec)
  if spec.tag then
    return spec
  end

  local name = spec[1]
  if not spec.slug and self.data[name] then
    spec.commit = self.data[name]
  end

  if spec.requires then
    local reqs = {}
    if type(spec.requires) == "string" then
      spec.requires = { spec.requires }
    end
    for _, req in ipairs(spec.requires) do
      table.insert(reqs, self:apply(req))
    end
    spec.requires = reqs
  end

  return spec
end

function Lockfile:update()
  local Job = require("plenary.job")
  local lines = {}
  local pack_files = get_packpath_filelist()
  for name, pack_spec in pairs(pack_files) do
    if not path.exists(pack_spec.path) then
      warn(fmt("%s does not exist: %s", name, pack_spec.path))
    else
      local result, code = Job:new({ command = "git", args = { "rev-parse", "HEAD" }, cwd = pack_spec.path }):sync()
      if code == 0 and result then
        table.insert(lines, fmt([[  ["%s"] = "%s",]], name, result[1]))
      else
        err(fmt("Failed %s: %s", code, result))
      end
    end
  end

  table.sort(lines)

  table.insert(lines, 1, "return {")
  table.insert(lines, "}")
  table.insert(lines, "")

  local file = io.open(lockfile_path, "w")
  file:write(table.concat(lines, "\n"))
  file:close()
  info("Lockfile written")
end

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
          if plugin.dev then
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
    -- Packer has been clonned and should install missing plugins
    self:load_packer()
    packer.install()
  else
    -- NOTE: Because we have plugins, before and after in the module file we require to require the modules
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
  command("PackerUpdate", function()
    require("eden.core.pack").update()
  end)
  command("PackerProfile", function()
    require("eden.core.pack").compile("profile=true")
    require("eden.core.pack").profile_output()
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

function M.update()
  Lockfile.should_apply = false
  Packer:load_packer()
  packer.update()

  augroup("EdenPackUpdate", {
    {
      event = "User",
      pattern = "PackerComplete",
      exec = function()
        require("eden.core.pack").update_complete()
      end,
    },
  })
end

function M.update_complete()
  vim.api.nvim_del_augroup_by_name("EdenPackUpdate")
  Lockfile.should_apply = true
  Lockfile:update()
end

function M.lockfile_update()
  Lockfile:update()
end

return M

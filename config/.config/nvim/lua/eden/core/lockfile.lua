local platform = require("eden.core.platform")
local path = require("eden.core.path")
local fmt = string.format

local modname = "eden.modules"
local opt_keys = { "after", "cmd", "ft", "keys", "event", "cond", "setup", "fn", "module", "module_pattern" }

local function info(msg)
  vim.notify(msg, vim.log.levels.INFO, { title = "Lockfile" })
end

local function warn(msg)
  vim.notify(msg, vim.log.levels.WARN, { title = "Lockfile" })
end

local function err(msg)
  vim.notify(msg, vim.log.levels.ERROR, { title = "Lockfile" })
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
    -- slug might be required as Packer:load_pluings() chnges the name if dev is true
    -- To the local filepath if it exists. If spec contains a slug then use that
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
        break
      end
    end

    local name, spec_path = get_name_and_path(spec)
    local folder = spec.opt and "opt" or "start"
    if not spec.disable then
      -- Non `opt` (`start`) takes priority
      if not paths[spec_path] or paths[spec_path].opt and not spec.opt then
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

        -- transitive_opt
        if spec.opt then
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
  path = path.join(path.confighome, "lua", "eden", "lockfile.lua"),
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

  local file, errmsg = io.open(self.path, "w")
  if not file then
    err(errmsg)
    return
  end

  file:write(table.concat(lines, "\n"))
  file:close()
  info("Lockfile written")
end

return Lockfile

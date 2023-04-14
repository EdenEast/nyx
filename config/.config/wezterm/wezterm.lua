local wt = require("wezterm")

local is_windows = wt.target_triple:match("windows") ~= nil
local is_macos = wt.target_triple:match("darwin") ~= nil

-- Utility functions -----------------------------------------------------------

-- Join list of arguments into a path separated by the correct path seperator
local function join(...)
  local sep = is_windows and [[\]] or "/"
  return table.concat({ ... }, sep)
end

-- Check if file exists
local function exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

-- Load and execute file and return the resulting table
local function load_file(name)
  return exists(name) and dofile(name) or {}
end

-- Extend a table with anohter table
local function extend(...)
  local ret = {}
  for i = 1, select("#", ...) do
    local tbl = select(i, ...)
    if tbl then
      for k, v in pairs(tbl) do
        ret[k] = v
      end
    end
  end
  return ret
end

-- Paths / Config files --------------------------------------------------------

local home = wt.home_dir
local confighome = wt.config_dir
local datahome = join(home, ".local", "share", "wezterm")
local cachehome = join(home, ".cache", "nyx")

local nyx_file = join(datahome, "nyx.lua")
local nyx_config = load_file(nyx_file)

local local_file = join(datahome, "config.lua")
local local_config = load_file(local_file)

local theme_file = join(cachehome, "theme", "name")

-- Setting extra config files to the reload watch list
wt.add_to_config_reload_watch_list(nyx_file)
wt.add_to_config_reload_watch_list(local_file)
wt.add_to_config_reload_watch_list(theme_file)

-- Events ----------------------------------------------------------------------

local window_opacity = 0.8

wt.on("toggle-opacity", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = window_opacity
  else
    overrides.window_background_opacity = nil
  end
  window:set_config_overrides(overrides)
end)

wt.on("increase-opacity", function(window, pane)
  window_opacity = window_opacity + 0.05
  local overrides = window:get_config_overrides() or {}
  if overrides.window_background_opacity then
    overrides.window_background_opacity = window_opacity
    window:set_config_overrides(overrides)
  end
end)

wt.on("decrease-opacity", function(window, pane)
  window_opacity = window_opacity - 0.05
  local overrides = window:get_config_overrides() or {}
  if overrides.window_background_opacity then
    overrides.window_background_opacity = window_opacity
    window:set_config_overrides(overrides)
  end
end)

-- Config table ---------------------------------------------------------------

local config = {
  audible_bell = "Disabled", -- No beeping plz
  check_for_updates = false,

  color_scheme_dirs = {
    join(confighome, "colors"),
    join(datahome, "colors"),
  },

  color_scheme = "nightfox",

  exit_behavior = "Close",

  font = wt.font_with_fallback({
    "JetBrains Mono",
    "Hack Nerd Font Mono",
    "UbuntuMono NF",
  }),

  hide_tab_bar_if_only_one_tab = true,

  keys = {
    { key = "\\", mods = "ALT", action = "ShowLauncher" },
    { key = "t", mods = "CTRL|ALT", action = wt.action.EmitEvent("toggle-opacity") },
    { key = "t", mods = "SUPER|ALT", action = wt.action.EmitEvent("toggle-opacity") },
    { key = "=", mods = "CTRL|ALT", action = wt.action.EmitEvent("increase-opacity") },
    { key = "=", mods = "SUPER|ALT", action = wt.action.EmitEvent("increase-opacity") },
    { key = "-", mods = "CTRL|ALT", action = wt.action.EmitEvent("decrease-opacity") },
    { key = "-", mods = "SUPER|ALT", action = wt.action.EmitEvent("decrease-opacity") },
  },

  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
}

-- Windows ---------------------------------------------------------------------

local function windows_launch_menu()
  local launch_menu = { {
    label = "Powershell",
    args = { "powershell.exe", "-NoLogo" },
  } }

  local success, wsl_list, wsl_err = wt.run_child_process({ "wsl.exe", "-l" })

  -- `wsl.exe -l` has a bug where it always outputs utf16:
  -- https://github.com/microsoft/WSL/issues/4607
  -- So we get to convert it
  wsl_list = wt.utf16_to_utf8(wsl_list)

  for idx, line in ipairs(wt.split_by_newlines(wsl_list)) do
    -- The first line is a heading
    if idx > 1 then
      local distro = line:gsub(" %(Default%)", "")
      if not distro:find("^docker") then
        table.insert(launch_menu, {
          label = distro,
          args = { "wsl.exe", "--distribution", distro },
        })
      end
    end
  end

  return launch_menu
end

if is_windows then
  config.launch_menu = windows_launch_menu()
  config.default_prog = { "wsl.exe" }
end

-- If the theme file exists use that name instead
if exists(theme_file) then
  local file = io.open(theme_file, "r")
  local name = file:read()
  if name then
    config.color_scheme = file:read()
  end
  file:close()
end

local result = extend(config, nyx_config, local_config)

return result

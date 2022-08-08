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

local config = {
  audible_bell = "Disabled", -- No beeping plz
  check_for_updates = false,

  color_scheme_dirs = {
    join(confighome, "colors"),
    join(datahome, "colors"),
  },

  -- Default colorscheme is nightfox
  colors = {
    background = "#192330",
    foreground = "#cdcecf",

    cursor_border = "#cdcecf",
    cursor_bg = "#cdcecf",
    cursor_fg = "#192330",

    selection_bg = "#223249",
    selection_fg = "#cdcecf",
    ansi = { "#393b44", "#c94f6d", "#81b29a", "#dbc074", "#719cd6", "#9d79d6", "#63cdcf", "#dfdfe0" },
    brights = { "#575860", "#d16983", "#8ebaa4", "#e0c989", "#86abdc", "#baa1e2", "#7ad4d6", "#e4e4e5" },
  },

  exit_behavior = "Close",

  font = wt.font_with_fallback({
    "JetBrains Mono",
    "Hack Nerd Font Mono",
    "UbuntuMono NF",
  }),

  hide_tab_bar_if_only_one_tab = true,

  keys = {
    { key = "\\", mods = "ALT", action = "ShowLauncher" },
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

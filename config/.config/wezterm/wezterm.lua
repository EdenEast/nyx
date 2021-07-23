local wt = require("wezterm")

local function windows_launch_menu()
  local launch_menu = { {
    label = "Powershell",
    args = { "powershell.exe", "--NoLogo" },
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

local config = {
  colors = {
    background = "#192330",
    foreground = "#afc0d5",

    cursor_border = "#7f8c98",
    cursor_bg = "#7f8c98",
    cursor_fg = "#afc0d5",

    selection_bg = "#283648",
    selection_fg = "#CDCECF",

    ansi = { "#393b44", "#c94f6d", "#81b29a", "#dbc074", "#719cd6", "#9d79d6", "#63cdcf", "#dfdfe0" },
    brights = { "#7f8c98", "#d6616b", "#58cd8b", "#ffe37e", "#84cee4", "#b8a1e3", "#59f0ff", "#f2f2f2" },
  },

  font = wt.font_with_fallback({
    "Hack Nerd Font Mono",
    "UbuntuMono NF",
    "JetBrains Mono",
  }),

  hide_tab_bar_if_only_one_tab = true,

  keys = {
    { key = "\\", mods = "ALT", action = "ShowLauncher" },
  },

  window_padding = {
    left = 5,
    right = 5,
    bottom = 5,
  },
}

-- Windows --------------------------------------------------------------------

if wt.target_triple == "x86_64-pc-windows-msvc" then
  config.launch_menu = windows_launch_menu()
  config.default_prog = { "wsl.exe" }
end

return config

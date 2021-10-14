local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

-- inherit default theme
local theme = dofile(themes_path .. "default/theme.lua")

theme.font = "Hack Nerd Font Mono 10"
theme.icon_font = "Hack Nerd Font Mono 10"

-- stylua: ignore
theme.colors = {
  black   = "#393b44",
  red     = "#c94f6d",
  green   = "#81B29A",
  yellow  = "#dbc074",
  blue    = "#719cd6",
  magenta = "#9D79D6",
  cyan    = "#63cdcf",
  white   = "#dfdfe0",
  orange  = "#F4A261",
  pink    = "#D67AD2",
}

-- stylua: ignore
theme.bright = {
  black_br   = "#475072",
  red_br     = "#D6616B",
  green_br   = "#58cd8b",
  yellow_br  = "#FFE37E",
  blue_br    = "#84CEE4",
  magenta_br = "#B8A1E3",
  cyan_br    = "#59F0FF",
  white_br   = "#F2F2F2",
  orange_br  = "#F6A878",
  pink_br    = "#DF97DB",
}

theme.bg_normal = "#192330"
theme.bg_alt = "#131A24"
theme.bg_focus = "#283648" -- this night be the one
theme.bg_urgent = theme.colors.red
theme.bg_minimize = theme.colors.orange
theme.bg_systray = theme.bg_alt

theme.fg_normal = "#CDCECF"
theme.fg_focus = theme.bg_normal
theme.fg_urgent = theme.bg_normal
theme.fg_minimize = theme.bg_normal

theme.useless_gap = dpi(3)
theme.border_width = dpi(2)
theme.border_normal = "#123456"
theme.border_focus = theme.bg_focus
theme.border_marked = theme.colors.magenta

theme.tooltip_fg = theme.fg_normal
theme.tooltip_bg = theme.bg_normal

theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_height = dpi(16)
theme.menu_width = dpi(100)

-- Recolor Layout icons:
theme = theme_assets.recolor_layout(theme, theme.fg_normal)

-- Recolor titlebar icons:
--
local function darker(color_value, darker_n)
  local result = "#"
  for s in color_value:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
    local bg_numeric_value = tonumber("0x" .. s) - darker_n
    if bg_numeric_value < 0 then
      bg_numeric_value = 0
    end
    if bg_numeric_value > 255 then
      bg_numeric_value = 255
    end
    result = result .. string.format("%2.2x", bg_numeric_value)
  end
  return result
end
theme = theme_assets.recolor_titlebar(theme, theme.fg_normal, "normal")
theme = theme_assets.recolor_titlebar(theme, darker(theme.fg_normal, -60), "normal", "hover")
theme = theme_assets.recolor_titlebar(theme, xrdb.color1, "normal", "press")
theme = theme_assets.recolor_titlebar(theme, theme.fg_focus, "focus")
theme = theme_assets.recolor_titlebar(theme, darker(theme.fg_focus, -60), "focus", "hover")
theme = theme_assets.recolor_titlebar(theme, xrdb.color1, "focus", "press")

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Try to determine if we are running light or dark colorscheme:
local bg_numberic_value = 0
for s in theme.bg_normal:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
  bg_numberic_value = bg_numberic_value + tonumber("0x" .. s)
end
local is_dark_bg = (bg_numberic_value < 383)

-- Generate wallpaper:
local wallpaper_bg = xrdb.color8
local wallpaper_fg = xrdb.color7
local wallpaper_alt_fg = xrdb.color12
if not is_dark_bg then
  wallpaper_bg, wallpaper_fg = wallpaper_fg, wallpaper_bg
end
theme.wallpaper = function(s)
  return theme_assets.wallpaper(wallpaper_bg, wallpaper_fg, wallpaper_alt_fg, s)
end

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80

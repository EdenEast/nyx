local awful = require("awful")
local gears = require("gears")
local apps = require("configuration.apps")
local bling = require("modules.bling.layout")

local beautiful = require("beautiful")
local machi = require("modules.layout-machi")
beautiful.layout_machi = machi.get_icon()

local tags = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  bling.centered,
  machi.default_layout,
  awful.layout.suit.floating,
  -- awful.layout.suit.tile.left,
  -- awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  -- awful.layout.suit.fair,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
  -- bling.mstab
  -- bling.vertical
  -- bling.horizontal
  -- bling.equalarea
}

-- Configure Tag Properties
awful.screen.connect_for_each_screen(function(s)
  -- Each screen has its own tag table.
  for i, _ in ipairs(tags) do
    awful.tag.add(i, {
      layout = awful.layout.layouts[1],
      gap_single_client = false,
      gap = beautiful.useless_gap,
      screen = s,
      selected = i == 1,
    })
  end
end)
-- }}}

local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local mods = require("configuration.keys.mod")
local mod, alt, shft, ctrl = mods.mod, mods.alt, mods.shft, mods.ctrl

local helpers = require("helpers")

local client = gears.table.join(
  -- Move focused client by direction (hjkl)
  awful.key({ mod, shft }, "h", function(c)
    helpers.move_client_dwim(c, "left")
  end, {
    description = "move left",
    group = "",
  }),
  awful.key({ mod, shft }, "j", function(c)
    helpers.move_client_dwim(c, "down")
  end, {
    description = "move down",
    group = "",
  }),
  awful.key({ mod, shft }, "k", function(c)
    helpers.move_client_dwim(c, "up")
  end, {
    description = "move up",
    group = "",
  }),
  awful.key({ mod, shft }, "l", function(c)
    helpers.move_client_dwim(c, "right")
  end, {
    description = "move right",
    group = "",
  }),

  -- Move focused client by direction (arrows)
  awful.key({ mod, shft }, "Left", function(c)
    helpers.move_client_dwim(c, "left")
  end, {
    description = "move left",
    group = "",
  }),
  awful.key({ mod, shft }, "Down", function(c)
    helpers.move_client_dwim(c, "down")
  end, {
    description = "move down",
    group = "",
  }),
  awful.key({ mod, shft }, "Up", function(c)
    helpers.move_client_dwim(c, "up")
  end, {
    description = "move up",
    group = "",
  }),
  awful.key({ mod, shft }, "Down", function(c)
    helpers.move_client_dwim(c, "right")
  end, {
    description = "move right",
    group = "",
  }),

  -- Relative move floating windows (hjkl)
  awful.key({ mod, shft, ctrl }, "h", function(c)
    c:relative_move(dpi(-20), 0, 0, 0)
  end, {
    description = "move left",
    group = "",
  }),
  awful.key({ mod, shft, ctrl }, "j", function(c)
    c:relative_move(0, dpi(20), 0, 0)
  end, {
    description = "move down",
    group = "",
  }),
  awful.key({ mod, shft, ctrl }, "k", function(c)
    c:relative_move(0, dpi(-20), 0, 0)
  end, {
    description = "move up",
    group = "",
  }),
  awful.key({ mod, shft, ctrl }, "l", function(c)
    c:relative_move(dpi(20), 0, 0, 0)
  end, {
    description = "move right",
    group = "",
  }),

  -- Relative move floating windows (arrows)
  awful.key({ mod, shft, ctrl }, "Left", function(c)
    c:relative_move(dpi(-20), 0, 0, 0)
  end, {
    description = "move left",
    group = "",
  }),
  awful.key({ mod, shft, ctrl }, "Down", function(c)
    c:relative_move(0, dpi(20), 0, 0)
  end, {
    description = "move down",
    group = "",
  }),
  awful.key({ mod, shft, ctrl }, "Up", function(c)
    c:relative_move(0, dpi(-20), 0, 0)
  end, {
    description = "move up",
    group = "",
  }),
  awful.key({ mod, shft, ctrl }, "Right", function(c)
    c:relative_move(dpi(20), 0, 0, 0)
  end, {
    description = "move right",
    group = "",
  }),

  -- Close client
  awful.key({ mod }, "BackSpace", function(c)
    c:kill()
  end, { description = "close", group = "" }),
  awful.key({ mod, shft }, "q", function(c)
    c:kill()
  end, { description = "close", group = "" }),
  awful.key({ alt }, "F4", function(c)
    c:kill()
  end, { description = "close", group = "" }),

  -- Fullscreen client
  awful.key({ mod }, "f", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, {
    description = "toggle fullscreen",
    group = "",
  }),

  -- Toggle titlebar
  awful.key({ mod }, "t", function(c)
    -- TODO: resize the window
    awful.titlebar.toggle(c, beautiful.titlebar_position)
  end, {
    description = "toggle titlebar",
    group = "",
  }),
  -- Toggle titlebar for all visible clients in selected tag
  awful.key({ mod, shft }, "t", function(c)
    local clients = awful.screen.focused().clients
    for _, c in pairs(clients) do
      awful.titlebar.toggle(c, beautiful.titlebar_position)
    end
  end, {
    description = "toggle titlebar",
    group = "",
  }),

  -- Single tap: Center client
  -- Double tap: Center client + Floating + Resize
  awful.key({ mod }, "c", function(c)
    awful.placement.centered(c, { hornor_workarea = true, hornor_padding = true })
    helpers.single_double_tap(nil, function()
      width = awful.screen.focused().geometry.width
      height = awful.screen.focused().geometry.height
      helpers.float_and_resize(c, width * 0.65, height * 0.9)
    end)
  end, {
    description = "center client",
    group = "",
  }),

  -- Minimize client
  awful.key({ mod }, "n", function(c)
    c.minimized = true
  end, { description = "minimize", group = "" }),

  -- Maximize client
  awful.key({ mod }, "m", function(c)
    c.maximized = not c.maximized
    c:raise()
  end, {
    description = "toggle maximized",
    group = "",
  }),
  awful.key({ mod, ctrl }, "m", function(c)
    c.maximized_vertical = not c.maximized_vertical
    c:raise()
  end, {
    description = "toggle maximize vertically",
    group = "",
  }),
  awful.key({ mod, shft }, "m", function(c)
    c.maximized_horizontal = not c.maximized_horizontal
    c:raise()
  end, {
    description = "toggle maximize horizontally",
    group = "",
  }),

  -- Pin/sticky client
  -- Pin: keep on top
  -- Sticky: keep on all tags
  awful.key({ mod, shft }, "p", function(c)
    c.ontop = not c.ontop
  end, { description = "pin client", group = "" }),
  awful.key({ mod, ctrl }, "p", function(c)
    c.sticky = not c.sticky
  end, {
    description = "sticky client",
    group = "",
  })
)

return client

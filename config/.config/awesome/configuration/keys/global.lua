local awful = require("awful")
local gears = require("gears")
local bling = require("modules.bling.layout")
local machi = require("modules.layout-machi")

local mods = require("configuration.keys.mod")
local mod, alt, shft, ctrl = mods.mod, mods.alt, mods.shft, mods.ctrl

local apps = require("configuration.apps")
local helpers = require("helpers")

require("awful.autofocus")
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- Todo:
--  - Move screens (mod + alt)?
--  - Move clients to different screens (mod + shift + alt)?

local global = gears.table.join(
  -- Movement -----------------------------------------------------------------
  -- Note: Movement of focused client is on in the client keys

  -- Move Focus with (hjkl)
  awful.key({ mod }, "h", function()
    helpers.move_focus(client.focus, "left")
  end, {
    description = "focus left",
    group = "",
  }),
  awful.key({ mod }, "j", function()
    helpers.move_focus(client.focus, "down")
  end, {
    description = "focus down",
    group = "",
  }),
  awful.key({ mod }, "k", function()
    helpers.move_focus(client.focus, "up")
  end, {
    description = "focus up",
    group = "",
  }),
  awful.key({ mod }, "l", function()
    helpers.move_focus(client.focus, "right")
  end, {
    description = "focus right",
    group = "",
  }),

  -- Move Focus with (arrows) useful when using colemak
  awful.key({ mod }, "Left", function()
    helpers.move_focus("left")
  end, { description = "focus left", group = "" }),
  awful.key({ mod }, "Down", function()
    helpers.move_focus("down")
  end, { description = "focus down", group = "" }),
  awful.key({ mod }, "Up", function()
    helpers.move_focus("up")
  end, { description = "focus up", group = "" }),
  awful.key({ mod }, "Right", function()
    helpers.move_focus("right")
  end, {
    description = "focus right",
    group = "",
  }),

  -- Resize focused client or layout factor (hjkl)
  awful.key({ mod, ctrl }, "h", function()
    helpers.resize_dwim(client.focus, "left")
  end, {
    description = "resize left",
    group = "",
  }),
  awful.key({ mod, ctrl }, "j", function()
    helpers.resize_dwim(client.focus, "down")
  end, {
    description = "resize down",
    group = "",
  }),
  awful.key({ mod, ctrl }, "k", function()
    helpers.resize_dwim(client.focus, "up")
  end, {
    description = "resize up",
    group = "",
  }),
  awful.key({ mod, ctrl }, "l", function()
    helpers.resize_dwim(client.focus, "right")
  end, {
    description = "resize right",
    group = "",
  }),

  -- Resize focused client or layout factor (arrows)
  awful.key({ mod, ctrl }, "Left", function()
    helpers.resize_dwim(client.focus, "left")
  end, {
    description = "resize left",
    group = "",
  }),
  awful.key({ mod, ctrl }, "Down", function()
    helpers.resize_dwim(client.focus, "down")
  end, {
    description = "resize down",
    group = "",
  }),
  awful.key({ mod, ctrl }, "Up", function()
    helpers.resize_dwim(client.focus, "up")
  end, {
    description = "resize up",
    group = "",
  }),
  awful.key({ mod, ctrl }, "Right", function()
    helpers.resize_dwim(client.focus, "right")
  end, {
    description = "resize right",
    group = "",
  }),

  -- Awesome ------------------------------------------------------------------
  -- Restart awesome
  awful.key({ mod, ctrl }, "r", awesome.restart, { description = "restart awesome", group = "" }),

  -- Quit awesome
  -- TODO: change this to use an exit screen
  awful.key({ mod, shft }, "x", function()
    awesome.quit()
  end, { description = "quit awesome", group = "" }),
  -- awful.key({}, 'XF86PowerOff',
  --   function() awesome.quit()  end,
  --   { description = 'quit awesome', group = '' }
  -- ),
  awful.key({ mod, alt }, "BackSpace", function()
    local clients = awful.screen.focused().clients
    for _, c in pairs(clients) do
      c:kill()
    end
  end, {
    description = "kill all visible clients for current screen",
    group = "",
  }),

  -- Launchers
  awful.key({ mod }, "Return", function()
    awful.spawn(apps.terminal)
  end, {
    description = "launch terminal",
    group = "launcher",
  }),
  awful.key({ mod, shft }, "Return", function()
    awful.spawn("rofi -show combi")
  end, {
    description = "launch terminal",
    group = "launcher",
  }),
  awful.key({ mod }, "space", function()
    local sp = require("modules.scratchpad")
    sp:toggle()
  end, {
    description = "launch terminal",
    group = "launcher",
  }),

  awful.key({ mod, shft }, "minus", function()
    awful.tag.incgap(3, nil)
  end, {
    description = "increase gaps for current tag",
    group = "launcher",
  }),
  awful.key({ mod }, "minus", function()
    awful.tag.incgap(-3, nil)
  end, {
    description = "decrease gaps for current tag",
    group = "launcher",
  }),

  awful.key({ mod }, "p", function()
    awful.util.spawn_with_shell("sleep 0.5 && scrot -s")
  end, {
    description = "take screenshot",
    group = "launcher",
  }),

  -- Layouts

  -- Centered layout
  -- Single tap: Set centered layout
  -- double tap: Also disable floating for all visible clients in the tag
  awful.key({ mod }, "w", function()
    awful.layout.set(bling.centered)
    helpers.single_double_tap(nil, function()
      local clients = awful.screen.focused().clients
      for _, c in pairs(clients) do
        c.floating = false
      end
    end)
  end, {
    description = "set centered layout",
    group = "layout",
  }),

  -- Max layout
  -- Single tap: Set max layout
  -- double tap: Also disable floating for all visible clients in the tag
  awful.key({ mod, shft }, "w", function()
    awful.layout.set(awful.layout.suit.max)
    helpers.single_double_tap(nil, function()
      local clients = awful.screen.focused().clients
      for _, c in pairs(clients) do
        c.floating = false
      end
    end)
  end, {
    description = "set max layout",
    group = "layout",
  }),

  -- Tiling
  -- Single tap: Set tiling layout
  -- double tap: Also disable floating for all visible clients in the tag
  awful.key({ mod }, "s", function()
    awful.layout.set(awful.layout.suit.tile)
    helpers.single_double_tap(nil, function()
      local clients = awful.screen.focused().clients
      for _, c in pairs(clients) do
        c.floating = false
      end
    end)
  end, {
    description = "set tile layout",
    group = "layout",
  }),

  -- Machi
  -- Single tap: Set machi layout
  -- double tap: Also disable floating for all visible clients in the tag
  awful.key({ mod }, "e", function()
    awful.layout.set(machi.default_layout)
    helpers.single_double_tap(nil, function()
      local clients = awful.screen.focused().clients
      for _, c in pairs(clients) do
        c.floating = false
      end
    end)
  end, {
    description = "set tile layout",
    group = "layout",
  }),

  -- Floating
  awful.key({ mod, shft }, "s", function()
    awful.layout.set(awful.layout.suit.floating)
  end, {
    description = "set floating layout",
    group = "layout",
  }),

  -- Restore minimized
  awful.key({ mod, shft }, "n", function()
    local c = awful.client.restore()
    if c then
      client.focus = c
    end
  end, {
    description = "restore minimized",
    group = "layout",
  }),

  -- Machi
  awful.key({ mod }, ".", function()
    machi.default_editor.start_interactive()
  end, {
    description = "edit current layout machi",
    group = "layout",
  }),
  awful.key({ mod }, "/", function()
    machi.switcher.start(client.focus)
  end, {
    description = "switch between windows machi",
    group = "layout",
  }),

  -- Jumps
  awful.key({ mod }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "" }),

  -- XF86
  -------------------------------------------------------

  -- Volume and mic
  awful.key({}, "XF86AudioRaiseVolume", function()
    awful.spawn.with_shell("pamixer -i 3")
  end, {}),
  awful.key({}, "XF86AudioLowerVolume", function()
    awful.spawn.with_shell("pamixer -d 3")
  end, {}),
  awful.key({}, "XF86AudioMute", function()
    awful.spawn.with_shell("pamixer -t")
  end, {}),
  -- TODO:
  -- awful.key({}, "XF86AudioRecord", function()
  --   awful.spawn.with_shell('~/.script/wm/soundctl forward')
  -- end, {}),
  -- awful.key({}, "XF86AudioMicMute", function()
  --   awful.spawn.with_shell("")
  -- end, {}),

  -- Media
  -- TODO:
  -- awful.key({}, "XF86AudioMedia", function()
  --   awful.spawn.with_shell('~/.script/wm/soundctl forward')
  -- end, {}),
  awful.key({}, "XF86AudioPlay", function()
    awful.spawn.with_shell("playerctl play-pause")
  end, {}),
  awful.key({}, "XF86AudioStop", function()
    awful.spawn.with_shell("playerctl stop")
  end, {}),
  awful.key({}, "XF86AudioNext", function()
    awful.spawn.with_shell("playerctl next")
  end, {}),
  awful.key({}, "XF86AudioPrev", function()
    awful.spawn.with_shell("playerctl previous")
  end, {}),
  awful.key({}, "XF86AudioForward", function()
    awful.spawn.with_shell("~/.script/wm/soundctl forward")
  end, {}),
  awful.key({}, "XF86AudioRewind", function()
    awful.spawn.with_shell("~/.script/wm/soundctl backward")
  end, {}),

  -- Display
  awful.key({}, "XF86Display", function()
    awful.spawn.with_shell("arandr")
  end, {}),
  awful.key({}, "XF86MonBrightnessUp", function()
    awful.spawn.with_shell("brightnessctl s +5%")
  end, {}),
  awful.key({}, "XF86MonBrightnessDown", function()
    awful.spawn.with_shell("brightnessctl s 5%-")
  end, {}),

  -- Power
  awful.key({}, "XF86PowerOff", function()
    awful.spawn.with_shell("~/.scripts/lockscreen.sh")
  end, {}),
  awful.key({}, "XF86Reload", awesome.restart, {}),
  awful.key({}, "XF86ScreenSaver", function() end, {}),
  awful.key({}, "XF86Sleep", function()
    awful.spawn.with_shell("~/.scripts/lockscreen.sh")
  end, {}),
  awful.key({}, "XF86Suspend", function()
    awful.spawn.with_shell("~/.scripts/lockscreen.sh")
  end, {})

  -- awful.key({}, "XF86Close", function() end, {}),
  -- awful.key({}, "XF86Explorer", function() end, {}),
  -- awful.key({}, "XF86HomePage", function() end, {}),
  -- awful.key({}, "XF86KbdBrightnessDown", function() end, {}),
  -- awful.key({}, "XF86KbdBrightnessUp", function() end, {}),
  -- awful.key({}, "XF86KbdLightOnOff", function() end, {}),
  -- awful.key({}, "XF86MyComputer", function() end, {}),
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
local ntags = 10
for i = 1, ntags do
  global = gears.table.join(
    global,
    -- View tag only.
    awful.key({ mod }, "#" .. i + 9, function()
      -- Tag back and forth
      helpers.tag_back_and_forth(i)

      -- Simple tag view
      -- local tag = mouse.screen.tags[i]
      -- if tag then
      -- tag:view_only()
      -- end
    end, {
      description = "view tag #" .. i,
      group = "tag",
    }),
    -- Toggle tag display.
    awful.key({ mod, ctrl }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end, {
      description = "toggle tag #" .. i,
      group = "tag",
    }),

    -- Move client to tag.
    awful.key({ mod, shft }, "#" .. i + 9, function()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end, {
      description = "move focused client to tag #" .. i,
      group = "tag",
    }),

    -- Move all visible clients to tag and focus that tag
    awful.key({ mod, alt }, "#" .. i + 9, function()
      local tag = client.focus.screen.tags[i]
      local clients = awful.screen.focused().clients
      if tag then
        for _, c in pairs(clients) do
          c:move_to_tag(tag)
        end
        tag:view_only()
      end
    end, {
      description = "move all visible clients to tag #" .. i,
      group = "tag",
    }),
    -- Toggle tag on focused client.
    awful.key({ mod, ctrl, shft }, "#" .. i + 9, function()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end, {
      description = "toggle focused client on tag #" .. i,
      group = "tag",
    })
  )
end

return global

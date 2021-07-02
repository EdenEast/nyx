local awful = require('awful')
local gears = require('gears')
local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi

local helpers = require('helpers')
local decorations = require('decorations')

local keys = {}

local mod  = "Mod4"
local alt  = "Mod1"
local ctrl = "Control"
local shft = "Shift"

-- Todo:
--  - Move screens (mod + alt)?
--  - Move clients to different screens (mod + shift + alt)?

keys.global = gears.table.join(
  -- Movement -----------------------------------------------------------------
  -- Note: Movement of focused client is on in the client keys

  -- Move Focus with (hjkl)
  awful.key({ mod }, 'h',
    function() helpers.move_focus(client.focus, 'left') end,
    { description = 'focus left', group = '' }
  ),
  awful.key({ mod }, 'j',
    function() helpers.move_focus(client.focus, 'down') end,
    { description = 'focus down', group = '' }
  ),
  awful.key({ mod }, 'k',
    function() helpers.move_focus(client.focus, 'up') end,
    { description = 'focus up', group = '' }
  ),
  awful.key({ mod }, 'l',
    function() helpers.move_focus(client.focus, 'right') end,
    { description = 'focus right', group = '' }
  ),

  -- Move Focus with (arrows) useful when using colemak
  awful.key({ mod }, 'Left',
    function() helpers.move_focus('left') end,
    { description = 'focus left', group = '' }
  ),
  awful.key({ mod }, 'Down',
    function() helpers.move_focus('down') end,
    { description = 'focus down', group = '' }
  ),
  awful.key({ mod }, 'Up',
    function() helpers.move_focus('up') end,
    { description = 'focus up', group = '' }
  ),
  awful.key({ mod }, 'Right',
    function() helpers.move_focus('right') end,
    { description = 'focus right', group = '' }
  ),

  -- Resize focused client or layout factor (hjkl)
  awful.key({ mod, ctrl }, 'h',
    function() helpers.resize_dwim(client.focus, 'left') end,
    { description = 'resize left' , group = '' }
  ),
  awful.key({ mod, ctrl }, 'j',
    function() helpers.resize_dwim(client.focus, 'down') end,
    { description = 'resize down' , group = '' }
  ),
  awful.key({ mod, ctrl }, 'k',
    function() helpers.resize_dwim(client.focus, 'up') end,
    { description = 'resize up' , group = '' }
  ),
  awful.key({ mod, ctrl }, 'l',
    function() helpers.resize_dwim(client.focus, 'right') end,
    { description = 'resize right' , group = '' }
  ),

  -- Resize focused client or layout factor (arrows)
  awful.key({ mod, ctrl }, 'Left',
    function() helpers.resize_dwim(client.focus, 'left') end,
    { description = 'resize left' , group = '' }
  ),
  awful.key({ mod, ctrl }, 'Down',
    function() helpers.resize_dwim(client.focus, 'down') end,
    { description = 'resize down' , group = '' }
  ),
  awful.key({ mod, ctrl }, 'Up',
    function() helpers.resize_dwim(client.focus, 'up') end,
    { description = 'resize up' , group = '' }
  ),
  awful.key({ mod, ctrl }, 'Right',
    function() helpers.resize_dwim(client.focus, 'right') end,
    { description = 'resize right' , group = '' }
  ),

  -- Awesome ------------------------------------------------------------------
  -- Restart awesome
  awful.key({ mod, ctrl }, 'r',
    awesome.restart,
    { description = 'restart awesome', group = '' }
  ),

  -- Quit awesome
  -- TODO: change this to use an exit screen
  awful.key({ mod, shft }, 'x',
    function() awesome.quit()  end,
    { description = 'quit awesome', group = '' }
  ),
  -- awful.key({}, 'XF86PowerOff',
  --   function() awesome.quit()  end,
  --   { description = 'quit awesome', group = '' }
  -- ),
  awful.key({ mod, alt }, 'BackSpace',
    function()
      local clients = awful.screen.focused().clients
      for _, c in pairs(clients) do
        c:kill()
      end
    end, { description = 'kill all visible clients for current screen', group = '' }
  ),

  -- Launchers
  awful.key({ mod }, 'Return',
    function() awful.spawn(user.terminal) end,
    { description = 'launch terminal' , group = 'launcher' }
  ),
  -- TODO: scratchpad

  awful.key({ mod, shft }, 'minus',
    function()
      awful.tag.incgap(3, nil)
    end, { description = 'increase gaps for current tag' , group = 'launcher' }
  ),
  awful.key({ mod }, 'minus',
    function()
      awful.tag.incgap(-3, nil)
    end, { description = 'decrease gaps for current tag' , group = 'launcher' }
  ),

  -- Layouts

  -- Max layout
  -- Single tap: Set max layout
  -- double tap: Also disable floating for all visible clients in the tag
  awful.key({ mod }, 'w',
    function()
      awful.layout.set(awful.layout.suit.max)
      helpers.single_double_tap(
        nil,
        function()
          local clients = awful.screen.focused().clients
          for _, c in pairs(clients) do
            c.floating = false
          end
        end
      )
    end, { description = 'set max layout' , group = 'launcher' }
  ),

  -- Tiling
  -- Single tap: Set tiling layout
  -- double tap: Also disable floating for all visible clients in the tag
  awful.key({ mod }, 's',
    function()
      awful.layout.set(awful.layout.suit.tile)
      helpers.single_double_tap(
        nil,
        function()
          local clients = awful.screen.focused().clients
          for _, c in pairs(clients) do
            c.floating = false
          end
        end
      )
    end, { description = 'set tile layout' , group = 'launcher' }
  ),

  -- Floating
  awful.key({ mod, shft }, 's',
    function()
      awful.layout.set(awful.layout.suit.floating)
    end, { description = 'set floating layout' , group = 'launcher' }
  ),

  -- Restore minimized
  awful.key({ mod, shft }, 'n',
    function()
      local c = awful.client.restore()
      if c then
        client.focus = c
      end
    end, { description = 'restore minimized' , group = '' }
  )
)

keys.client = gears.table.join(
  -- Move focused client by direction (hjkl)
  awful.key({ mod, shft }, 'h',
    function(c) helpers.move_client_dwim(c, 'left') end,
    { description = 'move left' , group = '' }
  ),
  awful.key({ mod, shft }, 'j',
    function(c) helpers.move_client_dwim(c, 'down') end,
    { description = 'move down' , group = '' }
  ),
  awful.key({ mod, shft }, 'k',
    function(c) helpers.move_client_dwim(c, 'up') end,
    { description = 'move up' , group = '' }
  ),
  awful.key({ mod, shft }, 'l',
    function(c) helpers.move_client_dwim(c, 'right') end,
    { description = 'move right' , group = '' }
  ),

  -- Move focused client by direction (arrows)
  awful.key({ mod, shft }, 'Left',
    function(c) helpers.move_client_dwim(c, 'left') end,
    { description = 'move left' , group = '' }
  ),
  awful.key({ mod, shft }, 'Down',
    function(c) helpers.move_client_dwim(c, 'down') end,
    { description = 'move down' , group = '' }
  ),
  awful.key({ mod, shft }, 'Up',
    function(c) helpers.move_client_dwim(c, 'up') end,
    { description = 'move up' , group = '' }
  ),
  awful.key({ mod, shft }, 'Down',
    function(c) helpers.move_client_dwim(c, 'right') end,
    { description = 'move right' , group = '' }
  ),

  -- Relative move floating windows (hjkl)
  awful.key({ mod, shft, ctrl }, 'h',
    function(c) c:relative_move(dpi(-20), 0, 0, 0) end,
    { description = 'move left' , group = '' }
  ),
  awful.key({ mod, shft, ctrl }, 'j',
    function(c) c:relative_move(0 , dpi(20), 0, 0) end,
    { description = 'move down' , group = '' }
  ),
  awful.key({ mod, shft, ctrl }, 'k',
    function(c) c:relative_move(0 , dpi(-20), 0, 0) end,
    { description = 'move up' , group = '' }
  ),
  awful.key({ mod, shft, ctrl }, 'l',
    function(c) c:relative_move(dpi(20), 0, 0, 0) end,
    { description = 'move right' , group = '' }
  ),

  -- Relative move floating windows (arrows)
  awful.key({ mod, shft, ctrl }, 'Left',
    function(c) c:relative_move(dpi(-20), 0, 0, 0) end,
    { description = 'move left' , group = '' }
  ),
  awful.key({ mod, shft, ctrl }, 'Down',
    function(c) c:relative_move(0 , dpi(20), 0, 0) end,
    { description = 'move down' , group = '' }
  ),
  awful.key({ mod, shft, ctrl }, 'Up',
    function(c) c:relative_move(0 , dpi(-20), 0, 0) end,
    { description = 'move up' , group = '' }
  ),
  awful.key({ mod, shft, ctrl }, 'Right',
    function(c) c:relative_move(dpi(20), 0, 0, 0) end,
    { description = 'move right' , group = '' }
  ),

  -- Close client
  awful.key({ mod }, 'BackSpace',
    function(c) c:kill() end,
    { description = 'close' , group = '' }
  ),
  awful.key({ alt }, 'F4',
    function(c) c:kill() end,
    { description = 'close' , group = '' }
  ),

  -- Fullscreen client
  awful.key({ mod }, 'f',
    function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end, { description = 'toggle fullscreen' , group = '' }
  ),

  -- Toggle titlebar
  awful.key({ mod }, 't',
    function(c)
      decorations.cycle(c)
    end, { description = 'toggle titlebar' , group = '' }
  ),
  -- Toggle titlebar for all visible clients in selected tag
  awful.key({ mod, shft }, 't',
    function(c)
      local clients = awful.screen.focused().clients
      for _, c in pairs(clients) do
        decorations.cycle(c)
      end
    end, { description = 'toggle titlebar' , group = '' }
  ),

  -- Single tap: Center client
  -- Double tap: Center client + Floating + Resize
  awful.key({ mod }, 'c',
    function(c)
      awful.placement.centered(c, {hornor_workarea = true, hornor_padding = true})
      helpers.single_double_tap(
        nil,
        function()
          width = awful.screen.focused().geometry.width;
          height = awful.screen.focused().geometry.height;
          helpers.float_and_resize(c, width * 0.65, height * 0.9)
        end
      )
    end,
    { description = 'center client' , group = '' }
  ),

  -- Minimize client
  awful.key({ mod }, 'n',
    function(c)
      c.minimized = true;
    end, { description = 'minimize' , group = '' }
  ),

  -- Maximize client
  awful.key({ mod }, 'm',
    function(c)
      c.maximized = not c.maximized
      c:raise()
    end, { description = 'toggle maximized' , group = '' }
  ),
  awful.key({ mod, ctrl }, 'm',
    function(c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end, { description = 'toggle maximize vertically' , group = '' }
  ),
  awful.key({ mod, shft }, 'm',
    function(c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end, { description = 'toggle maximize horizontally' , group = '' }
  ),

  -- Pin/sticky client
  -- Pin: keep on top
  -- Sticky: keep on all tags
  awful.key({ mod, shft }, 'p',
    function(c)
      c.ontop = not c.ontop
    end, { description = 'pin client' , group = '' }
  ),
  awful.key({ mod, ctrl }, 'p',
    function(c)
      c.sticky = not c.sticky
    end, { description = 'sticky client' , group = '' }
  )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
local ntags = 10
for i = 1, ntags do
  keys.global = gears.table.join(keys.global,
    -- View tag only.
    awful.key({ mod }, "#" .. i + 9,
      function ()
        -- Tag back and forth
        helpers.tag_back_and_forth(i)

        -- Simple tag view
        -- local tag = mouse.screen.tags[i]
        -- if tag then
        -- tag:view_only()
        -- end
      end,
      {description = "view tag #"..i, group = "tag"}
    ),
    -- Toggle tag display.
    awful.key({ mod, ctrl }, "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      {description = "toggle tag #" .. i, group = "tag"}
    ),

    -- Move client to tag.
    awful.key({ mod, shft }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      {description = "move focused client to tag #"..i, group = "tag"}
    ),

    -- Move all visible clients to tag and focus that tag
    awful.key({ mod, alt }, "#" .. i + 9,
      function ()
        local tag = client.focus.screen.tags[i]
        local clients = awful.screen.focused().clients
        if tag then
          for _, c in pairs(clients) do
            c:move_to_tag(tag)
          end
          tag:view_only()
        end
      end,
      {description = "move all visible clients to tag #"..i, group = "tag"}
    ),
    -- Toggle tag on focused client.
    awful.key({ mod, ctrl, shft }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      {description = "toggle focused client on tag #" .. i, group = "tag"}
    )
  )
end

return keys

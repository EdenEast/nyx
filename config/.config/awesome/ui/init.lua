local awful = require("awful")
local top_panel = require("ui.top-panel")

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
  -- You can get edit/rid of this conditional if you want certain bars on specific screens or all screens etc.
  if s.index == 1 then
    s.top_panel = top_panel(s)
  end
end)

-- Hide bars when app go fullscreen
function updateBarsVisibility()
  for s in screen do
    if s.selected_tag then
      local fullscreen = s.selected_tag.fullscreenMode

      -- These are the bars that are hidden when on any fullscreen mode (The awesomewm fullscreen mode and app fullscren modes like youtube)
      -- If you want bars to be invisible when you fullscreen an app, you can do so like so :
      s.top_panel.visible = not fullscreen

      -- If you want bars to be visible even when you fullscreen an app, you can do it like so :
      -- s.top_panel.visible = visible

      -- I'm sure you can figure out other things you can do here
    end
  end
end

_G.tag.connect_signal("property::selected", function(t)
  updateBarsVisibility()
end)

_G.client.connect_signal("property::fullscreen", function(c)
  c.screen.selected_tag.fullscreenMode = c.fullscreen
  updateBarsVisibility()
end)

_G.client.connect_signal("unmanage", function(c)
  if c.fullscreen then
    c.screen.selected_tag.fullscreenMode = false
    updateBarsVisibility()
  end
end)

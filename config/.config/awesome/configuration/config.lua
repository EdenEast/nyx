local dpi = require("beautiful.xresources").apply_dpi
local awful = require("awful")

-- vw/vh are used when you want certain elements to scale nicely/the same on all monitors/resolutions.
-- 1 vw unit = Relative to 1% of the width of the screen it is targetting
-- 1 vh unit = Relative to 1% of the height of the screen it is targetting
awful.screen.connect_for_each_screen(function(s)
  function vw(width)
    vw = (s.geometry.width / 100) * width
    return vw
  end

  function vh(height)
    vw = (s.geometry.height / 100) * height
    return vw
  end
end)

-- You can store common configuration variables here, or completely get rid of this file.
local configuration = {

  -- Width of the top panel
  toppanel_height = dpi(20),
}

return configuration

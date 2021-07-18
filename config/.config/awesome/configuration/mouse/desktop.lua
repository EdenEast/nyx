local gears = require("gears")
local awful = require("awful")
require("ui.widgets.mainmenu")

-- Mousebindings that occur on the desktop
desktopMouse = gears.table.join(
  awful.button({}, 1, function()
    mymainmenu:hide()
  end),
  awful.button({}, 3, function()
    mymainmenu:toggle()
  end),

  -- This is the mousewheel on the unfocused desktop
  awful.button({}, 4, awful.tag.viewnext),
  awful.button({}, 5, awful.tag.viewprev)
)

return desktopMouse

-- {{{ Mouse bindings
-- root.buttons(gears.table.join(
--                awful.button({ }, 3, function () mymainmenu:toggle() end),

--                -- This is the mousewheel on the unfocused desktop
--                awful.button({ }, 4, awful.tag.viewnext),
--                awful.button({ }, 5, awful.tag.viewprev)
-- ))
-- }}}

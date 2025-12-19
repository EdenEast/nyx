local awful = require("awful")
local beautiful = require("beautiful")
require("ui.widgets.mainmenu")

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

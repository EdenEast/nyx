local awful = require("awful")

-- Create a promptbox for each screen
awful.screen.connect_for_each_screen(function(s)
  s.mymenubox = menubar
end)

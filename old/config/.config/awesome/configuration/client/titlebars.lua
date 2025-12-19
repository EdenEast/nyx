local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

-- Double click titlebar timer, how long it takes for a 2 clicks to be considered a double click
function double_click_event_handler(double_click_event)
  if double_click_timer then
    double_click_timer:stop()
    double_click_timer = nil
    return true
  end

  double_click_timer = gears.timer.start_new(0.20, function()
    double_click_timer = nil
    return false
  end)
end

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- original buttons for the titlebar, if you'd rather not have to double click functionality
  -- local buttons = gears.table.join(
  --     awful.button({ }, 1, function()
  --         c:emit_signal("request::activate", "titlebar", {raise = true})
  --         awful.mouse.client.move(c)
  --     end),
  --     awful.button({ }, 3, function()
  --         c:emit_signal("request::activate", "titlebar", {raise = true})
  --         awful.mouse.client.resize(c)
  --     end)
  -- )

  -- new buttons for the titlebar, this allows you to double click and toggle maximization of client
  local buttons = awful.util.table.join(
    buttons,
    awful.button({}, 1, function()
      c:emit_signal("request::activate", "titlebar", { raise = true })
      -- WILL EXECUTE THIS ON DOUBLE CLICK
      if double_click_event_handler() then
        c.maximized = not c.maximized
        c:raise()
      else
        awful.mouse.client.move(c)
      end
    end),
    awful.button({}, 3, function()
      c:emit_signal("request::activate", "titlebar", { raise = true })
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c):setup({
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout = wibox.layout.fixed.horizontal,
    },
    { -- Middle
      { -- Title
        align = "center",
        widget = awful.titlebar.widget.titlewidget(c),
      },
      buttons = buttons,
      layout = wibox.layout.flex.horizontal,
    },
    { -- Right
      awful.titlebar.widget.floatingbutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton(c),
      awful.titlebar.widget.ontopbutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal(),
    },
    layout = wibox.layout.align.horizontal,
  })
end)

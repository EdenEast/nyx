local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local gfs = require("gears.filesystem")
local dpi = beautiful.xresources.apply_dpi
local fmt = string.format

-- acpi sample outputs
-- Battery 0: Discharging, 75%, 01:51:38 remaining
-- Battery 0: Charging, 53%, 00:57:43 until charged

local battery_widget = {}
local function worker(user_args)
  local args = user_args or {}

  local font = args.font or beautiful.icon_font
  local show_current_level = args.show_current_level or true
  local margin_left = args.margin_left or 0
  local margin_right = args.margin_right or 0

  local display_notification = args.display_notification or false
  local display_notification_onClick = args.display_notification_onClick or true
  local position = args.notification_position or "top_right"
  local timeout = args.timeout or 10

  local warning_msg_title = args.warning_msg_title or "Huston, we have a problem"
  local warning_msg_text = args.warning_msg_text or "Battery is dying"
  local warning_msg_position = args.warning_msg_position or "bottom_right"
  local enable_battery_warning = args.enable_battery_warning
  if enable_battery_warning == nil then
    enable_battery_warning = true
  end

  local icon_widget = wibox.widget({
    font = font,
    widget = wibox.widget.textbox,
  })

  local level_widget = wibox.widget({
    font = font,
    widget = wibox.widget.textbox,
  })

  battery_widget = wibox.widget({
    icon_widget,
    level_widget,
    layout = wibox.layout.fixed.horizontal,
  })

  -- Popup with battery info
  -- One way of creating a pop-up notification - naughty.notify
  local notification
  local function show_battery_status(batteryType)
    awful.spawn.easy_async([[bash -c 'acpi']], function(stdout, _, _, _)
      naughty.destroy(notification)
      notification = naughty.notify({
        text = stdout,
        title = "Battery status",
        icon = path_to_icons .. batteryType .. ".svg",
        icon_size = dpi(16),
        position = position,
        timeout = 5,
        hover_timeout = 0.5,
        width = 200,
        screen = mouse.screen,
      })
    end)
  end

  -- Alternative to naughty.notify - tooltip. You can compare both and choose the preferred one
  --battery_popup = awful.tooltip({objects = {battery_widget}})

  -- To use colors from beautiful theme put
  -- following lines in rc.lua before require("battery"):
  -- beautiful.tooltip_fg = beautiful.fg_normal
  -- beautiful.tooltip_bg = beautiful.bg_normal

  local function show_battery_warning()
    naughty.notify({
      icon = warning_msg_icon,
      icon_size = 100,
      text = warning_msg_text,
      title = warning_msg_title,
      timeout = 25, -- show the warning for a longer time
      hover_timeout = 0.5,
      position = warning_msg_position,
      bg = "#F06060",
      fg = "#EEE9EF",
      width = 300,
      screen = mouse.screen,
    })
  end
  local last_battery_check = os.time()
  local battery_icon = ""
  local batteryType = "battery-good-symbolic"

  watch("acpi -i", timeout, function(widget, stdout)
    local battery_info = {}
    local capacities = {}
    for s in stdout:gmatch("[^\r\n]+") do
      local status, charge_str, _ = string.match(s, ".+: (%a+), (%d?%d?%d)%%,?(.*)")
      if status ~= nil then
        table.insert(battery_info, { status = status, charge = tonumber(charge_str) })
      else
        local cap_str = string.match(s, ".+:.+last full capacity (%d+)")
        table.insert(capacities, tonumber(cap_str))
      end
    end

    local capacity = 0
    for _, cap in ipairs(capacities) do
      capacity = capacity + cap
    end

    local charge = 0
    local status
    for i, batt in ipairs(battery_info) do
      if capacities[i] ~= nil then
        if batt.charge >= charge then
          status = batt.status -- use most charged battery status
          -- this is arbitrary, and maybe another metric should be used
        end

        charge = charge + batt.charge * capacities[i]
      end
    end
    charge = charge / capacity

    if show_current_level then
      level_widget.text = string.format(" %d%%", charge)
    end

    local function is_in_range(value, min, max)
      return value >= min and value < max
    end
    if status == "Charging" then
      battery_icon = ""
    else
      if is_in_range(charge, 0, 15) then
        battery_icon = ""
        if enable_battery_warning and status ~= "Charging" and os.difftime(os.time(), last_battery_check) > 300 then
          -- if 5 minutes have elapsed since the last warning
          last_battery_check = os.time()

          show_battery_warning()
        end
      elseif is_in_range(charge, 15, 30) then
        battery_icon = ""
      elseif is_in_range(charge, 30, 40) then
        battery_icon = ""
      elseif is_in_range(charge, 40, 50) then
        battery_icon = ""
      elseif is_in_range(charge, 50, 60) then
        battery_icon = ""
      elseif is_in_range(charge, 60, 70) then
        battery_icon = ""
      elseif is_in_range(charge, 70, 80) then
        battery_icon = ""
      elseif is_in_range(charge, 80, 90) then
        battery_icon = ""
      else
        battery_icon = ""
      end
    end

    icon_widget.text = battery_icon
    -- widget.icon:set_image(path_to_icons .. batteryType .. ".svg")

    -- Update popup text
    -- battery_popup.text = string.gsub(stdout, "\n$", "")
  end, icon_widget)

  if display_notification then
    battery_widget:connect_signal("mouse::enter", function()
      show_battery_status(batteryType)
    end)
    battery_widget:connect_signal("mouse::leave", function()
      naughty.destroy(notification)
    end)
  elseif display_notification_onClick then
    battery_widget:connect_signal("button::press", function(_, _, _, button)
      if button == 3 then
        show_battery_status(batteryType)
      end
    end)
    battery_widget:connect_signal("mouse::leave", function()
      naughty.destroy(notification)
    end)
  end

  return wibox.container.margin(battery_widget, margin_left, margin_right)
end

return setmetatable(battery_widget, {
  __call = function(_, ...)
    return worker(...)
  end,
})

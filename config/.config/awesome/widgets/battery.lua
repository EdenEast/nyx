local baticon = wibox.widget.textbox(
  string.format('<span color="%s" font="'..theme.icon_font..'"></span>', theme.clr.blue)
)

local bat = wibox.widget.textbox('')
theme.update_battery = function()
  awful.spawn.easy_async_with_shell(
  [[echo $(acpi|awk '{split($0,a,", "); print a[2]}')]],
  function(stdout)
    if stdout == '' then
      bat:set_markup('<span color="'..theme.clr.blue..'" font="'..theme.widget_font..'"> N/A</span>')
    else
      bat:set_markup('<span color="'..theme.clr.blue..'" font="'..theme.widget_font..'"> ' ..stdout.."%</span> ")
    end
  end)
end
theme.update_battery()

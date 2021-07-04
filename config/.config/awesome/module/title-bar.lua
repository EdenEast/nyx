local awful = require('awful')
local wibox = require('wibox')

-- create the titlebar when the client is connected
client.connect_signal('request::titlebars',
    function(c)
        awful.titlebar(c) : setup {
            { -- left
                awful.titlebar.widget.iconwidget(c),
                layout  = wibox.layout.fixed.horizontal
            },
            { -- middle
                { -- Title
                    align  = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                layout  = wibox.layout.flex.horizontal
            },
            { -- right
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }

        local l = awful.layout.get(c.screen)
        if not (l.name == 'floating' or c.floating) then
            awful.titlebar.hide(c)
        end
    end
)

client.connect_signal('property::floating',
    function(c)
        if c.floating then
            awful.titlebar.show(c)
        else
            awful.titlebar.hide(c)
        end
    end
)

awful.tag.attached_connect_signal(s, 'property::layout',
    function(t)
        local float = t.layout.name == 'floating'
        for _,c in pairs(t:clients()) do
            c.floating = float
        end
    end
)

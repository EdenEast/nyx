local awful = require('awful')
local beautiful = require('beautiful')

local decorations = {}

-- >> Default decoration management functions
-- They make sure not to affect custom decorations added on the same position
-- as the default titlebar
-- Can be overrided by the selected decoration theme when the titlebar
-- configuration is more complex
function decorations.hide(c)
    if not c.custom_decoration or not c.custom_decoration[beautiful.titlebar_position] then
        awful.titlebar.hide(c, beautiful.titlebar_position)
    end
end

function decorations.show(c)
    if not c.custom_decoration or not c.custom_decoration[beautiful.titlebar_position] then
        awful.titlebar.show(c, beautiful.titlebar_position)
    end
end

-- We use `cycle` instead of `toggle` since some decoration themes may provide
-- the ability to change between different types of titlebars (e.g. full,
-- minimal, none)
function decorations.cycle(c)
    if not c.custom_decoration or not c.custom_decoration[beautiful.titlebar_position] then
        awful.titlebar.toggle(c, beautiful.titlebar_position)
    end
end

return decorations

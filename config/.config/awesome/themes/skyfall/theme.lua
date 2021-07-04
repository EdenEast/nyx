local themename = 'skyfall'
local homedir = os.getenv('HOME')
local xresources = require('beautiful.xresources')
local xrdb = xresources.get_current_theme()
local dpi = xresources.apply_dpi

local theme = {}

local awful = require('awful')
local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

-- theme.dir = homedir .. '/.config/awesome/themes/' .. themename
-- theme.wallpaper = theme.dir .. '/wallpaper.png'
theme.dir = homedir .. '/.local/etc/'
theme.wallpaper = theme.dir .. '/wall.png'

theme.font = 'monospace 11'

-- theme.xbackground = '#282f37'
-- theme.xforground  = '#f1fcf9'
-- theme.xcolor0     = '#20262c'
-- theme.xcolor1     = '#db86ba'
-- theme.xcolor2     = '#74dd91'
-- theme.xcolor3     = '#e49186'
-- theme.xcolor4     = '#75dbe1'
-- theme.xcolor5     = '#b4a1db'
-- theme.xcolor6     = '#9ee9ea'
-- theme.xcolor7     = '#f1fcf9'
-- theme.xcolor8     = '#465463'
-- theme.xcolor9     = '#d04e9d'
-- theme.xcolor10    = '#4bc66d'
-- theme.xcolor11    = '#db695b'
-- theme.xcolor12    = '#3dbac2'
-- theme.xcolor13    = '#825ece'
-- theme.xcolor14    = '#62cdcd'
-- theme.xcolor15    = '#e0e5e5'

theme.xbackground = xrdb.background or '#282f37'
theme.xforground  = xrdb.forground  or '#f1fcf9'
theme.xcolor0     = xrdb.color0     or '#20262c'
theme.xcolor1     = xrdb.color1     or '#db86ba'
theme.xcolor2     = xrdb.color2     or '#74dd91'
theme.xcolor3     = xrdb.color3     or '#e49186'
theme.xcolor4     = xrdb.color4     or '#75dbe1'
theme.xcolor5     = xrdb.color5     or '#b4a1db'
theme.xcolor6     = xrdb.color6     or '#9ee9ea'
theme.xcolor7     = xrdb.color7     or '#f1fvf9'
theme.xcolor8     = xrdb.color8     or '#465463'
theme.xcolor9     = xrdb.color9     or '#d04e9d'
theme.xcolor10    = xrdb.color1     or '#4bc66d'
theme.xcolor11    = xrdb.color1     or '#db695b'
theme.xcolor12    = xrdb.color1     or '#3dbac2'
theme.xcolor13    = xrdb.color1     or '#825ece'
theme.xcolor14    = xrdb.color1     or '#62cdcd'
theme.xcolor15    = xrdb.color1     or '#e0e5e5'

theme.bg_dark = theme.xbackground
theme.bg_normal = theme.xcolor0
theme.bg_focus = theme.xcolor8
theme.bg_urgent = theme.xcolor8
theme.bg_minimize = theme.xcolor8
theme.bg_systray = theme.xbackground

theme.fg_normal = theme.xcolor8
theme.fg_focus = theme.xcolor4
theme.fg_urget = theme.xcolor3
theme.fg_minimize = theme.xcolor8

theme.useless_gap = dpi(4)
theme.screen_margin = dpi(4)

theme.border_width = dpi(4)
theme.border_color = theme.xcolor0
theme.border_normal = theme.xcolor0
theme.border_focus = theme.xcolor0
theme.border_radius = dpi(4)

-- titlebars
theme.titlebars_enabled = true
theme.titlebar_size = dpi(35)
theme.titlebar_title_enabled = true

-- exit screen
theme.exit_screen_bg = theme.xcolor0 .. 'cc'
theme.exit_screen_gr = theme.color7
theme.exit_screen_font = 'sans 20'
theme.exit_screen_icon_size = dpi(180)

theme.exit_icon = theme.dir .. '/icons/exit-screen/exit.png'
theme.lock_icon = theme.dir .. '/icons/exit-screen/lock.png'
theme.poweroff_icon = theme.dir .. '/icons/exit-screen/poweroff.png'
theme.hibernate_icon = theme.dir .. '/icons/exit-screen/hibernate.png'
theme.reboot_icon = theme.dir .. '/icons/exit-screen/reboot.png'
theme.suspend_icon = theme.dir .. '/icons/exit-screen/suspend.png'

return theme

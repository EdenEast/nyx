-- Define a global table that I can use
G = {}

local os_uname = vim.loop.os_uname()

G.is_mac     = os_uname.sysname == 'Darwin'
G.is_linux   = os_uname.sysname == 'Linux'
G.is_windows = os_uname.sysname == 'Windows_NT'
G.is_wsl     = not (string.find(os_uname.release, 'microsoft') == nil)

require('eden.first.path')

-- vim: sw=2 ts=2 sts=2 et

local global = {}

local os_uname = vim.loop.os_uname()
local sep = global.is_windows and '\\' or '/'
local home = os.getenv('HOME')

function global:load_variables()
	self.is_mac     = os_uname.sysname == 'Darwin'
	self.is_linux   = os_uname.sysname == 'Linux'
	self.is_windows = os_uname.sysname == 'Windows_NT'
	self.is_wsl     = not (string.find(os_uname.release, 'microsoft') == nil)

	self.pathsep    = sep
	self.home       = home
	self.confighome = home .. sep .. '.config' .. sep .. 'nvim'
	self.datahome   = home .. sep .. '.local' .. sep .. 'share' .. sep .. 'nvim'
	self.cachehome  = home .. sep .. '.cache' .. sep .. 'nvim'
end

global:load_variables()

return global


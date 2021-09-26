local M = {}

local uname = vim.loop.os_uname()

M.is_mac = uname.sysname == "Darwin"
M.is_linux = uname.sysname == "Linux"
M.is_windows = uname.sysname == "Windows_NT"
M.is_wsl = not (string.find(uname.release, "microsoft") == nil)

edn.platform = M

return M

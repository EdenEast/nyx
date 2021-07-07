local global = {}

local os_uname = vim.loop.os_uname()
local home = os.getenv("HOME")

function global:load_variables()
  self.is_mac = os_uname.sysname == "Darwin"
  self.is_linux = os_uname.sysname == "Linux"
  self.is_windows = os_uname.sysname == "Windows_NT"
  self.is_wsl = not (string.find(os_uname.release, "microsoft") == nil)

  self.pathsep = self.is_windows and "\\" or "/"
  self.home = home
  self.confighome = home .. self.pathsep .. ".config" .. self.pathsep .. "nvim"
  self.datahome = home .. self.pathsep .. ".local" .. self.pathsep .. "share" .. self.pathsep .. "nvim"
  self.cachehome = home .. self.pathsep .. ".cache" .. self.pathsep .. "nvim"

  vim.g.home = self.home
  vim.g.confighome = self.confighome
  vim.g.datahome = self.datahome
  vim.g.cachehome = self.cachehome
end

global:load_variables()

return global

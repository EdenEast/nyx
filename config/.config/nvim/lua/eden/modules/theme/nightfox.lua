-- vim.g.nightfox_debug = true

local path = require("eden.core.path")
local platform = require("eden.core.platform")

local function get_wsl_home_path()
  local cached_path = path.join(path.cachehome, "nightfox", "wsl_path_cache")
  local home = path.read_file(cached_path, "*l")
  if not home then
    home = vim.fn.system(string.format([[wslpath $(wslvar USERPROFILE) | tr -d '\n']]))
    path.ensure(path.join(path.cachehome, "nightfox"))
    path.write_file(cached_path, home)
  end
  return home
end

-- Check local wezterm file to see if we need to use transparent
local home = platform.is.wsl and get_wsl_home_path() or path.home
local wez_path = path.join(home, ".local", "share", "wezterm", "config.lua")
local file, wez = loadfile(wez_path), nil
if file then
  wez = file()
end

local trans = wez and wez.window_background_opacity and wez.window_background_opacity < 1 or false

require("nightfox").setup({
  options = {
    transparent = trans,
    module_default = false,
    modules = {
      cmp = true,
      dap_ui = true,
      diagnostic = true,
      fidget = true,
      gitgutter = true,
      gitsigns = true,
      lightspeed = true,
      neogit = true,
      notify = true,
      nvimtree = true,
      telescope = true,
      treesitter = true,
      whichkey = true,

      native_lsp = {
        enable = true,
        background = false,
      },
    },
  },
  specs = {
    all = {
      syntax = {
        operator = "orange",
      },
    },
  },
  groups = {
    all = {
      TelescopeBorder = { fg = "bg4" },
      TelescopeTitle = { fg = "fg2", bg = "bg4" },

      CmpItemKindFunction = { fg = "palette.pink" },
      CmpItemKindMethod = { fg = "palette.pink" },
      CmpWindowBorder = { fg = "bg0", bg = "bg0" },
    },
  },
})

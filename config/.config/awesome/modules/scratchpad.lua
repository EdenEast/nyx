local awful = require("awful")
local bling = require("modules.bling")

local setup = function()
  -- Get the currnet focused screen
  local screen = awful.screen.focused()
  local g = screen.geometry
  local ratio = 80

  local width = (g.width / 100) * ratio
  local height = (g.height / 100) * ratio

  local x = (g.width - width) / 2
  local y = (g.height - height) / 2

  local term_scratch = bling.module.scratchpad:new({
    -- command = "wezterm start --class spad",
    command = "alacritty --class spad",
    rule = { instance = "spad" },
    sticky = true,
    autoclose = true,
    floating = true,
    geometry = { x = x, y = y, height = height, width = width },
    -- geometry = { x = 360, y = 90, height = 900, width = 1200 },
    reapply = true,
    -- When set to true, the scratchpad will be closed by the toggle function regardless of whether its focused or not.
    -- When set to false, the toggle function will first bring the scratchpad into focus and only close it on a second call
    dont_focus_before_close = false,
  })

  return term_scratch
end

return setup()

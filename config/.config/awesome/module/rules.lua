local awful = require('awful')
local gears = require('gears')

awful.rules.rules = {
  -- All client will match this rule
  {
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      raise = true,
      keys = require('keys').client,
      buttons = {},
      screen = awful.screen.preferred,
      placement = awful.placement.no_offscreen
    }
  },
  {
    rule_any = { type = { 'normal', 'dialog' } },
    properties = {
      titlebars_enabled = true
    }
  }
}

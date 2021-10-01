local provider = require("feline.providers.vi_mode")

local M = { provider = provider }

M.text = {
  n = "NORMAL",
  no = "NORMAL",
  i = "INSERT",
  v = "VISUAL",
  V = "V-LINE",
  [""] = "V-BLOCK",
  c = "COMMAND",
  cv = "COMMAND",
  ce = "COMMAND",
  R = "REPLACE",
  Rv = "REPLACE",
  s = "SELECT",
  S = "SELECT",
  [""] = "SELECT",
  t = "TERMINAL",
}

M.colors = {
  NORMAL = "cyan",
  OP = "cyan",
  INSERT = "white",
  VISUAL = "magenta",
  LINES = "magenta",
  BLOCK = "magenta",
  REPLACE = "red",
  ["V-REPLACE"] = "red",
  ENTER = "blue",
  MORE = "blue",
  SELECT = "magenta",
  COMMAND = "yellow",
  SHELL = "blue",
  TERM = "blue",
  NONE = "orange",
}

return M

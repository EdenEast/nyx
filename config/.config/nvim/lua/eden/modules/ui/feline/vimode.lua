local M = {}

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
  n = "FeLnCyan",
  no = "FeLnCyan",
  i = "FeLnWhite",
  v = "FeLnMagenta",
  V = "FeLnMagenta",
  [""] = "FeLnMagenta",
  R = "FeLnRed",
  Rv = "FeLnRed",
  r = "FeLnBlue",
  rm = "FeLnBlue",
  s = "FeLnMagenta",
  S = "FeLnMagenta",
  [""] = "FelnMagenta",
  c = "FeLnYellow",
  ["!"] = "FeLnBlue",
  t = "FeLnBlue",
}

return M

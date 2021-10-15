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
  n = "FlnViCyan",
  no = "FlnViCyan",
  i = "FlnViWhite",
  v = "FlnViMagenta",
  V = "FlnViMagenta",
  [""] = "FlnViMagenta",
  R = "FlnViRed",
  Rv = "FlnViRed",
  r = "FlnViBlue",
  rm = "FlnViBlue",
  s = "FlnViMagenta",
  S = "FlnViMagenta",
  [""] = "FelnMagenta",
  c = "FlnViYellow",
  ["!"] = "FlnViBlue",
  t = "FlnViBlue",
}

M.sep = {
  n = "FlnCyan",
  no = "FlnCyan",
  i = "FlnWhite",
  v = "FlnMagenta",
  V = "FlnMagenta",
  [""] = "FlnMagenta",
  R = "FlnRed",
  Rv = "FlnRed",
  r = "FlnBlue",
  rm = "FlnBlue",
  s = "FlnMagenta",
  S = "FlnMagenta",
  [""] = "FelnMagenta",
  c = "FlnYellow",
  ["!"] = "FlnBlue",
  t = "FlnBlue",
}

return M

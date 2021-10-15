local M = { vi = {} }

M.vi.text = {
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

M.vi.colors = {
  n = "FlnViCyan",
  no = "FlnViCyan",
  i = "FlnStatus",
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

M.vi.sep = {
  n = "FlnCyan",
  no = "FlnCyan",
  i = "FlnStatusBg",
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

M.icons = {
  locker = "", -- #f023
  page = "☰", -- 2630
  line_number = "", -- e0a1
  connected = "", -- f817
  dos = "", -- e70f
  unix = "", -- f17c
  mac = "", -- f179
  mathematical_L = "𝑳",
  vertical_bar = "┃",
  vertical_bar_thin = "│",
  left = "",
  right = "",
  block = "█",
  left_filled = "",
  right_filled = "",
  slant_left = "",
  slant_left_thin = "",
  slant_right = "",
  slant_right_thin = "",
  slant_left_2 = "",
  slant_left_2_thin = "",
  slant_right_2 = "",
  slant_right_2_thin = "",
  left_rounded = "",
  left_rounded_thin = "",
  right_rounded = "",
  right_rounded_thin = "",
  circle = "●",
}

return M

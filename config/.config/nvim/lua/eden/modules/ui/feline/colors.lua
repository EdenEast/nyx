local function fromhl(hl, default, bg)
  local gui = bg and "guibg" or "guifg"
  return vim.api.nvim_exec("highlight " .. hl, true):match(gui .. "=(#[0-9A-Fa-f]+)") or default
end

local function term(num, default)
  local key = "terminal_color_" .. num
  return vim.g[key] and vim.g[key] or default
end

local M = {}

M.colors = {
  bg = fromhl("StatusLine", "#2E3440", true),
  fg = fromhl("StatusLine", "#8FBCBB"),
  hint = fromhl("DiagnosticHint", "#5E81AC"),
  info = fromhl("DiagnosticInfo", "#81A1C1"),
  warn = fromhl("DiagnosticWarn", "#EBCB8B"),
  err = fromhl("DiagnosticError", "#EC5F67"),
  black = term(0, "#434C5E"),
  red = term(1, "#EC5F67"),
  green = term(2, "#8FBCBB"),
  yellow = term(3, "#EBCB8B"),
  blue = term(4, "#5E81AC"),
  magenta = term(5, "#B48EAD"),
  cyan = term(6, "#88C0D0"),
  whilte = term(7, "#ECEFF4"),
}

return M

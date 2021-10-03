local function fromhl(hl, default, bg)
  local gui = bg and "guibg" or "guifg"
  return vim.api.nvim_exec("highlight " .. hl, true):match(gui .. "=(#[0-9A-Fa-f]+)") or default
end

local function term(num, default)
  local key = "terminal_color_" .. num
  return vim.g[key] and vim.g[key] or default
end

local function highlight(group, color)
  local style = color.style and "gui=" .. color.style or "gui=NONE"
  local fg = color.fg and "guifg=" .. color.fg or "guifg=NONE"
  local bg = color.bg and "guibg=" .. color.bg or "guibg=NONE"
  local sp = color.sp and "guisp=" .. color.sp or ""
  local hl = "highlight " .. group .. " " .. style .. " " .. fg .. " " .. bg .. " " .. sp
  vim.cmd(hl)
end

local function colors_from_theme()
  return {
    bg = fromhl("StatusLine", "#2E3440", true),
    alt = fromhl("PmenuSel", "#475062", true),
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
    white = term(7, "#ECEFF4"),
  }
end

local function gen_highlights()
  local c = colors_from_theme()
  local groups = {
    -- Colors for vi modes
    FeLnBlack = { fg = c.white, bg = c.black, style = "bold" },
    FeLnRed = { fg = c.bg, bg = c.red, style = "bold" },
    FeLnGreen = { fg = c.bg, bg = c.green, style = "bold" },
    FeLnYellow = { fg = c.bg, bg = c.yellow, style = "bold" },
    FeLnBlue = { fg = c.bg, bg = c.blue, style = "bold" },
    FeLnMagenta = { fg = c.bg, bg = c.magenta, style = "bold" },
    FeLnCyan = { fg = c.bg, bg = c.cyan, style = "bold" },
    FeLnWhite = { fg = c.bg, bg = c.white, style = "bold" },

    -- Diagnostics
    FeLnHint = { fg = c.bg, bg = c.hint, style = "bold" },
    FeLnInfo = { fg = c.bg, bg = c.info, style = "bold" },
    FeLnWarn = { fg = c.bg, bg = c.warn, style = "bold" },
    FeLnError = { fg = c.bg, bg = c.err, style = "bold" },

    -- Dianostic Seperators
    FeLnBgHint = { fg = c.bg, bg = c.hint },
    FeLnHintInfo = { fg = c.hint, bg = c.info },
    FeLnInfoWarn = { fg = c.info, bg = c.warn },
    FeLnWarnError = { fg = c.warn, bg = c.err },
    FeLnErrorStatus = { fg = c.err, bg = c.white },
    FeLnStatusBg = { fg = c.white, bg = c.bg },

    FeLnGitBranch = { fg = c.yellow, bg = c.bg },
    FeLnGitSeperator = { fg = c.bg, bg = c.alt },
    FeLnFileInfo = { fg = c.fg, bg = c.alt },
  }
  for group, values in pairs(groups) do
    highlight(group, values)
  end
end

return { gen_highlights = gen_highlights }

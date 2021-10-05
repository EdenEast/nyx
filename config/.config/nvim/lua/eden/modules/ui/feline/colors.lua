local M = {}

local function highlight(group, color)
  local style = color.style and "gui=" .. color.style or "gui=NONE"
  local fg = color.fg and "guifg=" .. color.fg or "guifg=NONE"
  local bg = color.bg and "guibg=" .. color.bg or "guibg=NONE"
  local sp = color.sp and "guisp=" .. color.sp or ""
  local hl = "highlight " .. group .. " " .. style .. " " .. fg .. " " .. bg .. " " .. sp
  vim.cmd(hl)
end

local function fromhl(hl)
  local result = {}
  local list = vim.api.nvim_get_hl_by_name(hl, true)
  for k, v in pairs(list) do
    result[k] = string.format("#%06x", v)
  end
  return result
end

local function term(num, default)
  local key = "terminal_color_" .. num
  return vim.g[key] and vim.g[key] or default
end

local function colors_from_theme()
  return {
    bg = fromhl("StatusLine").background, -- or "#2E3440",
    alt = fromhl("PmenuSel").background, -- or "#475062",
    fg = fromhl("StatusLine").foreground, -- or "#8FBCBB",
    hint = fromhl("DiagnosticHint").bg or "#5E81AC",
    info = fromhl("DiagnosticInfo").bg or "#81A1C1",
    warn = fromhl("DiagnosticWarn").bg or "#EBCB8B",
    err = fromhl("DiagnosticError").bg or "#EC5F67",
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

M.gen_highlights = function()
  local c = colors_from_theme()
  local sfg = vim.o.background == "dark" and c.black or c.white
  local sbg = vim.o.background == "dark" and c.white or c.black
  M.colors = c
  local groups = {
    FeLnViBlack = { fg = c.white, bg = c.black, style = "bold" },
    FeLnViRed = { fg = c.bg, bg = c.red, style = "bold" },
    FeLnViGreen = { fg = c.bg, bg = c.green, style = "bold" },
    FeLnViYellow = { fg = c.bg, bg = c.yellow, style = "bold" },
    FeLnViBlue = { fg = c.bg, bg = c.blue, style = "bold" },
    FeLnViMagenta = { fg = c.bg, bg = c.magenta, style = "bold" },
    FeLnViCyan = { fg = c.bg, bg = c.cyan, style = "bold" },
    FeLnViWhite = { fg = c.bg, bg = c.white, style = "bold" },

    FeLnBlack = { fg = c.black, bg = c.white, style = "bold" },
    FeLnRed = { fg = c.red, bg = c.bg, style = "bold" },
    FeLnGreen = { fg = c.green, bg = c.bg, style = "bold" },
    FeLnYellow = { fg = c.yellow, bg = c.bg, style = "bold" },
    FeLnBlue = { fg = c.blue, bg = c.bg, style = "bold" },
    FeLnMagenta = { fg = c.magenta, bg = c.bg, style = "bold" },
    FeLnCyan = { fg = c.cyan, bg = c.bg, style = "bold" },
    FeLnWhite = { fg = c.white, bg = c.bg, style = "bold" },

    -- Diagnostics
    FeLnHint = { fg = c.bg, bg = c.hint, style = "bold" },
    FeLnInfo = { fg = c.bg, bg = c.info, style = "bold" },
    FeLnWarn = { fg = c.bg, bg = c.warn, style = "bold" },
    FeLnError = { fg = c.bg, bg = c.err, style = "bold" },
    FeLnStatus = { fg = sfg, bg = sbg, style = "bold" },

    -- Dianostic Seperators
    FeLnBgHint = { fg = c.bg, bg = c.hint },
    FeLnHintInfo = { fg = c.hint, bg = c.info },
    FeLnInfoWarn = { fg = c.info, bg = c.warn },
    FeLnWarnError = { fg = c.warn, bg = c.err },
    FeLnErrorStatus = { fg = c.err, bg = sbg },
    FeLnStatusBg = { fg = sbg, bg = c.bg },

    FeLnFileInfo = { fg = c.fg, bg = c.alt },
    FeLnGitBranch = { fg = c.yellow, bg = c.bg },
    FeLnGitSeperator = { fg = c.bg, bg = c.alt },
  }
  for k, v in pairs(groups) do
    highlight(k, v)
  end
end

return M

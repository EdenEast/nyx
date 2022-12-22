local fmt = string.format

-- Ui highlight color groups
--
-- This file contains the highlight group definitions for both:
--   - feline (statusline)
--   - tabby (tabline)
--
-- The colors are pulled from the current applied colorscheme.  This requires
-- that your colorscheme defines the highlight groups queried as well as
-- neovim's vim.g.terminal_color_* (s).
--
-- There is an autocmd that regenerates the highlight group colors on
-- colorscheme change.

local M = {}

local function first_to_upper(s)
  return s:sub(1, 1):upper() .. s:sub(2)
end

local function set_highlights(groups)
  local lines = {}
  for group, opts in pairs(groups) do
    if opts.link then
      table.insert(lines, fmt("highlight! link %s %s", group, opts.link))
    else
      table.insert(
        lines,
        fmt(
          "highlight %s guifg=%s guibg=%s gui=%s guisp=%s",
          group,
          opts.fg or "NONE",
          opts.bg or "NONE",
          opts.style or "NONE",
          opts.sp or "NONE"
        )
      )
    end
  end
  vim.cmd(table.concat(lines, " | "))
end

local function get_highlight(name)
  local hl = vim.api.nvim_get_hl_by_name(name, true)
  if hl.link then
    return get_highlight(hl.link)
  end

  local hex = function(n)
    if n then
      return string.format("#%06x", n)
    end
  end

  local names = { "underline", "undercurl", "bold", "italic", "reverse" }
  local styles = {}
  for _, n in ipairs(names) do
    if hl[n] then
      table.insert(styles, n)
    end
  end

  return {
    fg = hex(hl.foreground),
    bg = hex(hl.background),
    sp = hex(hl.special),
    style = #styles > 0 and table.concat(styles, ",") or "NONE",
  }
end

local function generate_pallet_from_colorscheme()
  -- stylua: ignore
  local color_map = {
    black   = { index = 0, default = "#393b44" },
    red     = { index = 1, default = "#c94f6d" },
    green   = { index = 2, default = "#81b29a" },
    yellow  = { index = 3, default = "#dbc074" },
    blue    = { index = 4, default = "#719cd6" },
    magenta = { index = 5, default = "#9d79d6" },
    cyan    = { index = 6, default = "#63cdcf" },
    white   = { index = 7, default = "#dfdfe0" },
  }

  local diagnostic_map = {
    hint = { hl = "DiagnosticHint", default = color_map.green.default },
    info = { hl = "DiagnosticInfo", default = color_map.blue.default },
    warn = { hl = "DiagnosticWarn", default = color_map.yellow.default },
    error = { hl = "DiagnosticError", default = color_map.red.default },
  }

  local palette = {}
  for name, value in pairs(color_map) do
    local global_name = "terminal_color_" .. value.index
    palette[name] = vim.g[global_name] and vim.g[global_name] or value.default
  end

  for name, value in pairs(diagnostic_map) do
    palette[name] = get_highlight(value.hl).fg or value.default
  end

  local cursorline = get_highlight("CursorLine")
  palette.bgalt = cursorline.bg
  palette.sl = get_highlight("StatusLine")
  palette.tab = get_highlight("TabLine")
  palette.sel = get_highlight("PmenuSel")
  palette.fill = get_highlight("TabLineFill")

  return palette
end

function M.generate_user_config_highlights()
  local pal = generate_pallet_from_colorscheme()

  -- stylua: ignore
  local sl_colors = {
    Black   = { fg = pal.black,   bg = pal.white },
    Red     = { fg = pal.red,     bg = pal.sl.bg },
    Green   = { fg = pal.green,   bg = pal.sl.bg },
    Yellow  = { fg = pal.yellow,  bg = pal.sl.bg },
    Blue    = { fg = pal.blue,    bg = pal.sl.bg },
    Magenta = { fg = pal.magenta, bg = pal.sl.bg },
    Cyan    = { fg = pal.cyan,    bg = pal.sl.bg },
    White   = { fg = pal.white,   bg = pal.black },
  }

  local colors = {}
  for name, value in pairs(sl_colors) do
    colors["Eden" .. name] = { fg = value.fg, bg = value.bg, style = "bold" }
    colors["EdenRv" .. name] = { fg = value.bg, bg = value.fg, style = "bold" }
  end

  local status = vim.o.background == "dark" and { fg = pal.black, bg = pal.white } or { fg = pal.white, bg = pal.black }

  local groups = {
    EdenSLHint = { fg = pal.sl.bg, bg = pal.hint, style = "bold" },
    EdenSLInfo = { fg = pal.sl.bg, bg = pal.info, style = "bold" },
    EdenSLWarn = { fg = pal.sl.bg, bg = pal.warn, style = "bold" },
    EdenSLError = { fg = pal.sl.bg, bg = pal.error, style = "bold" },
    EdenSLStatus = { fg = status.fg, bg = status.bg, style = "bold" },

    EdenSLFtHint = { fg = pal.bgalt, bg = pal.hint },
    EdenSLHintInfo = { fg = pal.hint, bg = pal.info },
    EdenSLInfoWarn = { fg = pal.info, bg = pal.warn },
    EdenSLWarnError = { fg = pal.warn, bg = pal.error },
    EdenSLErrorStatus = { fg = pal.error, bg = status.bg },
    EdenSLStatusBg = { fg = status.bg, bg = pal.sl.bg },

    EdenSLAlt = { fg = status.bg, bg = pal.bgalt },
    EdenSLAltSep = { fg = pal.sl.bg, bg = pal.bgalt },
    EdenSLGitBranch = { fg = pal.yellow, bg = pal.sl.bg },

    -- tabline
    EdenTLHead = { fg = pal.fill.bg, bg = pal.cyan },
    EdenTLHeadSep = { fg = pal.cyan, bg = pal.fill.bg },
    EdenTLActive = { fg = pal.sel.fg, bg = pal.sel.bg, style = "bold" },
    EdenTLActiveSep = { fg = pal.sel.bg, bg = pal.fill.bg },
    EdenTLBoldLine = { fg = pal.tab.fg, bg = pal.tab.bg, style = "bold" },
    EdenTLLineSep = { fg = pal.tab.bg, bg = pal.fill.bg },
  }

  set_highlights(vim.tbl_extend("force", colors, groups))
end

M.generate_user_config_highlights()

-- Define autocmd that generates the highlight groups from the new colorscheme
-- Then reset the highlights for feline
augroup("EdenUiColorschemeReload", {
  event = { "SessionLoadPost", "ColorScheme" },
  exec = function()
    require("eden.mod.ui.colors").generate_user_config_highlights()
  end,
})

return M

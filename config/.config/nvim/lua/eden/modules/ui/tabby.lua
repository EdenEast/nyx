local filename = require("tabby.filename")
require("eden.modules.ui.colors")
local util = require("tabby.util")

local hl_tabline = util.extract_nvim_hl("TabLine")
local hl_tabline_sel = util.extract_nvim_hl("TabLineSel")
local hl_tabline_fill = util.extract_nvim_hl("TabLineFill")

local cwd = function()
  return "  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " "
end

-- ֍ ֎ 

local line = {
  hl = "TabLineFill",
  layout = "active_wins_at_tail",
  head = {
    { cwd, hl = "TbyHead" },
    { "", hl = "TbyHeadSep" },
  },
  active_tab = {
    label = function(tabid)
      return {
        "  " .. tabid .. " ",
        hl = "TbyActive",
      }
    end,
    left_sep = { "", hl = "TbyActiveSep" },
    right_sep = { "", hl = "TbyActiveSep" },
  },
  inactive_tab = {
    label = function(tabid)
      return {
        "  " .. tabid .. " ",
        hl = "TbyBoldLine",
      }
    end,
    left_sep = { "", hl = "TbyLineSep" },
    right_sep = { "", hl = "TbyLineSep" },
  },
  top_win = {
    label = function(winid)
      return {
        "  " .. filename.unique(winid) .. " ",
        hl = "TabLine",
      }
    end,
    left_sep = { "", hl = "TbyLineSep" },
    right_sep = { "", hl = "TbyLineSep" },
  },
  win = {
    label = function(winid)
      return {
        "  " .. filename.unique(winid) .. " ",
        hl = "TabLine",
      }
    end,
    left_sep = { "", hl = "TbyLineSep" },
    right_sep = { "", hl = "TbyLineSep" },
  },
  tail = {
    { "", hl = "TbyHeadSep" },
    { "  ", hl = "TbyHead" },
  },
}

require("tabby").setup({ tabline = line })

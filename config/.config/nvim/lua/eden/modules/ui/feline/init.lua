-- local colors = require("eden.modules.ui.feline.colors")
local vimode = require("eden.modules.ui.feline.vimode")
local colors = require("eden.modules.ui.colors")

-- "┃", "█", "", "", "", "", "", "", "●"

local get_diag = function(str)
  local count = vim.lsp.diagnostic.get_count(0, str)
  return (count > 0) and " " .. count .. " " or ""
end

local function vi_mode_hl()
  return vimode.colors[vim.fn.mode()] or "FlnViBlack"
end

local function vi_sep_hl()
  return vimode.sep[vim.fn.mode()] or "FlnBlack"
end

local c = {
  vimode = {
    provider = function()
      return string.format(" %s ", vimode.text[vim.fn.mode()])
    end,
    hl = vi_mode_hl,
    right_sep = { str = " ", hl = vi_sep_hl },
  },
  gitbranch = {
    provider = "git_branch",
    icon = " ",
    hl = "FlnGitBranch",
    right_sep = { str = "  ", hl = "FlnGitBranch" },
    enabled = function()
      return vim.b.gitsigns_status_dict ~= nil
    end,
  },
  fileinfo = {
    provider = { name = "file_info", opts = { type = "relative" } },
    hl = "FlnAlt",
    left_sep = { str = " ", hl = "FlnAltSep" },
    right_sep = { str = "", hl = "FlnAltSep" },
  },
  file_enc = {
    provider = "file_encoding",
    hl = "StatusLine",
    left_sep = { str = " ", hl = "StatusLine" },
  },
  cur_position = {
    provider = "position",
    hl = "StatusLine",
    left_sep = { str = " ┃", hl = "StatusLine" },
    right_sep = { str = " ", hl = "StatusLine" },
  },
  cur_percent = {
    provider = function()
      return " " .. require("feline.providers.cursor").line_percentage() .. " "
    end,
    hl = vi_mode_hl,
    left_sep = { str = "", hl = vi_sep_hl },
    right_sep = { str = " ", hl = vi_mode_hl },
  },
  default = { -- needed to pass the parent StatusLine hl group to right hand side
    provider = "",
    hl = "StatusLine",
  },
  lsp_status = {
    provider = function()
      return require("lsp-status").status()
    end,
    hl = "FlnStatus",
    left_sep = { str = "", hl = "FlnStatusBg", always_visible = true },
    right_sep = { str = "", hl = "FlnErrorStatus", always_visible = true },
  },
  lsp_error = {
    provider = function()
      return get_diag("Error")
    end,
    hl = "FlnError",
    right_sep = { str = "", hl = "FlnWarnError", always_visible = true },
  },
  lsp_warn = {
    provider = function()
      return get_diag("Warning")
    end,
    hl = "FlnWarn",
    right_sep = { str = "", hl = "FlnInfoWarn", always_visible = true },
  },
  lsp_info = {
    provider = function()
      return get_diag("Information")
    end,
    hl = "FlnInfo",
    right_sep = { str = "", hl = "FlnHintInfo", always_visible = true },
  },
  lsp_hint = {
    provider = function()
      return get_diag("Hint")
    end,
    hl = "FlnHint",
    right_sep = { str = "", hl = "FlnBgHint", always_visible = true },
  },

  in_fileinfo = {
    provider = "file_info",
    hl = "StatusLine",
  },
  in_position = {
    provider = "position",
    hl = "StatusLine",
  },
}

local active = {
  { -- left
    c.vimode,
    c.gitbranch,
    c.fileinfo,
    c.default,
  },
  { -- right
    c.lsp_status,
    c.lsp_error,
    c.lsp_warn,
    c.lsp_info,
    c.lsp_hint,
    c.file_enc,
    c.cur_position,
    c.cur_percent,
  },
}

local inactive = {
  { c.in_fileinfo }, -- left
  { c.in_position }, -- right
}

-- -- Define autocmd that generates the highlight groups from the new colorscheme
-- -- Then reset the highlights for feline
-- edn.aug.FelineColorschemeReload = {
--   {
--     { "SessionLoadPost", "ColorScheme" },
--     function()
--       require("eden.modules.ui.feline.colors").gen_highlights()
--       -- This does not look like it is required. If this is called I see the ^^^^^^ that
--       -- seperates the two sides of the bar. Since the entire config uses highlight groups
--       -- all that is required is to redefine them.
--       -- require("feline").reset_highlights()
--     end,
--   },
-- }

require("feline").setup({
  components = { active = active, inactive = inactive },
  highlight_reset_triggers = {},
  default_hl = {
    active = {
      bg = colors.colors.bg,
      fg = colors.colors.fg,
    },
    inactive = {
      bg = colors.colors.bg,
      fg = colors.colors.fg,
    },
  },
  force_inactive = {
    filetypes = {
      "NvimTree",
      "packer",
      "dap-repl",
      "dapui_scopes",
      "dapui_stacks",
      "dapui_watches",
      "dapui_repl",
      "LspTrouble",
      "qf",
      "help",
    },
    buftypes = { "terminal" },
    bufnames = {},
  },
  disable = {
    filetypes = {
      "dashboard",
      "startify",
    },
  },
})

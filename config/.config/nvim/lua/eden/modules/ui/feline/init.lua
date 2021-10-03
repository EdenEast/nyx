local vi_mode = require("eden.modules.ui.feline.vimode")
local colors = require("eden.modules.ui.feline.colors")

-- Generate highlight groups
colors.gen_highlights()

local compmap = { left = 1, mid = 2, right = 3 }

local active = setmetatable({ {}, {}, {} }, {
  __newindex = function(t, key, value)
    table.insert(t[compmap[key]], value)
  end,
})

local inactive = setmetatable({ {}, {}, {} }, {
  __newindex = function(t, key, value)
    table.insert(t[compmap[key]], value)
  end,
})

local get_diag = function(str)
  local count = vim.lsp.diagnostic.get_count(0, str)
  return (count > 0) and " " .. count .. " " or ""
end

local percentage_provider = function()
  local cursor = require("feline.providers.cursor")
  return " " .. cursor.line_percentage() .. " "
end

local vi_mode_hl = function()
  return vi_mode.colors[vim.fn.mode()] or "FeLnBlack"
end

active.left = {
  provider = function()
    return " " .. vi_mode.text[vim.fn.mode()] .. " "
  end,
  hl = vi_mode_hl,
  right_sep = " ",
}
active.left = {
  provider = "git_branch",
  icon = " ",
  right_sep = "  ",
  hl = "Type",
  enabled = function()
    return vim.b.gitsigns_status_dict ~= nil
  end,
}
active.left = {
  provider = { name = "file_info", opts = { type = "relative" } },
  hl = "FeLnFileInfo",
  left_sep = { str = " ", hl = "FeLnGitSeperator" },
  right_sep = { str = "", hl = "FeLnGitSeperator" },
}

active.right = {
  provider = function()
    return require("lsp-status").status()
  end,
  hl = "FelnWhite",
  left_sep = { str = "", hl = "FeLnStatusBg", always_visible = true },
  right_sep = { str = "", hl = "FeLnErrorStatus", always_visible = true },
}
active.right = {
  provider = function()
    return get_diag("Error")
  end,
  hl = "FeLnError",
  right_sep = { str = "", hl = "FeLnWarnError", always_visible = true },
}
active.right = {
  provider = function()
    return get_diag("Warning")
  end,
  hl = "FeLnWarn",
  right_sep = { str = "", hl = "FeLnInfoWarn", always_visible = true },
}
active.right = {
  provider = function()
    return get_diag("Information")
  end,
  hl = "FeLnInfo",
  right_sep = { str = "", hl = "FeLnHintInfo", always_visible = true },
}
active.right = {
  provider = function()
    return get_diag("Hint")
  end,
  hl = "FeLnHint",
  right_sep = { str = "", hl = "FeLnBgHint", always_visible = true },
}
active.right = { provider = "file_encoding", hl = "StatusLine", left_sep = " " }
active.right = { provider = "position", hl = "StatusLine", left_sep = " ", right_sep = " " }
active.right = { provider = percentage_provider, hl = vi_mode_hl }

inactive.left = { provider = "file_info", hl = "StatusLine" }
inactive.right = { provider = "position", hl = "StatusLine", left_sep = " ", right_sep = " " }

-- Define autocmd that generates the highlight groups from the new colorscheme
-- Then reset the highlights for feline
edn.aug.FelineColorschemeReload = {
  {
    { "SessionLoadPost", "ColorScheme" },
    function()
      require("eden.modules.ui.feline.colors").gen_highlights()
      require("feline").reset_highlights()
    end,
  },
}

require("feline").setup({
  components = { active = active, inactive = inactive },
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

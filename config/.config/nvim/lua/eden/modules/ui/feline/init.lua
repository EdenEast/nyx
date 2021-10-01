local vi_mode = require("eden.modules.ui.feline.vimode")
local colors = require("eden.modules.ui.feline.colors")

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
  return {
    name = vi_mode.provider.get_mode_highlight_name(),
    fg = "bg",
    bg = vi_mode.provider.get_mode_color(),
    style = "bold",
  }
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
  hl = { fg = "yellow", bg = "bg" },
  enabled = function()
    return vim.b.gitsigns_status_dict ~= nil
  end,
}
active.left = {
  provider = { name = "file_info", opts = { type = "relative" } },
  hl = { fg = "fg", bg = "alt" },
  left_sep = { str = " ", hl = { fg = "bg", bg = "alt" } },
  right_sep = { str = "", hl = { fg = "bg", bg = "alt" } },
}

active.right = {
  provider = function()
    return require("lsp-status").status()
  end,
  hl = { fg = "bg", bg = "white", style = "bold" },
  left_sep = { str = "", hl = { fg = "white", bg = "bg" }, always_visible = true },
  right_sep = { str = "", hl = { fg = "err", bg = "white" }, always_visible = true },
}
active.right = {
  provider = function()
    return get_diag("Error")
  end,
  hl = { fg = "bg", bg = "err", style = "bold" },
  right_sep = { str = "", hl = { fg = "warn", bg = "err" }, always_visible = true },
}
active.right = {
  provider = function()
    return get_diag("Warning")
  end,
  hl = { fg = "bg", bg = "warn", style = "bold" },
  right_sep = { str = "", hl = { fg = "info", bg = "warn" }, always_visible = true },
}
active.right = {
  provider = function()
    return get_diag("Information")
  end,
  hl = { fg = "bg", bg = "info", style = "bold" },
  right_sep = { str = "", hl = { fg = "hint", bg = "info" }, always_visible = true },
}
active.right = {
  provider = function()
    return get_diag("Hint")
  end,
  hl = { fg = "bg", bg = "hint", style = "bold" },
  right_sep = { str = "", hl = { fg = "bg", bg = "hint" }, always_visible = true },
}
active.right = { provider = "file_encoding", left_sep = " " }
active.right = { provider = "position", left_sep = " ", right_sep = " " }
active.right = { provider = percentage_provider, hl = vi_mode_hl }

inactive.left = { provider = "file_info" }
inactive.right = { provider = "position", left_sep = " ", right_sep = " " }

require("feline").setup({
  colors = colors.colors,
  vi_mode_colors = vi_mode.colors,
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

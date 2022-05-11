local dev = require("eden.core.pack").dev
local M = {}

M.plugins = {
  {
    "feline-nvim/feline.nvim",
    event = "VimEnter",
    config = function()
      require("eden.modules.ui.feline")
    end,
    requires = { "nvim-lua/lsp-status.nvim" },
  },
  {
    "folke/which-key.nvim",
    config = function()
      require("eden.modules.ui.whichkey")
    end,
  },
  {
    "startup-nvim/startup.nvim",
    cond = "not vim.g.started_by_firenvim",
    config = function()
      require("eden.modules.ui.startup")
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup({
        show_first_indent_level = false,
        show_trailing_blankline_indent = false,
        show_current_context = true,
        show_current_context_start = false, -- underline the start
      })
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    ft = { "html", "css", "sass", "vim", "typescript", "typescriptreact", "lua" },
    config = function()
      require("colorizer").setup({
        css = { rgb_fn = true },
        lua = { names = false },
        sass = { rgb_fn = true },
        scss = { rgb_fn = true },
        stylus = { rgb_fn = true },
        tmux = { names = false },
        vim = { names = true },
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        html = {
          mode = "foreground",
        },
      })
    end,
  },
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      edn.keymap("<leader>ts", [[<cmd>SymbolsOutline<cr>]])
    end,
    cmd = { "SymbolsOutline" },
    keys = { "<leader>ts" },
  },
  {
    "nanozuki/tabby.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    after = "feline.nvim",
    config = function()
      require("eden.modules.ui.tabby")
    end,
  },
}

M.before = function()
  -- Dashboard ----------------------------------------------------------------
  vim.g.dashboard_custom_header = {
    "███████╗██████╗ ███████╗███╗   ██╗",
    "██╔════╝██╔══██╗██╔════╝████╗  ██║",
    "█████╗  ██║  ██║█████╗  ██╔██╗ ██║",
    "██╔══╝  ██║  ██║██╔══╝  ██║╚██╗██║",
    "███████╗██████╔╝███████╗██║ ╚████║",
    "╚══════╝╚═════╝ ╚══════╝╚═╝  ╚═══╝",
  }
  vim.g.dashboard_default_executive = "telescope"
  vim.g.dashboard_custom_section = {
    a = { description = { "  Recently Used Files" }, command = "Telescope oldfiles" },
    b = { description = { "  Find File          " }, command = "Telescope find_files" },
    c = { description = { "⚒  Find Project       " }, command = "Telescope projects" },
    d = { description = { "  Load Last Session  " }, command = "SessionLoad" },
    e = { description = { "  Find Word          " }, command = "Telescope live_grep" },
    f = { description = { "  File Browser       " }, command = "NvimTreeToggle" },
  }
  vim.g.dashboard_custom_footer = { "github.com/EdenEast" }

  -- Indent Line --------------------------------------------------------------

  -- vim.g.indentLine_char = '│'  -- U+2502
  -- vim.g.indentLine_char = '┆'  -- U+2506
  -- vim.g.indentLine_char = "┊" -- U+250A

  -- vim.g.indentLine_enabled = 1
  -- vim.g.indentLine_concealcursor = "niv"
  -- vim.g.indentLine_showFirstIndentLevel = 0
  -- vim.g.incentLine_setColors = 0
  vim.g.indentLine_fileTypeExclude = {
    "defx",
    "denite",
    "startify",
    "dashboard",
    "tagbar",
    "vista_kind",
    "vista",
    "Help",
    "term",
    "toggerm",
  }
end

return M

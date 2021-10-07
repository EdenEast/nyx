local dev = require("eden.core.pack").dev
local M = {}

M.plugins = {
  {
    "shadmansaleh/lualine.nvim",
    event = "VimEnter",
    config = function()
      if vim.g.current_statusline == "lualine" then
        require("eden.modules.ui.lualine")
      end
    end,
    requires = { "nvim-lua/lsp-status.nvim" },
  },
  {
    "famiu/feline.nvim",
    tag = "v0.3",
    event = "VimEnter",
    config = function()
      if vim.g.current_statusline == "feline" then
        require("eden.modules.ui.feline")
      end
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
    "glepnir/dashboard-nvim",
    cond = "not vim.g.started_by_firenvim",
  },
  { "Yggdroot/indentLine" },
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
  vim.g.current_statusline = edn.platform.is_windows and "lualine" or "feline"

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
    c = { description = { "  Load Last Session  " }, command = "SessionLoad" },
    d = { description = { "  Find Word          " }, command = "Telescope live_grep" },
    e = { description = { "  File Browser       " }, command = "Telescope file_browser" },
  }
  vim.g.dashboard_custom_footer = { "github.com/EdenEast" }

  -- Indent Line --------------------------------------------------------------

  -- vim.g.indentLine_char = '│'  -- U+2502
  -- vim.g.indentLine_char = '┆'  -- U+2506
  vim.g.indentLine_char = "┊" -- U+250A

  vim.g.indentLine_enabled = 1
  vim.g.indentLine_concealcursor = "niv"
  vim.g.indentLine_showFirstIndentLevel = 0
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

local M = {}

M.plugins = {
  {
    "feline-nvim/feline.nvim",
    event = "VimEnter",
    conf = "ui.feline",
    requires = { "kyazdani42/nvim-web-devicons" },
  },

  {
    "folke/which-key.nvim",
    conf = "ui.whichkey",
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
    "NvChad/nvim-colorizer.lua",
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
    "rcarriga/nvim-notify",
    conf = "ui.notify",
  },

  {
    "simrat39/symbols-outline.nvim",
    config = function()
      nmap("<leader>ts", [[<cmd>SymbolsOutline<cr>]])
    end,
    cmd = { "SymbolsOutline" },
    keys = { "<leader>ts" },
  },

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },

  {
    "goolord/alpha-nvim",
    conf = "ui.alpha",
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

M.after = function()
  -- Set the which-key descriptions as these are hidden behind packer lazy loading
  local has_wk, wk = pcall(require, "which-key")
  if has_wk then
    wk.register({
      ["<leader>ts"] = "Symbols outline",
    })
  end
end

return M

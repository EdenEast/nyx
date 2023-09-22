return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    dev = true,
    config = function()
      require("nightfox").setup({
        options = {
          module_default = false,
          modules = {
            alpha = true,
            cmp = true,
            dap_ui = true,
            diagnostic = true,
            gitgutter = true,
            gitsigns = true,
            illuminate = true,
            leap = true,
            lsp_semantic_tokens = true,
            lsp_trouble = true,
            mini = true,
            neogit = true,
            neotree = true,
            notify = true,
            nvimtree = true,
            telescope = true,
            treesitter = true,
            whichkey = true,

            native_lsp = {
              enable = true,
              background = false,
            },
          },
        },
        specs = {
          all = {
            syntax = {
              operator = "orange",
            },
          },
        },
        groups = {
          all = {
            TelescopeBorder = { fg = "bg4" },
            TelescopeTitle = { fg = "fg2", bg = "bg4" },

            CmpItemKindFunction = { fg = "palette.pink" },
            CmpItemKindMethod = { fg = "palette.pink" },
            CmpWindowBorder = { fg = "bg0", bg = "bg0" },
          },
        },
      })
    end,
  },

  {
    "nightfox-org/nicefox.nvim",
    lazy = false,
    priority = 1000,
    dev = true,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        term_colors = true,
      })
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    config = function() require("kanagawa").setup({}) end,
  },

  {
    "projekt0n/caret.nvim",
  },
}

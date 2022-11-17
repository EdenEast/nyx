-- vim.g.nightfox_debug = true

require("nightfox").setup({
  options = {
    module_default = false,
    modules = {
      cmp = true,
      dap_ui = true,
      diagnostic = true,
      fidget = true,
      gitgutter = true,
      gitsigns = true,
      lightspeed = true,
      neogit = true,
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

vim.cmd.colorscheme("nightfox")

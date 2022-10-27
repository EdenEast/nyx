require("nightfox").setup({
  options = {
    modules = {
      aerial = false,
      barbar = false,
      dashboard = false,
      fern = false,
      glyph_palette = false,
      hop = false,
      lsp_saga = false,
      modes = false,
      neotree = false,
      pounce = false,
      sneak = false,
      tsrainbow = false,
      native_lsp = {
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

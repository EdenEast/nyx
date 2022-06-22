require("nightfox").setup({
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
    },
  },
})

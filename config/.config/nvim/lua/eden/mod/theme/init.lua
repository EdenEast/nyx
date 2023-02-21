return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("eden.mod.theme.nightfox")
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    dev = true,
    config = function()
      require("catppuccin").setup({
        term_colors = true,
      })
    end,
  },
  {
    "nightfox-org/nicefox.nvim",
    dev = true,
  },

  "sam4llis/nvim-tundra",
  "rebelot/kanagawa.nvim",
}

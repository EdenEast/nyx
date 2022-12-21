return {
  {
    "EdenEast/nightfox.nvim",
    config = function()
      require("eden.modules.theme.nightfox")
    end,
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

  "sam4llis/nvim-tundra",
  "rebelot/kanagawa.nvim",
}

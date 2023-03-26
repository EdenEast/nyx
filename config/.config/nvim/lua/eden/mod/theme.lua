return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    -- dev = true,
  },

  {
    "nightfox-org/nicefox.nvim",
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
    config = function()
      require("kanagawa").setup({})
    end,
  },
}

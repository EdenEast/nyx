local M = {}

M.plugins = {
  {
    "EdenEast/nightfox.nvim",
    dev = true,
    run = ":NightfoxCompile",
    conf = "theme.nightfox",
  },

  {
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      require("catppuccin").setup({
        term_colors = true,
      })
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    conf = "theme.kanagawa",
  },
}

M.before = function()
  vim.g.rose_pine_variant = "moon"
end

return M

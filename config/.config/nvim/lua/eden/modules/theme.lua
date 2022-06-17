local dev = require("eden.core.pack").dev
local M = {}

M.plugins = {
  {
    dev("EdenEast/nightfox.nvim"),
    config = function()
      require("eden.modules.theme.nightfox")
    end,
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
    config = function()
      require("eden.modules.theme.kanagawa")
    end,
  },
}

M.before = function()
  vim.g.rose_pine_variant = "moon"
end

return M

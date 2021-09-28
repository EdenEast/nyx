local dev = require("eden.core.pack").dev
local M = {}

M.plugins = {
  {
    dev("EdenEast/nightfox.nvim"),
    config = function()
      require("nightfox").setup({
        hlgroups = { TSPunctDelimiter = { fg = "${red}" } },
      })
    end,
  },

  {
    "Pocco81/Catppuccino.nvim",
    config = function()
      require("catppuccino").setup({ colorscheme = "neon_latte" })
    end,
  },

  { "embark-theme/vim", "eddyekofo94/gruvbox-flat.nvim" },

  {
    "sunjon/shade.nvim",
    config = function()
      require("shade").setup({
        overlay_opacity = 75,
        opacity_step = 1,
        keys = {
          brightness_up = "<C-Up>",
          brightness_down = "<C-Down>",
          toggle = "<Leader>ts",
        },
      })
    end,
  },
}

return M

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
    {
      "catppuccin/nvim",
      as = "catppuccin",
      config = function()
        require("catppuccin").setup({
          term_colors = true,
        })
      end,
    },
    { "embark-theme/vim", as = "embark" },
    "eddyekofo94/gruvbox-flat.nvim",
    "rose-pine/neovim",
    "rebelot/kanagawa.nvim",
  },
}

M.before = function()
  vim.g.nightfox_debug = true
  vim.g.rose_pine_variant = "moon"
end

return M

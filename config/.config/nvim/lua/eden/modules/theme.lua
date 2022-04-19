local dev = require("eden.core.pack").dev
local M = {}

M.plugins = {
  {
    dev("EdenEast/nightfox.nvim"),
    config = function()
      -- require("nightfox").setup({
      --   hlgroups = { TSPunctDelimiter = { fg = "${red}" } },
      -- })
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
      local remap = {
        samuraiRed = "#c94f6d",
      }
      local overrides = {
        NvimTreeNormal = { link = "NormalFloat" },
        NvimTreeNormalNC = { link = "NormalFloat" },
      }
      require("kanagawa").setup({ overrides = overrides, colors = remap })
    end,
  },
}

M.before = function()
  -- vim.g.nightfox_debug = true
  vim.g.rose_pine_variant = "moon"
end

return M

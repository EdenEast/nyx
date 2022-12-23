local M = {
  "hrsh7th/nvim-cmp",
  event = "BufReadPre",
  config = function()
    require("eden.mod.completion.cmp")
  end,
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      config = function()
        require("luasnip").config.set_config({
          history = true,
          updateevents = "TextChanged,TextChangedI",
        })
      end,
    },
    {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup({
          disable_filetype = { "TelescopePrompt", "vim" },
          enable_check_bracket_line = true,
        })
      end,
    },
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-emoji",
    "f3fora/cmp-spell",
    "ray-x/cmp-treesitter",
  },
}

return M

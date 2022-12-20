local M = {
  "hrsh7th/nvim-cmp",
  config = function()
    require("eden.modules.editor.cmp")
  end,
  dependencies = {
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

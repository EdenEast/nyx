return {
  { "teal-language/vim-teal" },
  { "NoahTheDuke/vim-just" },
  { "plasticboy/vim-markdown" },
  { "Saecki/crates.nvim" },

  {
    "LhKipp/nvim-nu",
    build = ":TSInstall nu",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  {
    "kristijanhusak/orgmode.nvim",
    ft = { "org" },
    config = function()
      require("orgmode").setup()
    end,
  },
}

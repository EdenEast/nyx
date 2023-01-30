return {
  { "teal-language/vim-teal" },
  { "NoahTheDuke/vim-just" },
  { "plasticboy/vim-markdown" },
  { "imsnif/kdl.vim" },

  {
    "Saecki/crates.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "toml" },
    config = function()
      require("crates").setup()
    end,
  },

  {
    "LhKipp/nvim-nu",
    event = "BufReadPost",
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

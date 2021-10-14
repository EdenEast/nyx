local M = {}

M.plugins = {
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("eden.modules.nav.telescope.setup")
    end,
    requires = {
      { "nvim-lua/popup.nvim" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzy-native.nvim" },
    },
  },
  {
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("eden.modules.nav.nvimtree")
    end,
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFindFile" },
    keys = { "<leader>te" },
  },
  {
    "folke/trouble.nvim",
    config = function()
      require("eden.modules.nav.trouble")
    end,
    requires = "kyazdani42/nvim-web-devicons",
  },
}

return M

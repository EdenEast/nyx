return {
  "nvim-telescope/telescope.nvim",
  config = function()
    require("eden.mod.telescope.setup")
  end,
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-frecency.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    -- "nvim-telescope/telescope-fzy-native.nvim",
  },
}

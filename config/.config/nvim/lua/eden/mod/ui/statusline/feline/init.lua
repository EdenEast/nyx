return {
  "feline-nvim/feline.nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("eden.mod.ui.statusline.feline.setup")
  end,
}

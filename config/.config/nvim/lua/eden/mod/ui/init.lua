return {
  {
    "feline-nvim/feline.nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("eden.modules.ui.feline")
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufWinEnter",
    config = function()
      require("indent_blankline").setup({
        show_first_indent_level = false,
        show_trailing_blankline_indent = false,
        show_current_context = true,
        show_current_context_start = false, -- underline the start
      })
    end,
  },
}

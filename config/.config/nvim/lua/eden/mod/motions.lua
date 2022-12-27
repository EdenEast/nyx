local M = {

  -- Comment motion -----------------------------------------------------------
  --
  -- Alternatives:
  --   - "tpope/vim-commentary"
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Surround motion ----------------------------------------------------------
  --
  -- Alternatives:
  --   - "machakann/vim-sandwich"
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- Jumping motion -----------------------------------------------------------
  --
  -- Alternatives:
  --   - phaazon/hop.nvim
  --   - ggandor/leap.nvim
  {
    "ggandor/lightspeed.nvim", -- Jump to any location specified by two characters
    event = "VeryLazy",
    config = function()
      require("lightspeed").setup({
        jump_to_unique_chars = { safety_timeout = 400 },
        match_only_the_start_of_same_char_seqs = true,
        limit_ft_matches = 5,
      })
    end,
  },
}

return M

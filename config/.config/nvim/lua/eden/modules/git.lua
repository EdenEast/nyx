local M = {}

M.plugins = {
  -- Git integrations -------------------------------------------------------------------------------
  -- The wrapper around git
  { "tpope/vim-fugitive" },

  -- Better view for editing commit messages
  { "rhysd/committia.vim" },

  {
    "sindrets/diffview.nvim",
    config = function()
      require("diffview").setup()
    end,
  },

  {
    "TimUntersberger/neogit",
    config = function()
      require("neogit").setup({
        integrations = { diffview = true },
      })

      edn.keymap("<leader>gn", "<cmd>Neogit<cr>")
    end,
    requires = { "nvim-lua/plenary.nvim" },
  },

  {
    "AndrewRadev/linediff.vim",
    config = function()
      edn.keymap("<leader>gp", [[<cmd>LinediffPick<cr>]])
    end,
    cmd = { "LinediffPick" },
    keys = { "<leader>gp" },
  },
}

return M

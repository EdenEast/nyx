return {
  -- Manage lazy itself. And use the dev version if it exists.
  { "folke/lazy.nvim", dev = true },

  -- measure startuptime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function() vim.g.startuptime_tries = 10 end,
  },

  -- tmux navigator
{
    "alexghergh/nvim-tmux-navigation",
    config = function()
      local ntn = require("nvim-tmux-navigation")
      ntn.setup({
        disable_when_zoomed = true, -- defaults to false
      })
      local k = vim.keymap.set
      k("n", "<C-h>", ntn.NvimTmuxNavigateLeft)
      k("n", "<C-j>", ntn.NvimTmuxNavigateDown)
      k("n", "<C-k>", ntn.NvimTmuxNavigateUp)
      k("n", "<C-l>", ntn.NvimTmuxNavigateRight)
    end,
  },

}

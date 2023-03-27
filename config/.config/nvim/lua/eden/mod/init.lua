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
  { "christoomey/vim-tmux-navigator" },
}

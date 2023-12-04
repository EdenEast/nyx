return {
  -- Manage lazy itself. And use the dev version if it exists.
  { "folke/lazy.nvim", dev = true },

  -- measure startuptime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function() vim.g.startuptime_tries = 10 end,
  },

  -- project specific session manager
  {
    "EricDriussi/remember-me.nvim",
    config = function()
      local path = require("eden.core.path")
      require("remember_me").setup({
        session_store = path.join(path.cachehome, "remember-me"),
      })
    end,
  },

  -- tmux navigator
  { "christoomey/vim-tmux-navigator" },
}

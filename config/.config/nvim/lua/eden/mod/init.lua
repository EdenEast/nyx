return {
  -- Manage lazy itself. And use the dev version if it exists.
  { "folke/lazy.nvim", dev = true },

  -- These are some plugins that are misc
  {
    -- "tweekmonster/startuptime.vim",
    "dstein64/vim-startuptime",
    cmd = { "StartupTime" },
  },
  { "editorconfig/editorconfig-vim" },
  { "christoomey/vim-tmux-navigator" },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        patterns = { ".git", ".hg", ".root" },
        datapath = require("eden.core.path").cachehome,
      })
    end,
  },
}

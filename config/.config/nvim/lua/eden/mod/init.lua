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
  {
    "christoomey/vim-tmux-navigator",
    enabled = function()
      return vim.env.TMUX ~= nil
    end,
  },
  {
    "Lilja/zellij.nvim",
    enabled = function()
      return vim.env.ZELLIJ ~= nil
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },
  {
    "nvim-pack/nvim-spectre",
    config = function()
      require("spectre").setup()
    end,
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
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = { "markdown", "vimwiki" },
    cmd = { "MarkdownPreview", "MarkdownPreviewToggle" },
    keys = {
      { "<leader>tp", ":<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown preview" } },
    },
  },
}

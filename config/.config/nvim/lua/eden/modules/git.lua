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
    "rhysd/git-messenger.vim",
    config = function()
      -- Show commit message for current line
      edn.keymap("<leader>gm", "<cmd>GitMessenger<cr>")
    end,
    cmd = { "GitMessenger" },
    keys = { "<leader>gm" },
  },

  {
    "AndrewRadev/linediff.vim",
    config = function()
      edn.keymap("<leader>gp", [[<cmd>LinediffPick<cr>]])
    end,
    cmd = { "LinediffPick" },
    keys = { "<leader>gp" },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { hl = "GitGutterAdd", text = "▋" },
          change = { hl = "GitGutterChange", text = "▋" },
          delete = { hl = "GitGutterDelete", text = "▋" },
          topdelete = { hl = "GitGutterDeleteChange", text = "▔" },
          changedelete = { hl = "GitGutterChange", text = "▎" },
        },
        keymaps = {
          -- Default keymap options
          noremap = true,
          buffer = true,

          ["n ]g"] = { expr = true, "&diff ? ']g' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'" },
          ["n [g"] = { expr = true, "&diff ? '[g' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'" },

          ["n <leader>ghs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
          ["n <leader>ghu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
          ["n <leader>ghr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
          ["n <leader>ghp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
          ["n <leader>ghb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',

          -- Text objects
          ["o ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
          ["x ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
        },
      })
    end,
  },

  {
    "pwntester/octo.nvim",
    cmd = { "Octo" },
    config = function()
      require("octo").setup()
    end,
  },
}

M.begin = function()
  vim.g.git_messenger_no_default_mapping = false
end

return M

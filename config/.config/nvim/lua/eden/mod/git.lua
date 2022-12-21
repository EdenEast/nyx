return {

  {
    "tpope/vim-fugitive",
    opt = true,
    init = function()
      nmap("<leader>ga", ":Git add %:p<cr>", { desc = "Add file" }) -- Stage current file
      nmap("<leader>gd", ":Gdiffsplit<cr>", { desc = "Diff file" }) -- Diff current file
      nmap("<leader>gc", ":Git commit<cr>", { desc = "Commit" }) -- Create a git commit from staged changes
      nmap("<leader>gb", ":Git blame<cr>", { desc = "Blame file" }) -- Blame each line in file
    end,
    cmd = { "Git", "Gdiffsplit" },
  },
  {
    "TimUntersberger/neogit",
    init = function()
      nmap("<leader>gn", "<cmd>Neogit<cr>", { desc = "Neogit" })
    end,
    config = function()
      require("neogit").setup()
    end,
    cmd = { "Neogit" },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
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
}

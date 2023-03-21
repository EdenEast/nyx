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
    "ldelossa/gh.nvim",
    dependencies = { "ldelossa/litee.nvim" },
    cmd = { "GHOpenPR", "GHOpenIssue", "GHOpenCommit", "GHNotifications", "GHSearchIssues", "GHSearchPRs" },
    keys = { "<leader>ghpo", "<leader>ghip", "<leader>ghpt", "<leader>ghpo" },
    -- module = "litree.gh",
    config = function()
      require("litee.lib").setup()
      require("litee.gh").setup()

      -- commits
      nmap("<leader>ghcc", "<cmd>GHCloseCommit<cr>", { desc = "Close" })
      nmap("<leader>ghce", "<cmd>GHExpandCommit<cr>", { desc = "Expand" })
      nmap("<leader>ghco", "<cmd>GHOpenToCommit<cr>", { desc = "Open To" })
      nmap("<leader>ghcp", "<cmd>GHPopOutCommit<cr>", { desc = "Pop Out" })
      nmap("<leader>ghcz", "<cmd>GHCollapseCommit<cr>", { desc = "Collapse" })

      -- issues
      nmap("<leader>ghip", "<cmd>GHPreviewIssue<cr>", { desc = "Preview" })

      -- review
      nmap("<leader>ghrb", "<cmd>GHStartReview<cr>", { desc = "Begin" })
      nmap("<leader>ghrc", "<cmd>GHCloseReview<cr>", { desc = "Close" })
      nmap("<leader>ghrd", "<cmd>GHDeleteReview<cr>", { desc = "Delete" })
      nmap("<leader>ghre", "<cmd>GHExpandReview<cr>", { desc = "Expand" })
      nmap("<leader>ghrs", "<cmd>GHSubmitReview<cr>", { desc = "Submit" })
      nmap("<leader>ghrz", "<cmd>GHCollapseReview<cr>", { desc = "Collapse" })

      -- pull request
      nmap("<leader>ghpc", "<cmd>GHClosePR<cr>", { desc = "Close" })
      nmap("<leader>ghpd", "<cmd>GHPRDetails<cr>", { desc = "Details" })
      nmap("<leader>ghpe", "<cmd>GHExpandPR<cr>", { desc = "Expand" })
      nmap("<leader>ghpo", "<cmd>GHOpenPR<cr>", { desc = "Open" })
      nmap("<leader>ghpp", "<cmd>GHPopOutPR<cr>", { desc = "Pop Out" })
      nmap("<leader>ghpr", "<cmd>GHRefreshPR<cr>", { desc = "Refresh" })
      nmap("<leader>ghpt", "<cmd>GHOpenToPR<cr>", { desc = "Open To" })
      nmap("<leader>ghpz", "<cmd>GHCollapsePR<cr>", { desc = "Collapse" })

      -- threads
      nmap("<leader>ghtc", "<cmd>GHCreateThread<cr>", { desc = "Create" })
      nmap("<leader>ghtn", "<cmd>GHNextThread<cr>", { desc = "Next" })
      nmap("<leader>ghtt", "<cmd>GHToggleThread<cr>", { desc = "Toggle" })

      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.register({
          g = {
            h = {
              name = "+Github",
              c = { name = "+Commits" },
              i = { name = "+Issues" },
              r = { name = "+Review" },
              p = { name = "Pull Request" },
              t = { name = "+Threads" },
            },
          },
        })
      end
    end,
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

          -- ["n <leader>ghs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
          -- ["n <leader>ghu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
          -- ["n <leader>ghr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
          -- ["n <leader>ghp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
          -- ["n <leader>ghb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',
          --
          -- Text objects
          -- ["o ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
          -- ["x ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
        },
      })
    end,
  },
}

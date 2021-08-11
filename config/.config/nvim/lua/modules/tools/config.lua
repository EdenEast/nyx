local config = {}

function config.mkpreview()
  vim.g.mkdp_auto_close = 0
  vim.g.mkdp_echo_preview_url = 1

  vim.keymap.nnoremap({ "<leader>tp", ":MarkdownPreviewToggle<cr>" })
end

function config.fugitive()
  local nnoremap = vim.keymap.nnoremap

  -- Stage current file
  nnoremap({ "<leader>ga", ":Git add %:p<cr>" })

  -- Diff current file
  nnoremap({ "<leader>gd", ":Gdiffsplit<cr>" })

  -- Create a git commit from staged changes
  nnoremap({ "<leader>gc", ":Git commit<cr>" })

  -- Blame each line in file
  nnoremap({ "<leader>gb", ":Git blame<cr>" })
end

function config.messenger()
  vim.g.git_messenger_no_default_mapping = false

  -- Show commit message for current line
  vim.keymap.nnoremap({ "<leader>gm", "<Plug>(git-messenger)" })
end

function config.committia() end

function config.octo() end

function config.diffview()
  -- local cb = require("diffview.config").diffview_callback
  require("diffview").setup({})
end

function config.gitblame()
  vim.g.gitblame_enabled = 0

  vim.keymap.nnoremap({ "<leader>tg", "<cmd>GitBlameToggle<cr>", silent = true })
end

function config.neogit()
  require("neogit").setup({
    integrations = {
      diffview = true,
    },
  })

  vim.keymap.nnoremap({ "<leader>gg", "<cmd>Neogit<cr>" })
end

return config

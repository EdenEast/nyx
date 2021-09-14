local config = {}

function config.mkpreview()
  vim.g.mkdp_auto_close = 0
  vim.g.mkdp_echo_preview_url = 1

  vim.keymap("<leader>tp", ":MarkdownPreviewToggle<cr>")
end

function config.fugitive()
  vim.keymap("<leader>g", {
    -- Stage current file
    { "a", ":Git add %:p<cr>" },

    -- Diff current file
    { "d", ":Gdiffsplit<cr>" },

    -- Create a git commit from staged changes
    { "c", ":Git commit<cr>" },

    -- Blame each line in file
    { "b", ":Git blame<cr>" },
  })
end

function config.messenger()
  vim.g.git_messenger_no_default_mapping = false

  -- Show commit message for current line
  vim.keymap("<leader>gm", "<Plug>(git-messenger)")
end

function config.committia() end

function config.octo() end

function config.diffview()
  -- local cb = require("diffview.config").diffview_callback
  require("diffview").setup({})
end

function config.gitblame()
  vim.g.gitblame_enabled = 0

  vim.keymap("<leader>tg", "<cmd>GitBlameToggle<cr>")
end

function config.neogit()
  require("neogit").setup({
    integrations = {
      diffview = true,
    },
  })

  vim.keymap("<leader>gn", "<cmd>Neogit<cr>")
end

return config

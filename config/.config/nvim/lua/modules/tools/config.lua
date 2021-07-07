local config = {}

function config.mkpreview()
  vim.g.mkdp_auto_close = 0
  vim.g.mkdp_echo_preview_url = 1

  vim.keymap.nnoremap({ "<leader>tp", ":MarkdownPreviewToggle<cr>" })
end

function config.harpoon()
  local nnoremap = vim.keymap.nnoremap

  require("harpoon").setup()

  nnoremap({
    "<leader>hh",
    function()
      require("harpoon.ui").toggle_quick_menu()
    end,
  })
  nnoremap({
    "<leader>ha",
    function()
      require("harpoon.mark").add_file()
    end,
  })

  -- 'neio' is the homerow keys for colemak
  nnoremap({
    "<leader>hn",
    function()
      require("harpoon.ui").nav_file(1)
    end,
  })
  nnoremap({
    "<leader>he",
    function()
      require("harpoon.ui").nav_file(2)
    end,
  })
  nnoremap({
    "<leader>hi",
    function()
      require("harpoon.ui").nav_file(3)
    end,
  })
  nnoremap({
    "<leader>ho",
    function()
      require("harpoon.ui").nav_file(4)
    end,
  })

  -- 'jkl;' are the homerow keys for qwerty
  nnoremap({
    "<leader>hj",
    function()
      require("harpoon.ui").nav_file(1)
    end,
  })
  nnoremap({
    "<leader>hk",
    function()
      require("harpoon.ui").nav_file(2)
    end,
  })
  nnoremap({
    "<leader>hl",
    function()
      require("harpoon.ui").nav_file(3)
    end,
  })
  nnoremap({
    "<leader>h;",
    function()
      require("harpoon.ui").nav_file(4)
    end,
  })

  nnoremap({
    "<leader>ht",
    function()
      require("harpoon.term").gotoTerminal(1)
    end,
  })
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
  local cb = require("diffview.config").diffview_callback
  require("diffview").setup({})
end

function config.gitblame()
  vim.g.gitblame_enabled = 0

  vim.keymap.nnoremap({ "<leader>tg", ":GitBlameToggle<cr>", silent = true })
end

function config.neogit()
  require("neogit").setup({
    integrations = {
      diffview = true,
    },
  })

  vim.keymap.nnoremap({ "<leader>gg", ":Neogit<cr>" })
end

return config

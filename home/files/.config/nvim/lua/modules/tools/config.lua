local config = {}

function config.mkpreview()
  vim.g.mkdp_auto_close = 0
  vim.g.mkdp_echo_preview_url = 1

  vim.keymap.nnoremap { '<leader>tp', ':MarkdownPreviewToggle<cr>' }
end

function config.preview_mkdown()
  vim.g.preview_markdown_parser = 'glow'
  vim.g.preview_markdown_vertical = 1
  vim.g.preview_markdown_auto_update = 1

  vim.keymap.noremap { '<leader>tm', ':PreviewMarkdown<cr>' }
end

function config.glow()
end

function config.fugitive()
  local nnoremap = vim.keymap.nnoremap

  -- Stage current file
  nnoremap { '<leader>ga', ':Git add %:p<cr>' }
  vim.whichkey('<leader>ga', 'add-file')

  -- Diff current file
  nnoremap { '<leader>gd', ':Gdiffsplit<cr>' }
  vim.whichkey('<leader>gd', 'diff-this')

  -- Create a git commit from staged changes
  nnoremap { '<leader>gc', ':Git commit<cr>' }
  vim.whichkey('<leader>gc', 'create-commit')

  -- Blame each line in file
  nnoremap { '<leader>gb', ':Git blame<cr>' }
  vim.whichkey('<leader>gb', 'blame')
end

function config.messenger()

  vim.g.git_messenger_no_default_mapping = false

  -- Show commit message for current line
  vim.keymap.nnoremap { '<leader>gm', '<Plug>(git-messenger)' }
  vim.whichkey('<leader>gm', 'commit-under-cursor')
end

function config.committia()
end


function config.octo()
end

function config.gitblame()
  vim.g.gitblame_enabled = 0

  vim.keymap.nnoremap { '<leader>tg', ':GitBlameToggle<cr>', silent = true }
  vim.whichkey('<leader>tg', 'git-blame-line')
end

function config.neogit()
  require('neogit').setup()
end

return config

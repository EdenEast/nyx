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
  vim.keymap.nnoremap { '<leader>tg', ':Glow<cr>' }
end

function config.fugitive()
  local nnoremap = vim.keymap.nnoremap

  -- Stage current file
  nnoremap { '<leader>ga', ':Git add %:p<cr>' }

  -- Diff current file
  nnoremap { '<leader>gd', ':Gdiffsplit<cr>' }

  -- Create a git commit from staged changes
  nnoremap { '<leader>gc', ':Git commit<cr>' }

  -- Blame each line in file
  nnoremap { '<leader>gb', ':Git blame<cr>' }
end

function config.messenger()

  vim.g.git_messenger_no_default_mapping = false

  -- Show commit message for current line
  vim.keymap.nnoremap { '<leader>gm', '<Plug>(git-messenger)' }

end

function config.committia()
end


function config.octo()
end


return config

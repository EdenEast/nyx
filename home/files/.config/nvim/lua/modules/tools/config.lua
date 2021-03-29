local config = {}

function config.glow()
  local nmap = require('core.util').nmap

  vim.g.mkdp_auto_close = 0
  vim.g.mkdp_echo_preview_url = 1

  nmap('<leader>tp', ':MarkdownPreviewToggle<cr>')
end

function config.glow()
  local nmap = require('core.util').nmap

  nmap('<leader>tg', ':Glow<cr>')
end

function config.fugitive()
  local nmap = require('core.util').nmap

  -- Stage current file
  nmap('<leader>ga', ':Git add %:p<cr>')

  -- Diff current file
  nmap('<leader>gd', ':Gdiffsplit<cr>')

  -- Create a git commit from staged changes
  nmap('<leader>gc', ':Git commit<cr>')

  -- Blame each line in file
  nmap('<leader>gb', ':Git blame<cr>')
end

function config.messenger()
  local nmap = require('core.util').nmap

  vim.g.git_messenger_no_default_mapping = false

  -- Show commit message for current line
  nmap('<leader>gm', '<Plug>(git-messenger)')
end

function config.committia()
end


function config.octo()
end


return config

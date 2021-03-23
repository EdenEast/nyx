local use = require('packer').use

use 'tpope/vim-fugitive'
use {
  'jreybert/vimagit',
  cmd = 'Magit',
  disable = true,
}

-- Reveal the commit messenger under cursor
use {
  'rhysd/git-messenger.vim',
  cmd = {'GitMessenger'},
}

-- Better view for editing commit messages
use { 'rhysd/committia.vim', }

-- GitHub issues and PRs from Neovim
use {
  'pwntester/octo.nvim',
  cmd = {'Octo'},
  diable = true, -- TODO: configure
  config = function()
  end,
}

-- Note: Something to watch as a replacement for Magit
-- use {
--   'TimUntersberger/neogit'
-- }

local tools = {}
local conf = require('modules.tools.config')

-- Git integrations -------------------------------------------------------------------------------

-- The wrapper around git
tools['tpope/vim-fugitive'] = {
  config = conf.fugitive,
}

-- Reveal the commit messenger under cursor
tools['rhysd/git-messenger.vim'] = {
  config = conf.messenger,
  cmd = {'GitMessenger'},
}

-- Better view for editing commit messages
tools['rhysd/committia.vim'] = {
  config = conf.committia,
}

-- GitHub issues and PRs from Neovim
tools['pwntester/octo.nvim'] = {
  config = conf.octo,
  cmd = {'Octo'},
  diable = true, -- TODO: configure
}

return tools

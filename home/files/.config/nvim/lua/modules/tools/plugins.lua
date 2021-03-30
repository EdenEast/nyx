local tools = {}
local conf = require('modules.tools.config')

-- Markdown utilities -----------------------------------------------------------------------------
-- Preview markdown files in browser
tools['iamcco/markdown-preview.nvim'] = {
  run = function() vim.fn['mkdp#util#install']() end,
  ft = {'markdown', 'vimwiki'},
  cmd = { 'MarkdownPreview', 'MarkdownPreviewToggle' },
  config = conf.mkpreview,
}

tools['skanehira/preview-markdown.vim'] = {
  ft = {'markdown', 'vimwiki'},
  cmd = {'PreviewMarkdown'},
  config = conf.preview_mkdown,
}

-- Preview markdown directly in neovim
-- NOTE: Trying
tools['npxbr/glow.nvim'] = {
  -- run = function() vim.cmd([[:GlowInstall]]) end,
  ft = {'markdown', 'vimwiki'},
  cmd = {'Glow'},
  config = conf.glow,
}

tools['gyim/vim-boxdraw'] = { }

-- Editor integration for neuron: https://github.com/srid/neuron
-- Uses style of notes (https://neuron.zettel.page/zettelkasten)
tools['fiatjaf/neuron.vim'] = { }

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

-- Profiling
tools['tweekmonster/startuptime.vim'] = {
  cmd = {'StartupTime'}
}


return tools

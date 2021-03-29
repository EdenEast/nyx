local use = require('packer').use

-- Pairs
-- use 'doums/coBra'
use 'tmsvg/pear-tree'
-- use 'jiangmiao/auto-pairs'

-- Enhanced search
use 'markonm/traces.vim'

-- Switch between single-line and multiline forms of code
use 'AndrewRadev/splitjoin.vim'

-- Better whitespace stripping for Vim
use {
  'thirtythreeforty/lessspace.vim',
  config = function()
    vim.g.lessspace_normal = 0
  end
}

-- snippets
use 'honza/vim-snippets'

-- yoink
use 'svermeulen/vim-yoink'

-- editorconfig integration
use {
  'editorconfig/editorconfig-vim',
  config = function()
    vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*', 'scp://.*' }
  end
}

-- Min/Max buffer
use {
  'szw/vim-maximizer',
  config = function() vim.g.maximizer_set_default_mapping = 0 end,
  cmd = { 'MaximizerToggle' },
}

-- change root
use {
  'airblade/vim-rooter',
  config = function()
    vim.g.rooter_patterns = { '.git', '.git/', '.root', '.root/' }
  end
}

-- secure modelines
use 'ciaranm/securemodelines'
use 'dstein64/vim-startuptime'

-- use {
--   'oberblastmeister/rooter.nvim',
--   config = function()
--     local rooter = require('rooter')
--
--     rooter.set_config({
--       echo = false,
--       cd_command = 'cd',
--       patterns = {
--         '.git',
--         '.root',
--       }
--     })
--     rooter.setup()
--   end
-- }

-- Integration with chrome/firefox with firenvim
use {
  'glacambre/firenvim',
  cond = 'vim.g.started_by_firenvim',
  run = function() vim.fn['firenvim#install'](0) end,
  config = function()
    vim.o.laststatus = 0
    vim.bo.filetype = 'markdown'
  end,
}

use {
  'christoomey/vim-tmux-navigator'
}

-- Toggle terminal
use {
  'akinsho/nvim-toggleterm.lua'
}

-- Utils
use {
  'tweekmonster/helpful.vim',
  cmd = { 'HelpfulVersion' },
}

use { 'gyim/vim-boxdraw' }

-- Editor integration for neuron: https://github.com/srid/neuron
-- Uses style of notes (https://neuron.zettel.page/zettelkasten)
use { 'fiatjaf/neuron.vim' }

-- maybe?
-- use 'nanotee/zoxide.vim'

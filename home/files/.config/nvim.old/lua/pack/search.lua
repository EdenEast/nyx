local use = require('packer').use

use {
  'junegunn/fzf.vim',
  requires = {
    'junegunn/fzf',
    run = function() vim.fn['fzf#install']() end,
  },
}

-- File browser
use {
  'ptzz/lf.vim',
  requires = { 'rbgrouleff/bclose.vim' },
  cmd = { 'Lf', 'LfCurrentFile', 'LfCurrentDirectory', 'LfWorkingDirectory', },
  config = function()
    vim.g.lf_map_keys = 0
    vim.g.lf_replace_netrw = true
    vim.g.lf_command_override = 'lf -command "map e open"'
  end,
}

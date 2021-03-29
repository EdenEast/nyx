local editor = {}
local conf = require('modules.editor.config')

editor['tmsvg/pear-tree'] = {
  config = conf.peartree,
}

editor['norcalli/nvim-colorizer.lua'] = {
  ft = { 'html','css','sass','vim','typescript','typescriptreact','lua'},
  config = conf.nvim_colorizer,
}

editor['thirtythreeforty/lessspace.vim'] = {
  config = conf.lessspace,
}

editor['editorconfig/editorconfig-vim'] = {
  config = conf.editorconfig,
}

editor['glacambre/firenvim'] = {
  cond = 'vim.g.started_by_firenvim',
  run = function() vim.fn['firenvim#install'](0) end,
  config = conf.firenvim,
}

editor['airblade/vim-rooter'] = {
  config = conf.rooter,
}

editor['junegunn/fzf.vim'] = {
  config = conf.fzf,
  requires = {
    'junegunn/fzf',
    run = function() vim.fn['fzf#install']() end,
  }
}

return editor

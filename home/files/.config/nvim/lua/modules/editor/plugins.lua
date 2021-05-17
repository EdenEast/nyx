local editor = {}
local conf = require('modules.editor.config')

editor['windwp/nvim-autopairs'] = {
  config = conf.nvim_autopairs,
}

editor['norcalli/nvim-colorizer.lua'] = {
  ft = { 'html','css','sass','vim','typescript','typescriptreact','lua'},
  config = conf.nvim_colorizer,
}

editor['editorconfig/editorconfig-vim'] = {
  config = conf.editorconfig,
}

editor['kkoomen/vim-doge'] = {
  config = conf.doge,
  run = function() vim.fn['doge#install']() end,
  cmd = {'DogeGenerate'},
}

editor['glacambre/firenvim'] = {
  cond = 'vim.g.started_by_firenvim',
  run = function() vim.fn['firenvim#install'](0) end,
  config = conf.firenvim,
}

editor['airblade/vim-rooter'] = {
  config = conf.rooter,
}

editor['nvim-telescope/telescope.nvim'] = {
  config = conf.telescope,
  requires = {
    {'nvim-lua/popup.nvim', opt=true},
    {'nvim-lua/plenary.nvim', opt=true},
    {'nvim-telescope/telescope-fzy-native.nvim'},
  }
}

return editor

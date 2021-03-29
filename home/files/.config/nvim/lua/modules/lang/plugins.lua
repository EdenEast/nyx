local lang = {}
local conf = require('modules.lang.config')

lang['nvim-treesitter/nvim-treesitter'] = {
  event = 'BufRead',
  run = ':TSUpdate',
  config = conf.nvim_treesitter,
}

lang['sheerun/vim-polyglot'] = {
  config = conf.polyglot,
}

lang['pest-parser/pest.vim'] = {
  ft = { 'pest' }
}

lang['vmchale/just-vim'] = {
  ft = { 'just' }
}

return lang

local lang = {}
local conf = require('modules.lang.config')

lang['nvim-treesitter/nvim-treesitter'] = {
  event = 'BufRead',
  run = ':TSUpdate',
  config = conf.nvim_treesitter,
}

lang['nvim-treesitter/playground'] = {
  config = conf.playground,
  cmd = {'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor'},
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

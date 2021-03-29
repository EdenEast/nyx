local lang = {}
local conf = require('modules.lang.config')

lang['nvim-treesitter/nvim-treesitter'] = {
  event = 'BufRead',
  run = ':TSUpdate',
  config = conf.nvim_treesitter,
}

return lang

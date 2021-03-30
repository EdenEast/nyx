local ui = {}
local conf = require('modules.ui.config')

-- Themes -----------------------------------------------------------------------------------------

-- Treesitter supported themes
ui['glepnir/zephyr-nvim'] = { }
ui['vigoux/oak'] = { }
ui['yonlu/omni.vim'] = { }
ui['savq/melange'] = { }

-- Non treesitter supported themes
ui['arzg/vim-colors-xcode'] = { }
ui['sainnhe/gruvbox-material'] = {
  config = function()
    vim.g.gruvbox_material_background = 'medium'
  end
}

ui['mhinz/vim-startify'] = {
  cond = 'not vim.g.started_by_firenvim',
  config = conf.startify,
}

ui['glepnir/galaxyline.nvim'] = {
  config = [[require('modules.ui.galaxyline')]],
}

ui['Yggdroot/indentLine'] = {
  config = conf.indentline,
}

-- Viewer & Finder for LSP symbols and tags
ui['liuchengxu/vista.vim'] = {
  config = conf.vista,
}

ui['lewis6991/gitsigns.nvim'] = {
  event = {'BufReadPre','BufNewFile'},
  config = conf.gitsigns,
  requires = {'nvim-lua/plenary.nvim', opt=true}
}

ui['akinsho/nvim-bufferline.lua'] = {
  config = conf.bufferline,
  requires = {'kyazdani42/nvim-web-devicons'}
}

return ui

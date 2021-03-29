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

ui['Yggdroot/indentLine'] = {
  config = conf.indentline,
}

return ui

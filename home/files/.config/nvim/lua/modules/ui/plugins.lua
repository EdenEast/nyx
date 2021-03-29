local ui = {}
local conf = require('modules.ui.config')

-- Themes
ui['glepnir/zephyr-nvim'] = { }
ui['arzg/vim-colors-xcode'] = { }
ui['sainnhe/gruvbox-material'] = {
  config = function()
    vim.g.gruvbox_material_background = 'medium'
  end
}


ui['mhinz/vim-startify'] = {
  config = conf.startify
}

return ui

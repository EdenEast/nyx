local use = require('packer').use

-- Themes
use 'arzg/vim-colors-xcode'
use {
  'sainnhe/gruvbox-material',
  config = function()
    vim.g.gruvbox_material_background = 'medium'
  end,
}

use 'Yggdroot/indentLine'
use {'liuchengxu/vim-which-key', cmd = 'WhichKey'}

use 'junegunn/vim-peekaboo' -- Preview window for registers

use {
  'psliwka/vim-smoothie', -- Smooth scrolling
  config = function()
    vim.g.smoothie_base_speed = 15
  end,
}

-- Start page
use {
  'glepnir/dashboard-nvim',
  cond = 'not vim.g.started_by_firenvim',
  config = function() require'eden/dashboard'.setup() end,
  disable = true,
}
use {
  'mhinz/vim-startify',
  cond = 'not vim.g.started_by_firenvim',
}

-- Status line
use {
  'itchyny/lightline.vim',
  config = function() require'eden/lightline'.setup() end,
}


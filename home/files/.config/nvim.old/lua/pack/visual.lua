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

-- Vista
use {
  'liuchengxu/vista.vim',
  -- cmd = 'Vista',
}

-- Start page
-- use {
--   'glepnir/dashboard-nvim',
--   cond = 'not vim.g.started_by_firenvim',
--   config = function() require'eden/dashboard'.setup() end,
--   disable = true,
-- }

use {
  'mhinz/vim-startify',
  cond = 'not vim.g.started_by_firenvim',
}

-- Status line
use {
  'itchyny/lightline.vim',
  config = function() require'eden/lightline'.setup() end,
}

use {
  'akinsho/nvim-bufferline.lua',
  requires = {'kyazdani42/nvim-web-devicons'},
  config = function()
    require('bufferline').setup{
      options = {
        modified_icon = '✥',
        buffer_close_icon = 'x',
        mappings = true,
        always_show_bufferline = false,
      }
    }
  end,
}

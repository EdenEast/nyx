local use = require('packer').use
local disable_lsp = vim.g.eden_use_builtin_lsp == 0

-- Lsp configs
-- use {
--   'neovim/nvim-lspconfig',
--   config = function() require'eden/lsp'.setup() end,
--   requires = {
--     'nvim-lua/completion-nvim',
--     'nvim-lua/diagnostic-nvim',
--     'nvim-lua/lsp-status.nvim',
--     'tjdevries/lsp_extensions.nvim',
--   },
--   disable = disable_lsp,
-- }

use {
  'neoclide/coc.nvim',
  branch = 'release',
  diable = not disable_lsp,
  config = function()
    vim.g.coc_loaded = 'true'
  end
}


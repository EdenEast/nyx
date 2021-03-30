local lsp = {}
local conf = require('modules.lsp.config')

-- CoC --------------------------------------------------------------------------------------------

lsp['neoclide/coc.nvim'] = {
  disable = not vim.g.eden_nvimlsp,
  branch = 'release',
  opt = true,
}

-- Nvim Lsp ---------------------------------------------------------------------------------------

lsp['neovim/nvim-lspconfig'] = {
  disable = not vim.g.eden_nvimlsp,
  event = 'BufReadPre',
  config = conf.nvim_lsp,
}

lsp['glepnir/lspsaga.nvim'] = {
  disable = not vim.g.eden_nvimlsp,
  cmd = 'Lspsaga',
}

lsp['hrsh7th/nvim-compe'] = {
  disable = not vim.g.eden_nvimlsp,
  event = 'InsertEnter',
  config = conf.nvim_compe,
}

lsp['onsails/lspkind-nvim'] = {
  disable = not vim.g.eden_nvimlsp,
  opt = true,
}

return lsp

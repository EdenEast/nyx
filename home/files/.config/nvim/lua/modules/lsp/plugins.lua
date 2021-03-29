local lsp = {}
local conf = require('modules.lsp.config')

-- CoC --------------------------------------------------------------------------------------------

lsp['neoclide/coc.nvim'] = {
  branch = 'release',
  opt = true,
}

-- Nvim Lsp ---------------------------------------------------------------------------------------

lsp['neovim/nvim-lspconfig'] = {
  config = conf.nvim_lsp,
}

lsp['glepnir/lspsaga.nvim'] = {
  requires = {'nvim-lspconfig'},
}

lsp['hrsh7th/nvim-compe'] = {
  config = conf.nvim_compe,
  requires = {'nvim-lspconfig'},
}

lsp['onsails/lspkind-nvim'] = {
  config = [[require('lspkind').init()]],
  requires = {'nvim-lspconfig'},
}

return lsp

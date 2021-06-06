local config = {}

function config.nvim_lsp()
  require('modules.lsp.lspconfig')
end

function config.nvim_compe()
  require('modules.lsp.complete')
end

return config


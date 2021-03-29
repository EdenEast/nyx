local lsp = {}
local conf = require('modules.lsp.config')

lsp['neoclide/coc.nvim'] = {
  branch = 'release',
  opt = true,
}

return lsp

local nvim_lsp = require('nvim_lsp')
local nvim_status = require('lsp-status')
local completion = require('completion')
local diagnostic = require('diagnostic')
local status = require('eden.status')
local util = require('util')

status.activate()

local custom_on_attach = function(config)
  return function(client)
    completion.on_attach(client)
    diagnostic.on_attach(client)
    status.on_attach(client)

    -- Add rust inlay hints
    if vim.api.nvim_buf_get_option(0, 'filetype') == 'rust' then
      vim.cmd [[autocmd BufEnter,BufWritePost <buffer> :lua require('lsp_extensions.inlay_hints').request { aligned = true, prefix = " » " }]]
    end
  end
end

local servers = {
  bashls = {},
  rust_analyzer = {},
  vimls = {},
}

local function setup()
  for server, config in pairs(servers) do
    config.on_attach = custom_on_attach(config)
    config.capabilities = util.deep_extend('keep', config.capabilities or {}, nvim_status.capabilities)

    nvim_lsp[server].setup(config)
  end
end

return {
  setup = setup
}

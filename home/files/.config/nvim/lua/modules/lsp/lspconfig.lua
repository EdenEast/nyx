package.loaded['lspconfig'] = nil

local nvim_lsp = require('lspconfig')
local global = require('core.global')

local pack_add = function(packs)
  for _, pack in ipairs(packs) do
    if not packer_plugins[pack].loaded then
      vim.cmd('packadd ' .. pack)
    end
  end
end

pack_add({'lsp_extensions.nvim', 'lsp-status.nvim', 'lspkind-nvim'})

require('lspkind').init()

local status = require('modules.lsp.status')
status.activate()

local enhance_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local enhance_attach = function(client, bufnr)
  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')
  local nnoremap = vim.keymap.nnoremap
  local caps = client.resolved_capabilities

  status.on_attach(client)

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  nnoremap { 'K',  [[<cmd>lua vim.lsp.buf.hover()<cr>]], silent=true }
  nnoremap { 'gd', [[<cmd>lua vim.lsp.buf.definition()<cr>]], silent=true }
  nnoremap { 'gD', [[<cmd>lua vim.lsp.buf.declaration()<cr>]], silent=true }
  nnoremap { 'gr', [[<cmd>lua vim.lsp.buf.references()<cr>]], silent=true }
  nnoremap { 'gi', [[<cmd>lua vim.lsp.buf.implementation()<cr>]], silent=true }
  nnoremap { 'gy', [[<cmd>lua vim.lsp.buf.type_definition()<cr>]], silent=true }
  nnoremap { 'ga', [[<cmd>lua vim.lsp.buf.code_action()<cr>]], silent=true }
  nnoremap { 'gs', [[<cmd>lua vim.lsp.buf.signature_help()<cr>]], silent=true }

  nnoremap { '[e', [[<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>]], silent=true }
  vim.which_prev['e'] = 'diagnostic'
  nnoremap { ']e', [[<cmd>lua vim.lsp.diagnostic.goto_next()<cr>]], silent=true }
  vim.which_next['e'] = 'diagnostic'

  nnoremap { '<leader>ce', [[<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>]], silent=true }
  vim.which_leader['c'].e = 'list-diagnostics'

  if caps.document_formatting then
    nnoremap { '<leader>cf', [[<cmd>lua vim.lsp.buf.formatting()<cr>]], silent=true }
    vim.which_leader['c'].f = 'format'
  elseif caps.document_range_formatting then
    nnoremap { '<leader>cf', [[<cmd>lua vim.lsp.buf.range_formatting()<cr>]], silent=true }
    vim.which_leader['c'].f = 'format'
  end

  if caps.rename then
    nnoremap { '<leader>cn', [[<cmd>lua vim.lsp.buf.rename()<cr>]], silent=true }
    vim.which_leader['c'].n = 'rename'
  end

  if caps.document_highlight then
  end

  -- Rust is currently the only thing w/ inlay hints
  if filetype == 'rust' then
    vim.cmd(
      [[autocmd BufEnter,BufWritePost <buffer> :lua require('lsp_extensions.inlay_hints').request { ]]
        .. [[aligned = true, prefix = " » " ]]
      .. [[} ]]
    )
  end
end

-- Setting up for each language server
local default_lsp_config = { on_init = enhance_init, on_attach = enhance_attach, capabilities = status.capabilities }
local servers = {
  bashls = {},
  rust_analyzer = {},
  vimls = {},
}

for server, config in pairs(servers) do
  nvim_lsp[server].setup(vim.tbl_deep_extend('force', default_lsp_config, config))
end


-- Resources and references
--
-- https://github.com/tjdevries/config_manager/blob/cabdd4b/xdg_config/nvim/lua/tj/lsp/init.lua
-- https://github.com/glepnir/nvim/blob/ea9db6b/lua/modules/completion/lspconfig.lua
-- https://github.com/richban/.dotfiles/blob/cbedd1b/dotfiles/config/nvim/lua/rb/lsp/settings.lua
-- https://github.com/klooj/nvimrc-lua/blob/18fff4c/lua/ploog/lsp_config.lua
--

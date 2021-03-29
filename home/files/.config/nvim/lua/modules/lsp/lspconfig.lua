local api = vim.api
local lspconfig = require 'lspconfig'
local global = require 'core.global'

if not packer_plugins['lspsaga.nvim'].loaded then
  vim.cmd [[packadd lspsaga.nvim]]
end

local saga = require 'lspsaga'
saga.init_lsp_saga({
  code_action_icon = '💡'
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

function _G.reload_lsp()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
  vim.cmd [[edit]]
end

function _G.open_lsp_log()
  local path = vim.lsp.get_log_path()
  vim.cmd("edit " .. path)
end

vim.cmd('command! -nargs=0 LspLog call v:lua.open_lsp_log()')
vim.cmd('command! -nargs=0 LspRestart call v:lua.reload_lsp()')

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Enable underline, use default values
    underline = true,
    -- Enable virtual text, override spacing to 4
    virtual_text = true,
    signs = {
      enable = true,
      priority = 20
    },
    -- Disable a feature
    update_in_insert = false,
})

local enhance_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local enhance_attach = function(client,bufnr)
  local nnoremap = vim.keymap.nnoremap
  local xnoremap = vim.keymap.xnoremap
  local opts = { buffer = true }

  local caps = client.resolved_capabilities

  -- if caps.document_formatting then
  --   format.lsp_before_save()
  -- end

  if caps.hover then
    nnoremap { 'K', [[:Lspsaga hover_doc<CR>]], opts }
    nnoremap { '<c-f>', [[:lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>]], opts }
    nnoremap { '<c-b>', [[:lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>]], opts }
  end

  if caps.signature_help then
    nnoremap { 'gs', [[<Cmd>Lspsaga signature_help<CR>]], opts }
  end

  if caps.find_references then
    nnoremap { 'gr', [[<cmd>Lspsaga lsp_finder<cr>]], opts }
  end

  if caps.code_action then
    nnoremap { 'ga', [[<cmd>Lspsaga code_action<cr>]], opts }
    xnoremap { 'ga', [[<cmd>Lspsaga range_code_action<cr>]], opts }
  end

  if caps.rename then
    nnoremap { '<Leader>cr', [[<Cmd>Lspsaga rename<CR>]], opts }
  end

  if caps.goto_definition then
    nnoremap { 'gd', [[<Cmd>Lspsaga preview_definition<CR>]], opts }
  end

  if caps.type_definition then
    nnoremap { 'gy', [[<Cmd>lua vim.lsp.buf.type_definition()<CR>]], opts }
  end

  if caps.implementation then
    nnoremap { 'gi', [[<Cmd>lua vim.lsp.buf.implementation()<CR>]], opts }
  end

  -- Diagnostics are prob always avalible
  nnoremap { '<Leader>ce', [[<Cmd>Lspsaga show_line_diagnostics<CR>]], opts }
  nnoremap { ']e', [[<Cmd>Lspsaga diagnostic_jump_next<CR>]], opts }
  nnoremap { '[e', [[<Cmd>Lspsaga diagnostic_jump_prev<CR>]], opts }

  api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Rust is currently the only thing w/ inlay hints
  if filetype == 'rust' then
    vim.cmd(
      [[autocmd BufEnter,BufWritePost <buffer> :lua require('lsp_extensions.inlay_hints').request { ]]
        .. [[aligned = true, prefix = " » " ]]
      .. [[} ]]
    )
  end
end

local servers = {
  'bashls','pyright','rust_analyzer'
}

for _,server in ipairs(servers) do
  lspconfig[server].setup {
    on_attach = enhance_attach;
    on_init = enhance_init;
  }
end

-- References
-- https://github.com/vim-save/dotfile/blob/f3b8653d9d144ead46a03e9de5ad28af4d9cd2c6/nvim/.config/nvim/lua/modules/completion/lspconfig.lua
-- https://github.com/YaBoiBurner/dotfiles/blob/88e37bad68be58da160dc89eeecaee6e7eacaedb/.config/nvim/lua/user/cfg/lspsettings.lua

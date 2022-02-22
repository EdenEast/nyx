local pack = require("eden.core.pack")
local path = require("eden.core.path")
local nlsp = require("lspconfig")
local remaps = require("eden.modules.protocol.lsp.remaps")
local filetype_attach = require("eden.modules.protocol.lsp.filetypes")

local premod = "eden.modules.protocol.lsp."
require(premod .. "cosmetics")
require(premod .. "handlers")

local status = require("eden.modules.protocol.lsp.status")
status.activate(false)
require("fidget").setup({text = { spinner = "dots_negative" }})

vim.opt.updatetime = 300

local function on_init(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local function on_attach(client, bufnr)
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")

  remaps.set(client, bufnr)

  status.on_attach(client)
  require("lsp_signature").on_attach({})

  filetype_attach[filetype](client)

  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  if client.resolved_capabilities.document_formatting then
    -- TODO: edn.au and edn.aug support buffer
    vim.cmd([[
      augroup LspAutoFormatting
        autocmd!
        autocmd BufWritePre <buffer> lua require('eden.modules.protocol.lsp.extensions.format').format()
      augroup END
    ]])
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("keep", capabilities, status.capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Packadding cmp-nvim-lsp if not added yet and updating capabilities
vim.cmd("packadd cmp-nvim-lsp")
local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
  capabilities = cmp_lsp.update_capabilities(capabilities)
end

-- Server setup ----------------------------------------------------------------
--
-- A note on my setup for language servers. I use nix to manage my dotfiles. This
-- also make it easy to install the required language servers. See
--   `home/modules/shell/neovim.nix` on this nix module that controls my neovim
-- deployment. Because windows is awful and does not support nix I have setup
-- `nvim-lsp-installer`. This makes installing language servers on windows sane.

local installer = require("nvim-lsp-installer")
installer.settings({
  log_level = vim.log.levels.DEBUG,
  ui = {
    icons = {
      server_installed = "",
      server_pending = "",
      server_uninstalled = "",
    },
  },
})

local installed = {}
for _, v in ipairs(installer.get_installed_servers()) do
  installed[v.name] = v
end

local servers = { "bashls", "cmake", "elmls", "gopls", "pyright", "rnix", "rust_analyzer", "vimls" }
local modlist = path.modlist(pack.modname .. ".protocol.lsp.servers")
for _, mod in ipairs(modlist) do
  local name = mod:match("servers.(.+)$")
  servers[name] = require(mod)
end

local default = { on_init = on_init, on_attach = on_attach, capabilities = capabilities }

local function basic_options(config, _, opts)
  return vim.tbl_deep_extend("force", config, opts)
end

-- Setup servers in the server list
for k, v in pairs(servers) do
  local is_basic = type(k) == "number"
  local name = is_basic and v or k
  local func = is_basic and basic_options or v["setup"]
  local opts = installed[name] and installed[name]._default_options or {}
  local config = func(vim.deepcopy(default), on_attach, opts)
  nlsp[name].setup(config)
  installed[name] = nil
end

-- Setup any installed servers that are not in the server list
for _, server in pairs(installed) do
  server:setup({})
end

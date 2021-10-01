local pack = require("eden.core.pack")
local path = require("eden.core.path")
local nlsp = require("lspconfig")
local remaps = require("eden.modules.protocol.lsp.remaps")
local filetype_attach = require("eden.modules.protocol.lsp.filetypes")

local premod = "eden.modules.protocol.lsp."
require(premod .. "cosmetics")
require(premod .. "handlers")

local status = require("eden.modules.protocol.lsp.status")
status.activate()

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
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("keep", capabilities, status.capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

local default = { on_init = on_init, on_attach = on_attach, capabilities = capabilities }
local ext = edn.platform.is_windows and ".cmd" or ""

local simple_servers = {
  bashls = { cmd = { "bash-language-server" .. ext, "start" } },
  cmake = { cmd = { "cmake-language-server" .. ext } },
  elmls = { cmd = { "elm-language-server" .. ext } },
  gopls = {},
  pyright = {},
  rnix = {},
  rust_analyzer = { cmd = { "rust-analyzer" .. ext } },
  tsserver = {},
  vimls = {},
}

for server, config in pairs(simple_servers) do
  nlsp[server].setup(vim.tbl_deep_extend("force", default, config))
end

local modname = pack.modname .. ".protocol.lsp.servers"
local modlist = path.modlist(modname)
for _, mod in ipairs(modlist) do
  local name = mod:match("servers.(.+)$")
  nlsp[name].setup(require(mod).setup(vim.deepcopy(default)))
end

local lspsync = require("lspsync")
lspsync.init({
  install_root = edn.path.join(edn.path.cachehome, "lspsync"),
})

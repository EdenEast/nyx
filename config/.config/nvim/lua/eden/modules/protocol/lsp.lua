local pack = require("eden.core.pack")
local path = require("eden.core.path")
local nlsp = require("lspconfig")

require("lspkind")
require("lspsaga").init_lsp_saga()

local status = require("eden.modules.protocol.status")
status.activate()

local function on_init(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local function on_attach(client, bufnr)
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")

  status.on_attach(client)
  require("lsp_signature").on_attach()

  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  if filetype == "rust" then
    -- TODO: eden.au needs to support buffer
    vim.cmd(
      [[autocmd BufEnter,BufWritePost <buffer> :lua require('lsp_extensions.inlay_hints').request { ]]
        .. [[aligned = true, prefix = " » " ]]
        .. [[} ]]
    )
  end

  -- Keymaps ------------------------------------------------------------------
  edn.keymap({
    buffer = true,
    {
      { "K", [[<cmd>lua require('lspsaga.hover').render_hover_doc()<cr>]] },
      { "<c-f>", [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>]] },
      { "<c-b>", [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>]] },

      { "<c-s>", [[<cmd>lua vim.lsp.buf.signature_help()<cr>]], mode = "i" },
      { "gD", [[<cmd>lua vim.lsp.buf.declaration()<cr>]] },
      { "gi", [[<cmd>lua vim.lsp.buf.implementation()<cr>]] },
      { "gy", [[<cmd>lua vim.lsp.buf.type_definition()<cr>]] },
      { "ga", [[<cmd>lua require('lspsaga.codeaction').code_action()<cr>]] },

      { "[e", [[<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>]] },
      { "]e", [[<cmd>lua vim.lsp.diagnostic.goto_next()<cr>]] },

      { "<leader>cn", [[<cmd>lua require('lspsaga.rename').rename()<cr>]] },
      { "<leader>ca", [[<cmd>lua require('lspsaga.codeaction').code_action()<cr>]] },
      { "<leader>ca", [[:<c-u><cmd>lua require('lspsaga.codeaction').range_code_action()<cr>]], mode = "v" },

      { "gd", [[<cmd>Telescope lsp_definitions<cr>]] },
      { "gr", [[<cmd>Telescope lsp_references<cr>]] },
      { "<leader>ce", [[<cmd>Telescope lsp_workspace_diagnostics<cr>]] },
    },
  })
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

local modname = pack.modname .. ".protocol.servers"
local modlist = path.get_mod_list(modname)
for _, mod in ipairs(modlist) do
  local name = mod:match("servers.(.+)$")
  nlsp[name].setup(require(mod).setup(vim.deepcopy(default)))
end

local lspsync = require("lspsync")
lspsync.init({
  install_root = edn.path.join(edn.path.cachehome, "lspsync"),
})

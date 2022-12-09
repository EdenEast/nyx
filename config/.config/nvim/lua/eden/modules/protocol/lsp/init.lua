require("eden.lib.defer").immediate_load({
  "mason.nvim",
  "lsp_signature.nvim",
  "fidget.nvim",
  "lsp_lines.nvim",
  "lsp-inlayhints.nvim",
})

local pack = require("eden.core.pack")
local path = require("eden.core.path")
local nlsp = require("lspconfig")
local remaps = require("eden.modules.protocol.lsp.remaps")
local filetype_attach = require("eden.modules.protocol.lsp.filetypes")

local premod = "eden.modules.protocol.lsp."
require(premod .. "cosmetics")
require(premod .. "handlers")

require("fidget").setup({
  fmt = {
    stack_upwards = false,
  },
  text = {
    spinner = "dots_negative",
  },
  window = {
    blend = 0,
  },
})

vim.opt.updatetime = 300

require("lsp-inlayhints").setup({ -- « »
  inlay_hints = {
    max_len_align = true,
    parameter_hints = {
      prefix = "« ",
    },
    type_hints = {
      prefix = "» ",
    },
    -- max_len_align = true,
  },
})

local function on_init(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local function on_attach(client, bufnr)
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")

  remaps.set(client, bufnr)

  require("lsp_signature").on_attach({})
  require("lsp-inlayhints").on_attach(client, bufnr)

  filetype_attach[filetype](client)

  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  if client.server_capabilities.documentFormattingProvider then
    augroup("LspAutoFormatting", {
      event = "BufWritePre",
      buffer = true,
      exec = function()
        require("eden.modules.protocol.lsp.extensions.format").format()
      end,
    })
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Packadding cmp-nvim-lsp if not added yet and updating capabilities
vim.cmd("packadd cmp-nvim-lsp")
local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
  capabilities = cmp_lsp.default_capabilities()
end

-- Server setup ----------------------------------------------------------------
--
-- A note on my setup for language servers. I use nix to manage my dotfiles. This
-- also make it easy to install the required language servers. See
--   `home/modules/shell/neovim.nix` on this nix module that controls my neovim
-- deployment. Because windows is awful and does not support nix I have setup
-- `mason`. This makes installing language servers on windows sane.

require("mason").setup({
  install_root_dir = path.join(path.cachehome, "mason"),
})

-- Map installed package list to table by name
local mason_lspconfig_map = {
  ["lua-language-server"] = "sumneko_lua",
}

local registry = require("mason-registry")
local installed = {}
for _, v in ipairs(registry.get_installed_packages()) do
  local name = mason_lspconfig_map[v.name] and mason_lspconfig_map[v.name] or v.name
  installed[name] = v
end

local servers = { "bashls", "cmake", "elmls", "gopls", "omnisharp", "pyright", "rnix", "vimls" }
local modlist = require("eden.lib.modlist").getmodlist(pack.modname .. ".protocol.lsp.servers")
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
for name, server in pairs(installed) do
  local s = nlsp[name]
  if s then
    s.setup(server._default_options or {})
  end
end

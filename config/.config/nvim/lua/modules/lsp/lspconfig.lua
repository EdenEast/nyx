package.loaded["lspconfig"] = nil

local nvim_lsp = require("lspconfig")
local global = require("core.global")
local path = require("core.path")
local has_tscope, _ = pcall(require, "telescope")

require("lspkind").init()

local saga = require("lspsaga")
saga.init_lsp_saga({})

local status = require("modules.lsp.status")
status.activate()

local enhance_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local sig_config = {}

local enhance_attach = function(client, bufnr)
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  local nnoremap = vim.keymap.nnoremap
  local vnoremap = vim.keymap.vnoremap
  local inoremap = vim.keymap.inoremap
  local caps = client.resolved_capabilities

  status.on_attach(client)
  require("lsp_signature").on_attach(sig_config)

  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  nnoremap({ "K", [[<cmd>lua require('lspsaga.hover').render_hover_doc()<cr>]], silent = true })
  nnoremap({ "<c-f>", [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>]], silent = true })
  nnoremap({ "<c-b>", [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>]], silent = true })

  inoremap({ "<c-s>", [[<cmd>lua vim.lsp.buf.signature_help()<cr>]], silent = true })
  nnoremap({ "gD", [[<cmd>lua vim.lsp.buf.declaration()<cr>]], silent = true })
  nnoremap({ "gi", [[<cmd>lua vim.lsp.buf.implementation()<cr>]], silent = true })
  nnoremap({ "gy", [[<cmd>lua vim.lsp.buf.type_definition()<cr>]], silent = true })
  nnoremap({ "ga", [[<cmd>lua require('lspsaga.codeaction').code_action()<cr>]], silent = true })

  if has_tscope then
    nnoremap({ "gd", [[<cmd>Telescope lsp_definitions<cr>]], silent = true })
    nnoremap({ "gr", [[<cmd>Telescope lsp_references<cr>]], silent = true })
  else
    nnoremap({ "gd", [[<cmd>lua vim.lsp.buf.definition()<cr>]], silent = true })
    nnoremap({ "gr", [[<cmd>lua vim.lsp.buf.references()<cr>]], silent = true })
  end

  nnoremap({ "[e", [[<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>]], silent = true })
  nnoremap({ "]e", [[<cmd>lua vim.lsp.diagnostic.goto_next()<cr>]], silent = true })

  if has_tscope then
    nnoremap({ "<leader>ce", [[<cmd>Telescope lsp_workspace_diagnostics<cr>]], silent = true })
  else
    nnoremap({ "<leader>ce", [[<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>]], silent = true })
  end

  if caps.document_formatting then
    vim.cmd([[
      augroup !LSPFormatOnSave
        autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync()
      augroup END
    ]])
  end
  -- if caps.document_formatting then
  --   nnoremap({ "<leader>cf", [[<cmd>lua vim.lsp.buf.formatting()<cr>]], silent = true })
  -- elseif caps.document_range_formatting then
  --   nnoremap({ "<leader>cf", [[<cmd>lua vim.lsp.buf.range_formatting()<cr>]], silent = true })
  -- end

  if caps.rename then
    nnoremap({ "<leader>cn", [[<cmd>lua require('lspsaga.rename').rename()<cr>]], silent = true })
  end

  nnoremap({ "<leader>ca", [[<cmd>lua require('lspsaga.codeaction').code_action()<cr>]], silent = true })
  vnoremap({ "<leader>ca", [[:<c-u><cmd>lua require('lspsaga.codeaction').range_code_action()<cr>]], silent = true })

  -- if caps.document_highlight then
  -- end

  -- Rust is currently the only thing w/ inlay hints
  if filetype == "rust" then
    vim.cmd(
      [[autocmd BufEnter,BufWritePost <buffer> :lua require('lsp_extensions.inlay_hints').request { ]]
        .. [[aligned = true, prefix = " » " ]]
        .. [[} ]]
    )
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.window = capabilities.window or {}
capabilities.window.workDoneProgress = true

local shellcheck = require("modules.lsp.efm.shellcheck")
local shfmt = require("modules.lsp.efm.shfmt")
local efm_langs = {
  sh = { shfmt, shellcheck },
}

-- Setting up for each language server
local default_lsp_config = { on_init = enhance_init, on_attach = enhance_attach, capabilities = capabilities }
local ext = global.is_windows and ".cmd" or ""
local pid = vim.fn.getpid()
local servers = {
  bashls = { cmd = { "bash-language-server" .. ext, "start" } },
  clangd = {
    cmd = {
      "clangd" .. ext,
      "--background-index",
      "--suggest-missing-includes",
      "--clang-tidy",
      "--header-insertion=iwyu",
    },
  },
  cmake = { cmd = { "cmake-language-server" .. ext } },
  efm = {
    init_options = { documentFormatting = true },
    filetypes = vim.tbl_keys(efm_langs),
    settings = {
      languages = efm_langs,
    },
  },
  elmls = { cmd = { "elm-language-server" .. ext } },
  gopls = {},
  omnisharp = { cmd = { "omnisharp" .. ext, "--languageserver", "--hostPID", tostring(pid) } },
  pyright = {},
  rnix = {},
  rust_analyzer = { cmd = { "rust-analyzer" .. ext } },
  sumneko_lua = {
    cmd = { "lua-language-server" .. ext },
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Setup your lua path
          path = vim.split(package.path, ";"),
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim", "P" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          },
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  },
  tsserver = {},
  vimls = {},
}

for server, config in pairs(servers) do
  nvim_lsp[server].setup(vim.tbl_deep_extend("force", default_lsp_config, config))
end

local lspsync = require("lspsync")
lspsync.init({
  install_root = path.join(global.cachehome, "lspsync"),
})

-- Resources and references
--
-- https://github.com/tjdevries/config_manager/blob/cabdd4b/xdg_config/nvim/lua/tj/lsp/init.lua
-- https://github.com/glepnir/nvim/blob/ea9db6b/lua/modules/completion/lspconfig.lua
-- https://github.com/richban/.dotfiles/blob/cbedd1b/dotfiles/config/nvim/lua/rb/lsp/settings.lua
-- https://github.com/klooj/nvimrc-lua/blob/18fff4c/lua/ploog/lsp_config.lua
--

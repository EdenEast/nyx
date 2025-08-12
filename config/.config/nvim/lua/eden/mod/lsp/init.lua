local Path = require("eden.core.path")

local function on_attach(attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("eden_lsp_attach", { clear = true }),
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      attach(client, buffer)
    end,
  })
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "lvimuser/lsp-inlayhints.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      -- diagnostics
      for name, icon in pairs(require("eden.util.icons").diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
      })

      -- on attach
      on_attach(function(client, buffer)
        require("eden.mod.lsp.keymaps").on_attach(client, buffer)
        require("eden.mod.lsp.inlayhints").on_attach(client, buffer)
      end)

      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      capabilities.experimental = { localDocs = true } -- Enable local docs for rust-analyzer

      local lua_runtimepath = vim.split(package.path, ";")
      table.insert(lua_runtimepath, "lua/?.lua")
      table.insert(lua_runtimepath, "lua/?/init.lua")

      local servers = {
        bashls = {},
        clangd = {},
        rust_analyzer = {
          commands = {
            RustOpenDocs = {
              function()
                -- https://sourcegraph.com/github.com/dmitmel/dotfiles/-/blob/nvim/dotfiles/lspconfigs/rust.lua?L189-191
                -- https://sourcegraph.com/github.com/mrcjkb/rustaceanvim/-/blob/lua/rustaceanvim/commands/external_docs.lua
                vim.lsp.buf_request(
                  0,
                  "experimental/externalDocs",
                  vim.lsp.util.make_position_params(),
                  function(_, response)
                    if response then
                      local url = response["local"] and response["local"]
                        or response["web"] and response["web"]
                        or response
                      vim.ui.open(url)
                    end
                  end
                )
              end,
              description = "Open documentation for the symbol under the cursor in default browser",
            },
          },
          settings = {
            ["rust-analyzer"] = {
              files = {
                excludeDirs = {
                  "./.direnv/",
                  "./.git/",
                  "./.github/",
                  "./.gitlab/",
                  "./node_modules/",
                  "./ci/",
                  "./docs/",
                },
              },
              diagnostics = {
                experimental = {
                  enable = true,
                },
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Setup your lua path
                path = lua_runtimepath,
              },
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim", "P", "edn" },
              },
              format = {
                enable = false,
              },
              workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              -- Do not send telemetry data containing a randomized but unique identifier
              telemetry = {
                enable = false,
              },
            },
          },
        },
        nixd = {},
        pyright = {},
        vimls = {},
      }

      local mlsp = require("mason-lspconfig")
      local mason_installed_servers = mlsp.get_installed_servers()

      local nlsp = require("lspconfig")
      local function setup(server)
        local opts = servers[server] or {}
        opts.capabilities = capabilities
        nlsp[server].setup(opts)
      end

      for server, _ in pairs(servers) do
        if not vim.tbl_contains(mason_installed_servers, server) then setup(server) end
      end

      mlsp.setup_handlers({ setup })
    end,
  },

  -- formatters
{
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  keys = {
    {
      "<leader>uf",
      function()
        vim.g.autoformat = not vim.g.autoformat
        vim.notify("Autoformat: " .. (vim.g.autoformat and "Enable" or "Disable"), vim.log.levels.INFO)
      end,
      desc = "Toggle Autoformat",
    },
  },
  before = function()
    -- Use conform for gq.
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    vim.g.autoformat = true
  end,
  config = function()
    require("conform").setup({
      notify_on_error = false,
      default_format_opts = {
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        c = { name = "clangd", timeout_ms = 500, lsp_format = "prefer" },
        javascript = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        javascriptreact = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        json = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        jsonc = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        less = { "prettier" },
        lua = { "stylua", lsp_format = "fallback" },
        markdown = { "prettier" },
        nix = { "alejandra", "nixfmt", stop_after_first = true },
        rust = { name = "rust_analyzer", timeout_ms = 500, lsp_format = "prefer" },
        scss = { "prettier" },
        sh = { "shfmt" },
        typescript = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        typescriptreact = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        -- For filetypes without a formatter:
        ["_"] = { "trim_whitespace", "trim_newlines" },
      },
      format_on_save = function(bufnr)
        if vim.g.skip_autoformat then
          vim.g.skip_autoformat = false
          return nil
        end

        -- Stop if we disabled auto-formatting.
        if not vim.g.autoformat then return nil end

        return { timeout_ms = 500 }
      end,
    })
  end,
},

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    config = function(_, opts)
      require("mason").setup({
        install_root_dir = Path.join(Path.cachehome, "mason"),
        registries = {
          "github:mason-org/mason-registry",
          "lua:mason-registry.index",
        },
      })
    end,
  },
}

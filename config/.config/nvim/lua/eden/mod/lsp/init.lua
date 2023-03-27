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

      -- inlay hints
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

      -- on attach
      on_attach(function(client, buffer)
        require("eden.mod.lsp.format").on_attach(client, buffer)
        require("eden.mod.lsp.keymaps").on_attach(client, buffer)
        require("lsp-inlayhints").on_attach(client, buffer)
        -- TODO: lsp signature
      end)

      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local lua_runtimepath = vim.split(package.path, ";")
      table.insert(lua_runtimepath, "lua/?.lua")
      table.insert(lua_runtimepath, "lua/?/init.lua")

      local servers = {
        bashls = {},
        rust_analyzer = {
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
        rnix = {},
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
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim", "nvim-lua/plenary.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          nls.builtins.formatting.fish_indent,
          nls.builtins.diagnostics.fish,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.shfmt,
        },
      }
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

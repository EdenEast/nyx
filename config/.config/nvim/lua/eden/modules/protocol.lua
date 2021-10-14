local dev = require("eden.core.pack").dev

local M = {}

M.plugins = {
  -- Language Servers ---------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("eden.modules.protocol.lsp")
    end,
    requires = {
      "nvim-lua/lsp_extensions.nvim",
      "ray-x/lsp_signature.nvim",
      "nvim-lua/lsp-status.nvim",
    },
  },

  {
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
  },

  { dev("EdenEast/nvim-lspsync") },

  -- Debug Adaptor ------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("eden.modules.protocol.dap")
    end,
    requires = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "jbyuki/one-small-step-for-vimkind",
    },
  },

  -- Treesitter ---------------------------------------------------------------
  {
    {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("eden.modules.protocol.treesitter")
      end,
      requires = {
        { "romgrk/nvim-treesitter-context", opt = true, disabled = not edn.platform.is_windows },
        { "JoosepAlviste/nvim-ts-context-commentstring", opt = true },
        { "nvim-treesitter/nvim-treesitter-textobjects", opt = true },
      },
    },
    {
      "nvim-treesitter/playground",
      cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    },
    {
      "code-biscuits/nvim-biscuits",
      after = "nvim-treesitter",
      config = function()
        require("nvim-biscuits").setup({
          cursor_line_only = true,
        })
        edn.keymap("<leader>tb", function()
          require("nvim-biscuits").toggle_biscuits()
        end)
      end,
    },
  },
}

return M

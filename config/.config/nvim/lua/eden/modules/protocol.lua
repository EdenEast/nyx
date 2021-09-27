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
      "glepnir/lspsaga.nvim",
      "onsails/lspkind-nvim",
      "ray-x/lsp_signature.nvim",
      "nvim-lua/lsp-status.nvim",
    },
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
}

return M

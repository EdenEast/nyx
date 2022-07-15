local M = {}

M.plugins = {
  -- Language Servers ---------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opt = true,
    setup = function()
      require("eden.lib.defer").add("nvim-lspconfig", 80)
    end,
    conf = "protocol.lsp",
    requires = {
      { "williamboman/nvim-lsp-installer", opt = true },
      { "ray-x/lsp_signature.nvim", opt = true },
      { "j-hui/fidget.nvim", opt = true },
    },
  },

  {
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
  },

  -- Debug Adaptor ------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    opt = true,
    setup = function()
      require("eden.lib.defer").add("nvim-dap", 20)
    end,
    conf = "protocol.dap",
    requires = {
      { "rcarriga/nvim-dap-ui", opt = true },
      { "theHamsta/nvim-dap-virtual-text", opt = true },
      { "jbyuki/one-small-step-for-vimkind", opt = true },
    },
  },

  -- Treesitter ---------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opt = true,
    setup = function()
      require("eden.lib.defer").add("nvim-treesitter", 100)
    end,
    conf = "protocol.treesitter",
    run = ":TSUpdate",
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
}

return M

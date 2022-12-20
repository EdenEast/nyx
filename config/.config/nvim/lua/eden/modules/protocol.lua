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
      { "williamboman/mason.nvim", opt = true },
      -- { "williamboman/nvim-lsp-installer", opt = true },
      { "ray-x/lsp_signature.nvim", opt = true },
      { "j-hui/fidget.nvim", opt = true },
      { "Maan2003/lsp_lines.nvim", opt = true },
      { "lvimuser/lsp-inlayhints.nvim", opt = true },
      { "jose-elias-alvarez/null-ls.nvim", opt = true },
    },
  },

  {
    "Hoffs/omnisharp-extended-lsp.nvim",
    opt = true,
    setup = function()
      require("eden.lib.defer").register("omnisharp_extended", "omnisharp-extended-lsp.nvim")
    end,
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
    conf = "protocol.treesitter",
    requires = {
      { "romgrk/nvim-treesitter-context", opt = true, disabled = not edn.platform.is.win },
      { "JoosepAlviste/nvim-ts-context-commentstring", opt = true },
      { "nvim-treesitter/nvim-treesitter-textobjects", opt = true },
    },
  },

  {
    "nvim-treesitter/playground",
    config = function()
      nmap("gh", function()
        require("nvim-treesitter-playground.hl-info").show_hl_captures()
      end)
    end,
    cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    keys = { "gh" },
  },
}

return M

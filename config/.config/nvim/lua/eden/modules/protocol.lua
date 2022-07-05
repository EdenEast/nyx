local M = {}

M.plugins = {
  -- Language Servers ---------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opt = true,
    setup = function()
      require("eden.lib.defer").add("nvim-lspconfig", 50)
    end,
    config = function()
      require("eden.modules.protocol.lsp")
    end,
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
    config = function()
      require("eden.modules.protocol.dap")
    end,
    requires = {
      { "theHamsta/nvim-dap-virtual-text", opts = true },
      { "rcarriga/nvim-dap-ui", opts = true },
      { "jbyuki/one-small-step-for-vimkind", opts = true },
    },
  },

  -- Treesitter ---------------------------------------------------------------
  {
    {
      "nvim-treesitter/nvim-treesitter",
      opt = true,
      setup = function()
        require("eden.lib.defer").add("nvim-treesitter", 100)
      end,
      run = ":TSUpdate",
      config = function()
        require("eden.modules.protocol.treesitter")
      end,
      requires = {
        { "romgrk/nvim-treesitter-context", opt = true, disabled = not edn.platform.is_windows },
        { "JoosepAlviste/nvim-ts-context-commentstring", opt = true },
        { "nvim-treesitter/nvim-treesitter-textobjects", opt = true },
        { "windwp/nvim-ts-autotag", opt = true },
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

        nmap("<leader>tb", function()
          require("nvim-biscuits").toggle_biscuits()
        end, { desc = "Biscuits" })
      end,
    },
  },
}

M.before = function()
  -- Stub command to load dap with packer
  command("DapLoad", "")
end

return M

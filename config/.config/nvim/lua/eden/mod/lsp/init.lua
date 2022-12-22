return {
  "neovim/nvim-lspconfig",
  name = "lsp",
  event = "BufReadPre",
  config = function()
    require("eden.mod.lsp.setup")
  end,
  dependencies = {
    "williamboman/mason.nvim",
    "ray-x/lsp_signature.nvim",
    "j-hui/fidget.nvim",
    "Maan2003/lsp_lines.nvim",
    "lvimuser/lsp-inlayhints.nvim",
    { "jose-elias-alvarez/null-ls.nvim", dependencies = "nvim-lua/plenary.nvim" },
  },
}

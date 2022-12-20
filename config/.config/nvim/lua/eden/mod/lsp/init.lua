local M = {
  "neovim/nvim-lspconfig",
  name = "lsp",
  event = "VeryLazy",
  dependencies = {
    "williamboman/mason.nvim",
    "ray-x/lsp_signature.nvim",
    "j-hui/fidget.nvim",
    "Maan2003/lsp_lines.nvim",
    "lvimuser/lsp-inlayhints.nvim",
    { "jose-elias-alvarez/null-ls.nvim", dependencies = "nvim-lua/plenary.nvim" },
  },
}

-- TODO: Move module config to here
M.config = function()
  require("eden.modules.protocol.lsp")
end

return M

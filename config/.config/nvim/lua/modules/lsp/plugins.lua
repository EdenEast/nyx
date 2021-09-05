local lsp = {}
local load = require("core.pack").local_load

-- Nvim Lsp ---------------------------------------------------------------------------------------

lsp["neovim/nvim-lspconfig"] = {
  config = [[require("modules.lsp.lspconfig")]],
  requires = {
    "nvim-lua/lsp_extensions.nvim",
    "glepnir/lspsaga.nvim",
    "onsails/lspkind-nvim",
    "ray-x/lsp_signature.nvim",
  },
}

lsp["hrsh7th/nvim-compe"] = {
  event = "InsertEnter",
  config = [[require("modules.lsp.complete")]],
  requires = {
    { "hrsh7th/vim-vsnip", opt = true },
    { "hrsh7th/vim-vsnip-integ", opt = true },
    { "rafamadriz/friendly-snippets", opt = true },
  },
}

lsp[load("EdenEast/nvim-lspsync")] = {}

return lsp

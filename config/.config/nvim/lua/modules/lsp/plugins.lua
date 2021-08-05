local lsp = {}
local conf = require("modules.lsp.config")
local pack = require("core.pack")

-- Nvim Lsp ---------------------------------------------------------------------------------------

lsp["neovim/nvim-lspconfig"] = {
  config = conf.nvim_lsp,
  requires = {
    "nvim-lua/lsp_extensions.nvim",
    "glepnir/lspsaga.nvim",
    "onsails/lspkind-nvim",
    "ray-x/lsp_signature.nvim",
  },
}

lsp["hrsh7th/nvim-compe"] = {
  event = "InsertEnter",
  config = conf.nvim_compe,
  requires = {
    { "hrsh7th/vim-vsnip", opt = true },
    { "hrsh7th/vim-vsnip-integ", opt = true },
    { "rafamadriz/friendly-snippets", opt = true },
  },
}

local lspsync = pack.local_load("EdenEast/nvim-lspsync")
lsp[lspsync] = {}

return lsp

local lsp = {}
local conf = require("modules.lsp.config")
local pack = require("core.pack")

-- CoC --------------------------------------------------------------------------------------------

lsp["neoclide/coc.nvim"] = {
  disable = not vim.g.eden_nvimlsp,
  branch = "release",
  opt = true,
}

-- Nvim Lsp ---------------------------------------------------------------------------------------

lsp["neovim/nvim-lspconfig"] = {
  disable = not vim.g.eden_nvimlsp,
  config = conf.nvim_lsp,
  requires = {
    "nvim-lua/lsp_extensions.nvim",
    "glepnir/lspsaga.nvim",
    "onsails/lspkind-nvim",
    "ray-x/lsp_signature.nvim",
  },
}

lsp["hrsh7th/nvim-compe"] = {
  disable = not vim.g.eden_nvimlsp,
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

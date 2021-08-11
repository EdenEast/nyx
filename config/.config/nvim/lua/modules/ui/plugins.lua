local ui = {}
local conf = require("modules.ui.config")
local load = require("core.pack").local_load

-- Themes -----------------------------------------------------------------------------------------

-- Treesitter supported themes
ui[load("EdenEast/nightfox.nvim")] = {}
ui["embark-theme/vim"] = {}
ui["folke/tokyonight.nvim"] = {}
ui["eddyekofo94/gruvbox-flat.nvim"] = {}

ui["glepnir/dashboard-nvim"] = {
  config = conf.dashboard,
  cond = "not vim.g.started_by_firenvim",
}

ui["hoob3rt/lualine.nvim"] = {
  config = [[require('modules.ui.lualine')]],
  requires = { "nvim-lua/lsp-status.nvim" },
}

ui["folke/which-key.nvim"] = {
  config = [[require('modules.ui.whichkey')]],
}

ui["Yggdroot/indentLine"] = {
  config = conf.indentline,
}

ui["lewis6991/gitsigns.nvim"] = {
  event = { "BufReadPre", "BufNewFile" },
  config = conf.gitsigns,
  requires = { "nvim-lua/plenary.nvim" },
}

ui["akinsho/nvim-bufferline.lua"] = {
  disable = true,
  config = conf.bufferline,
  requires = { "kyazdani42/nvim-web-devicons" },
}

ui["kyazdani42/nvim-tree.lua"] = {
  config = conf.nvim_tree,
  requires = { "kyazdani42/nvim-web-devicons" },
  cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFindFile" },
  keys = { "<leader>te" },
}

ui["folke/zen-mode.nvim"] = {
  config = conf.zenmode,
}

return ui

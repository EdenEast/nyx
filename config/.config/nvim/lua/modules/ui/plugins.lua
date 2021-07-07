local ui = {}
local conf = require("modules.ui.config")

-- Themes -----------------------------------------------------------------------------------------

-- Treesitter supported themes
ui["cocopon/iceberg.vim"] = {}
ui["embark-theme/vim"] = {}
ui["folke/tokyonight.nvim"] = {}
ui["glepnir/zephyr-nvim"] = {}
ui["vigoux/oak"] = {}
ui["wojciechkepka/bogster"] = {}
ui["sainnhe/gruvbox-material"] = {
  config = function()
    vim.g.gruvbox_material_background = "medium"
  end,
}

-- Non treesitter supported themes
ui["arzg/vim-colors-xcode"] = {}

ui["glepnir/dashboard-nvim"] = {
  config = conf.dashboard,
  cond = "not vim.g.started_by_firenvim",
}

ui["glepnir/galaxyline.nvim"] = {
  config = [[require('modules.ui.galaxyline')]],
}

ui["folke/which-key.nvim"] = {
  config = [[require('modules.ui.whichkey')]],
}

ui["Yggdroot/indentLine"] = {
  config = conf.indentline,
}

-- Viewer & Finder for LSP symbols and tags
ui["liuchengxu/vista.vim"] = {
  config = conf.vista,
}

ui["lewis6991/gitsigns.nvim"] = {
  event = { "BufReadPre", "BufNewFile" },
  config = conf.gitsigns,
  requires = { "nvim-lua/plenary.nvim" },
}

ui["akinsho/nvim-bufferline.lua"] = {
  config = conf.bufferline,
  requires = { "kyazdani42/nvim-web-devicons" },
}

ui["kyazdani42/nvim-tree.lua"] = {
  config = conf.nvim_tree,
  requires = { "kyazdani42/nvim-web-devicons" },
  -- NOTE: Currently there is an issue with the ordering of whichkey and opt loading on cmd.
  -- WhichKey will load before this one will register and not showup.
  -- Have to find a solution.
  -- cmd = {'NvimTreeToggle', 'NvimTreeOpen', 'NvimTreeFindFile'},
}

return ui

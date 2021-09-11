local editor = {}
local conf = require("modules.editor.config")

editor["windwp/nvim-autopairs"] = {
  config = conf.nvim_autopairs,
}

editor["norcalli/nvim-colorizer.lua"] = {
  ft = { "html", "css", "sass", "vim", "typescript", "typescriptreact", "lua" },
  config = conf.nvim_colorizer,
}

editor["editorconfig/editorconfig-vim"] = {
  config = conf.editorconfig,
}

editor["kkoomen/vim-doge"] = {
  config = conf.doge,
  run = function()
    vim.fn["doge#install"]()
  end,
  cmd = { "DogeGenerate" },
}

editor["glacambre/firenvim"] = {
  cond = "vim.g.started_by_firenvim",
  run = function()
    vim.fn["firenvim#install"](0)
  end,
  config = conf.firenvim,
}

editor["airblade/vim-rooter"] = {
  config = conf.rooter,
}

editor["windwp/nvim-spectre"] = {
  config = conf.spectre,
  cmd = { "Spectre" },
  requires = {
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
  },
}

editor["nvim-telescope/telescope.nvim"] = {
  config = [[require('modules.editor.telescope')]],
  requires = {
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzy-native.nvim" },
  },
}

editor["folke/trouble.nvim"] = {
  config = [[require('modules.editor.trouble')]],
  requires = "kyazdani42/nvim-web-devicons",
}

editor["akinsho/nvim-toggleterm.lua"] = {
  config = [[require('modules.editor.toggleterm')]],
}

editor["ojroques/nvim-bufdel"] = {
  config = conf.bufdel,
}

-- Because emacs has it why cant neovim
editor["alec-gibson/nvim-tetris"] = {
  cmd = { "Tetris" },
}

editor["mfussenegger/nvim-dap"] = {
  config = [[require("modules.editor.debug")]],
  requires = {
    "nvim-telescope/telescope-dap.nvim",
    "theHamsta/nvim-dap-virtual-text",
    "rcarriga/nvim-dap-ui",
    "jbyuki/one-small-step-for-vimkind",
  },
}

return editor

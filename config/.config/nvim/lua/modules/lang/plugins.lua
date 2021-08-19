local lang = {}
local conf = require("modules.lang.config")

lang["nvim-treesitter/nvim-treesitter"] = {
  event = "BufRead",
  run = ":TSUpdate",
  config = [[require('modules.lang.treesitter')]],
  requires = {
    { "romgrk/nvim-treesitter-context", opt = true, disabled = not require("core.global").is_windows },
    { "JoosepAlviste/nvim-ts-context-commentstring", opt = true },
    { "nvim-treesitter/nvim-treesitter-textobjects", opt = true },
  },
}

lang["nvim-treesitter/playground"] = {
  config = conf.playground,
  cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
}

lang["kristijanhusak/orgmode.nvim"] = {
  config = conf.orgmode,
  ft = { "org" },
}

lang["pest-parser/pest.vim"] = {
  ft = { "pest" },
}

lang["NoahTheDuke/vim-just"] = {
  ft = { "just" },
}

lang["plasticboy/vim-markdown"] = {
  config = conf.markdown,
  ft = { "markdown" },
}

lang["axvr/org.vim"] = {
  ft = { "org" },
}

return lang

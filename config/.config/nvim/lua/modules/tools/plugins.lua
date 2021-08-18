local tools = {}
local conf = require("modules.tools.config")

-- Markdown utilities -----------------------------------------------------------------------------
-- Preview markdown files in browser
tools["iamcco/markdown-preview.nvim"] = {
  run = function()
    vim.fn["mkdp#util#install"]()
  end,
  ft = { "markdown", "vimwiki" },
  cmd = { "MarkdownPreview", "MarkdownPreviewToggle" },
  config = conf.mkpreview,
}

-- Git integrations -------------------------------------------------------------------------------
-- The wrapper around git
tools["tpope/vim-fugitive"] = {
  config = conf.fugitive,
}

-- Reveal the commit messenger under cursor
tools["rhysd/git-messenger.vim"] = {
  config = conf.messenger,
  cmd = { "GitMessenger" },
}

-- Better view for editing commit messages
tools["rhysd/committia.vim"] = {
  config = conf.committia,
}

-- GitHub issues and PRs from Neovim
tools["pwntester/octo.nvim"] = {
  config = conf.octo,
  cmd = { "Octo" },
  diable = true, -- TODO: configure
}

tools["sindrets/diffview.nvim"] = {
  config = conf.diffview,
}

-- Show git blame in virtual text like git-lens in vscode
tools["f-person/git-blame.nvim"] = {
  config = conf.gitblame,
}

-- TODO: This is a WIP magit replacement written in lua for neovim. Watch this space
tools["TimUntersberger/neogit"] = {
  config = conf.neogit,
  requires = { "nvim-lua/plenary.nvim" },
}

tools["AndrewRadev/linediff.vim"] = {
  config = function()
    vim.keymap.nnoremap({ "<leader>gp", [[<cmd>LinediffPick<cr>]] })
  end,
  cmd = { "LinediffPick" },
  keys = { "<leader>gp" },
}

-- Profiling
tools["tweekmonster/startuptime.vim"] = {
  cmd = { "StartupTime" },
}

-- Tmux integration
tools["christoomey/vim-tmux-navigator"] = {}

return tools

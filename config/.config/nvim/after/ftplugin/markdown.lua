vim.opt_local.conceallevel = 0
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.spell = true
vim.opt_local.tabstop = 2
vim.opt_local.textwidth = 120

vim.opt_local.spell = true
vim.opt_local.spelllang = { "en_us" }

require("cmp").setup.buffer({
  sources = {
    { name = "luasnip" },
    { name = "path" },
    { name = "emoji" },
    { name = "spell" },
  },
})

vim.keymap.set("n", "<localleader>p", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Preview", buffer = true })

-- Idea: using pandoc you can have a preview on save locally without a preview plugin
-- example https://github.com/chreekat/dotfiles/blob/7030a04ede63520c68660fd20c858f28e0c50b26/vim/after/ftplugin/markdown.vim

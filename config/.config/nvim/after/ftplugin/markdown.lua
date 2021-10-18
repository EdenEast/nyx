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
    { name = "buffer" },
    { name = "path" },
    { name = "emoji" },
    { name = "spell" },
  },
})

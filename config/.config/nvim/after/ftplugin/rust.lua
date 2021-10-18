vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = true

--  Vim ftplugin sets `o` ... why? I dont want!
vim.opt_local.formatoptions:remove("o")

require("cmp").setup.buffer({
  sources = {
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
    { name = "emoji" },
    { name = "spell" },
  },
})

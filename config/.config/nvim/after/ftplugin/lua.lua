vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

-- Vim ftplugin sets `o` ... why? I dont want!
vim.opt_local.formatoptions:remove("o")

require("cmp").setup.buffer({
  sources = {
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "treesitter" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer", opts = {
      get_bufnr = function()
        return vim.api.nvim_list_bufs()
      end,
    } },
  },
})

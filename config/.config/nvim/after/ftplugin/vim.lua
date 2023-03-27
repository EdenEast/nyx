-- if has('conceal')
--   vim.opt_local.concealcursor=nc

--   " Fragile hack to stop indentLine plug-in from overwriting this back to "inc".
--   let b:indentLine_ConcealOptionSet = 1
-- endif

vim.opt_local.iskeyword:remove("#")

vim.opt_local.foldmethod = "marker"
vim.opt_local.foldlevel = 0
vim.opt_local.foldcolumn = "1"

vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

-- Vim ftplugin sets `o` ... why? I dont want!
vim.opt_local.formatoptions:remove("o")

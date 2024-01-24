vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

-- make compiler cargo
vim.cmd("compiler nix")

vim.keymap.set("n", "<localleader>c", "<cmd>make flake check<cr>", { desc = "Check" })
vim.keymap.set("n", "<localleader>b", "<cmd>make build<cr>", { desc = "Build" })

-- Use single line comments for comment motions
vim.opt_local.commentstring = "# %s"

vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = true

--  Vim ftplugin sets `o` ... why? I dont want!
vim.opt_local.formatoptions:remove("o")

-- make compiler cargo
vim.cmd("compiler cargo")

-- Make quickfix window show up automatically after compiling
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "[^l]*",
  command = "cwindow",
  nested = true,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "l*",
  command = "lwindow",
  nested = true,
})

vim.keymap.set("n", "<leader>mt", "<cmd>make test -q<cr>", { desc = "Cargo test" })
vim.keymap.set("n", "<leader>mb", "<cmd>make build<cr>", { desc = "Cargo build" })
vim.keymap.set("n", "<leader>mc", "<cmd>make clippy -q<cr>", { desc = "Cargo clippy" })

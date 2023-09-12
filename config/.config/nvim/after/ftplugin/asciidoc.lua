-- local function open_in_browser()
--   print("trying to open browser")
--   require("eden.util").open_url(vim.api.nvim_buf_get_name(0))
-- end

vim.keymap.set("n", "<localleader>p", [[<cmd>AsciiDocPreview<cr>]], { desc = "Preview", buffer = true })
vim.opt_local.commentstring = "// %s"

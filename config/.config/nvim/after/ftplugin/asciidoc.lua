-- local function open_in_browser()
--   print("trying to open browser")
--   require("eden.util").open_url(vim.api.nvim_buf_get_name(0))
-- end

vim.keymap.set(
  "n",
  "<localleader>p",
  [[<cmd>lua require('eden.util').open_file_in_browser()<cr>]],
  { desc = "Preview" }
)

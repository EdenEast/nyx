local hydra = require("hydra")

hydra({
  name = "Window Management",
  mode = "n",
  body = "<c-w>",
  heads = {
    -- Move focus
    { "h", "<C-w>h" },
    { "j", "<C-w>j" },
    { "k", "<C-w>k" },
    { "l", "<C-w>l" },
    -- Move window
    { "H", "<C-w>H" },
    { "J", "<C-w>J" },
    { "K", "<C-w>K" },
    { "L", "<C-w>L" },
    -- Split
    { "s", "<C-w>s" },
    { "v", "<C-w>v" },
    { "q", "<Cmd>try | close | catch | endtry<CR>", { desc = "close window" } },
    -- Size
    { "+", "<C-w>+" },
    { "-", "<C-w>-" },
    { ">", "2<C-w>>", { desc = "increase width" } },
    { "<", "2<C-w><", { desc = "decrease width" } },
    { "=", "<C-w>=", { desc = "equalize" } },
    { "<Esc>", nil, { exit = true } },
  },
})

require("cmp").setup.buffer({
  { name = "crates" },
  { name = "path" },
  { name = "buffer", opts = {
    get_bufnr = function()
      return vim.api.nvim_list_bufs()
    end,
  } },
})

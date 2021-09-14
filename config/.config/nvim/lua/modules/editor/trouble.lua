local trouble = require("trouble")

trouble.setup()

vim.keymap({
  "<leader>x",
  {
    { "x", [[<cmd>TroubleToggle<cr>]] },
    { "w", [[<cmd>TroubleToggle lsp_workspace_diagnostics<cr>]] },
    { "d", [[<cmd>TroubleToggle lsp_document_diagnostics<cr>]] },
    { "l", [[<cmd>TroubleToggle locallist<cr>]] },
    { "q", [[<cmd>TroubleToggle quickfix<cr>]] },
  },
})

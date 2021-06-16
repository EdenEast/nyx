local trouble = require("trouble")
local nnoremap = vim.keymap.nnoremap

trouble.setup()

nnoremap { '<leader>xx', [[<cmd>TroubleToggle<cr>]], silent = true }
nnoremap { '<leader>xw', [[<cmd>TroubleToggle lsp_workspace_diagnostics<cr>]], silent = true }
nnoremap { '<leader>xd', [[<cmd>TroubleToggle lsp_document_diagnostics<cr>]], silent = true }
nnoremap { '<leader>xl', [[<cmd>TroubleToggle locallist<cr>]], silent = true }
nnoremap { '<leader>xq', [[<cmd>TroubleToggle quickfix<cr>]], silent = true }


local trouble = require("trouble")

trouble.setup()

nmap("<leader>xx", [[<cmd>TroubleToggle<cr>]])
nmap("<leader>xw", [[<cmd>TroubleToggle lsp_workspace_diagnostics<cr>]])
nmap("<leader>xd", [[<cmd>TroubleToggle lsp_document_diagnostics<cr>]])
nmap("<leader>xl", [[<cmd>TroubleToggle locallist<cr>]])
nmap("<leader>xq", [[<cmd>TroubleToggle quickfix<cr>]])

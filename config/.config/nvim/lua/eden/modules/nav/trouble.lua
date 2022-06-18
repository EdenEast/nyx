local trouble = require("trouble")

trouble.setup()

nmap("<leader>xx", [[<cmd>TroubleToggle<cr>]], { desc = "Toggle trouble" })
nmap("<leader>xw", [[<cmd>TroubleToggle lsp_workspace_diagnostics<cr>]], { desc = "Workspace diagnostics" })
nmap("<leader>xd", [[<cmd>TroubleToggle lsp_document_diagnostics<cr>]], { desc = "Document diagnostics" })
nmap("<leader>xl", [[<cmd>TroubleToggle locallist<cr>]], { desc = "Local list" })
nmap("<leader>xq", [[<cmd>TroubleToggle quickfix<cr>]], { desc = "Quickfix list" })

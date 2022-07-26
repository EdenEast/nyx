local sign = vim.fn.sign_define

-- stylua: ignore
sign("DiagnosticSignError", { text = "ﰸ ", texthl = "DiagnosticError", linehl = "NONE" })
sign("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticWarn", linehl = "NONE" })
sign("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticInfo", linehl = "NONE" })
sign("DiagnosticSignHint", { text = " ", texthl = "DiagnosticHint", linehl = "NONE" })

require("lsp_lines").setup()
require("eden.modules.protocol.lsp.extensions.virtual_lines").init()

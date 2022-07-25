local sign = vim.fn.sign_define

-- stylua: ignore
sign("DiagnosticSignError", { text = "ﰸ ", texthl = "DiagnosticError", linehl = "NONE" })
sign("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticWarn", linehl = "NONE" })
sign("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticInfo", linehl = "NONE" })
sign("DiagnosticSignHint", { text = " ", texthl = "DiagnosticHint", linehl = "NONE" })

require("lsp_lines").setup()

vim.diagnostic.config({
  virtual_lines = true, -- lsp_lines
  virtual_text = false, -- disable default virtual text
  -- virtual_text = { spacing = 2, prefix = "❰" },
})

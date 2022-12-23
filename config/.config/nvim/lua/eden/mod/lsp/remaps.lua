local M = {}

M.set = function(client, bufnr)
  local opts = { buffer = true }

  imap("<c-s>", function()
    vim.lsp.buf.signature_help()
  end, opts)

  nmap("K", function()
    vim.lsp.buf.hover()
  end, opts)

  nmap("gd", function()
    require("eden.mod.telescope.extension").lsp_definitions()
  end, { buffer = true, desc = "Definitions" })

  nmap("gr", function()
    require("eden.mod.telescope.extension").lsp_references()
  end, { buffer = true, desc = "References" })

  nmap("gD", function()
    vim.lsp.buf.declaration()
  end, { buffer = true, desc = "Declaration" })

  nmap("gi", function()
    vim.lsp.buf.implementation()
  end, { buffer = true, desc = "Implementation" })

  nmap("gy", function()
    vim.lsp.buf.type_definition()
  end, { buffer = true, desc = "Type definition" })

  nmap("ga", function()
    vim.lsp.buf.code_action()
  end, { buffer = true, desc = "Code action" })

  nmap("[e", function()
    vim.diagnostic.goto_prev()
  end, { buffer = true, desc = "Preveous diagnostic" })

  nmap("]e", function()
    vim.diagnostic.goto_next()
  end, { buffer = true, desc = "Next diagnostic" })

  nmap("<leader>ce", function()
    require("eden.mod.telescope.extension").diagnostics()
  end, { buffer = true, desc = "Workspace diagnostics" })

  nmap("<leader>cf", function()
    require("eden.mod.lsp.extensions.format").format()
  end, { buffer = true, desc = "Format code" })

  nmap("<leader>tcf", function()
    require("eden.mod.lsp.extensions.format").toggle_format()
  end, { buffer = true, desc = "Format code" })

  nmap("<leader>cn", function()
    vim.lsp.buf.rename()
  end, { buffer = true, desc = "Rename" })
end

return M

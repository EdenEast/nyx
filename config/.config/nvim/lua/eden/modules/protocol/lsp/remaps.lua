local M = {}

M.set = function(client, bufnr)
  local opts = { buffer = true }

  imap("<c-s>", function()
    vim.lsp.buf.signature_help()
  end, opts)

  nmap("K", function()
    vim.lsp.buf.hover()
  end, opts)

  nmap("gd", "<cmd>Telescope lsp_definitions<cr>", opts)
  nmap("gr", "<cmd>Telescope lsp_references<cr>", opts)

  nmap("gD", function()
    vim.lsp.buf.declaration()
  end, opts)

  nmap("gi", function()
    vim.lsp.buf.implementation()
  end, opts)

  nmap("gy", function()
    vim.lsp.buf.type_definition()
  end, opts)

  nmap("ga", [[<cmd>CodeActionMenu<cr>]], opts)

  nmap("[e", function()
    vim.diagnostic.goto_prev()
  end, { buffer = true, desc = "Preveous diagnostic" })

  nmap("]e", function()
    vim.diagnostic.goto_next()
  end, { buffer = true, desc = "Next diagnostic" })

  nmap(
    "<leader>ce",
    [[<cmd>Telescope lsp_workspace_diagnostics<cr>]],
    { buffer = true, desc = "Workspace diagnostics" }
  )

  nmap("<leader>cf", function()
    require("eden.modules.protocol.lsp.extensions.format").format()
  end, { buffer = true, desc = "Format code" })

  nmap("<leader>tcf", function()
    require("eden.modules.protocol.lsp.extensions.format").toggle_format()
  end, { buffer = true, desc = "Format code" })

  nmap("<leader>cn", function()
    vim.lsp.buf.rename()
  end, { buffer = true, desc = "Rename"})
end

return M

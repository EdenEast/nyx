local M = {}

M.set = function(client, bufnr)
  edn.keymap({
    buffer = true,
    {
      {
        "K",
        function()
          vim.lsp.buf.hover()
        end,
      },
      {
        "<c-s>",
        function()
          vim.lsp.buf.signature_help()
        end,
        mde = "i",
      },
      { "gd", [[<cmd>Telescope lsp_definitions<cr>]] },
      { "gr", [[<cmd>Telescope lsp_references<cr>]] },
      {
        "gD",
        function()
          vim.lsp.buf.declaration()
        end,
      },
      {
        "gi",
        function()
          vim.lsp.buf.implementation()
        end,
      },
      {
        "gy",
        function()
          vim.lsp.buf.type_definition()
        end,
      },
      { "ga", [[<cmd>CodeActionMenu<cr>]], mode = "nv" },
      {
        "[e",
        function()
          vim.diagnostic.goto_prev()
        end,
      },
      {
        "]e",
        function()
          vim.diagnostic.goto_next()
        end,
      },
      { "<leader>ce", [[<cmd>Telescope lsp_workspace_diagnostics<cr>]] },
      {
        "<leader>cf",
        function()
          vim.lsp.buf.formatting()
        end,
      },
      {
        "<leader>cn",
        function()
          vim.lsp.buf.rename()
        end,
      },
    },
  })
end

return M

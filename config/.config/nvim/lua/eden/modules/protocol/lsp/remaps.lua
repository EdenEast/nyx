local M = {}

M.set = function(client, bufnr)
  edn.keymap({
    buffer = true,
    {
      { "K", [[<cmd>lua require('lspsaga.hover').render_hover_doc()<cr>]] },
      { "<c-f>", [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>]] },
      { "<c-b>", [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>]] },

      { "<c-s>", [[<cmd>lua vim.lsp.buf.signature_help()<cr>]], mode = "i" },
      { "gD", [[<cmd>lua vim.lsp.buf.declaration()<cr>]] },
      { "gi", [[<cmd>lua vim.lsp.buf.implementation()<cr>]] },
      { "gy", [[<cmd>lua vim.lsp.buf.type_definition()<cr>]] },
      { "ga", [[<cmd>lua require('lspsaga.codeaction').code_action()<cr>]] },

      { "[e", [[<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>]] },
      { "]e", [[<cmd>lua vim.lsp.diagnostic.goto_next()<cr>]] },

      { "<leader>cn", [[<cmd>lua require('lspsaga.rename').rename()<cr>]] },
      -- { "<leader>ca", [[<cmd>lua require('lspsaga.codeaction').code_action()<cr>]] },
      -- { "<leader>ca", [[:<c-u><cmd>lua require('lspsaga.codeaction').range_code_action()<cr>]], mode = "v" },
      { "<leader>ca", [[<cmd>CodeActionMenu<cr>]], mode = "nv" },

      { "gd", [[<cmd>Telescope lsp_definitions<cr>]] },
      { "gr", [[<cmd>Telescope lsp_references<cr>]] },
      { "<leader>ce", [[<cmd>Telescope lsp_workspace_diagnostics<cr>]] },
    },
  })
end

return M

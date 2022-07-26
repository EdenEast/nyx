local M = {
  should_show = true,
  show_vt_lines = false,
  virtual_text = { spacing = 2, prefix = "❰" },
}

function M.init()
  M.apply()
  nmap("<leader>tv", function()
    require("eden.modules.protocol.lsp.extensions.virtual_lines").toggle_lines()
  end, { desc = "Virtual lines" })
  nmap("<leader>tV", function()
    require("eden.modules.protocol.lsp.extensions.virtual_lines").toggle()
  end, { desc = "Virtual text" })
end

function M.toggle_lines()
  M.show_vt_lines = not M.show_vt_lines
  M.apply()
end

function M.toggle()
  M.should_show = not M.should_show
  M.apply()
end

function M.apply()
  if not M.should_show then
    vim.diagnostic.config({
      virtual_lines = false,
      virtual_text = false,
    })
    return
  end

  vim.diagnostic.config({
    virtual_lines = M.show_vt_lines, -- lsp_lines
    virtual_text = not M.show_vt_lines and M.virtual_text or false,
  })
end

return M

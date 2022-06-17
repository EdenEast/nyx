local M = {}

M.should_format = true

M.toggle_format = function()
  M.should_format = not M.should_format
end

M.format = function()
  if M.should_format then
    vim.lsp.buf.formatting_sync()
  end
end

return M

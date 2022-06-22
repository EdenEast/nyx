local M = {
  should_format = true,
  ft_filters = {}
}

---Toggles formatting
M.toggle_format = function()
  M.should_format = not M.should_format
end

---Add filter function to filetype
---@param filetype string
---@param filter table
---@param force boolean|nil
M.add_ft_filter = function(filetype, filter, force)
  force = force or false
  if force or M.ft_filters[filetype] == nil then
      M.ft_filters[filetype] = filter
  end
end

---Format buffer synchronously
M.format = function()
  if M.should_format then
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  local filter = M.ft_filters[filetype]
    vim.lsp.buf.format({ async = false, filter = filter})
  end
end

return M

local function generate()
  local list = {}
  if vim.bo.readonly then table.insert(list, "🔒") end

  if vim.bo.modified then table.insert(list, "●") end

  table.insert(list, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:."))

  return [[%=]] .. table.concat(list, " ")
end

return { generate = generate }

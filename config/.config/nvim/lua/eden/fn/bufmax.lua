local M = {}

M.original_winid = nil
M.maximized_winid = nil

M.toggle = function()
  local num_windows = vim.api.nvim_eval([[winnr("$")]])
  if num_windows > 1 then
    if M.original_winid ~= nil then
      vim.api.nvim_set_current_win(M.original_winid)
    else
      M.original_winid = vim.api.nvim_get_current_win()
      vim.cmd([[tab sp]])
      M.maximized_winid = vim.api.nvim_get_current_win()
    end
  else
    if M.original_winid ~= nil then
      vim.cmd([[tabclose]])
      vim.api.nvim_set_current_win(M.original_winid)
      M.original_winid = nil
      M.maximized_winid = nil
    end
  end
end

return M

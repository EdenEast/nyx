local M = {}

function M.open_in_browser()
  local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:.")
  local line, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local cmd = { "gh", "browse", filename .. ":" .. line }

  local jobid = vim.fn.jobstart(cmd)
  vim.fn.jobwait({ jobid })
end

return M

local M = {}

local pid = vim.fn.getpid()

M.setup = function(config)
  local ext = edn.platform.is_windows and ".cmd" or ""
  config.cmd = { "omnisharp" .. ext, "--languageserver", "--hostPID", tostring(pid) }

  return config
end

return M

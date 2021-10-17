local M = {}

local pid = vim.fn.getpid()

M.setup = function(config, opts)
  local cmd = {
    "omnisharp",
    "--languageserver",
    "--hostPID",
    tostring(pid),
  }

  config.cmd = opts.cmd and opts.cmd or cmd
  return config
end

return M

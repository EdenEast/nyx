local lsp = require("lspconfig")

local M = {}

local pid = vim.fn.getpid()

M.setup = function(config, _, opts)
  -- local cmd = {
  --   "omnisharp",
  --   "--languageserver",
  --   "--hostPID",
  --   tostring(pid),
  -- }

  -- config.cmd = opts.cmd and opts.cmd or cmd
  -- config.root_dir = opts.root and opts.root or lsp.util.root_pattern(".csproj", ".sln")
  return config
end

return M

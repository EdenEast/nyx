local M = {}

M.setup = function(config, _, opts)
  local clangd = opts.cmd and opts.cmd or "clangd"
  local cmd = {
    clangd,
    "--background-index",
    "--suggest-missing-includes",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--offset-encoding=utf-16",
  }

  config.cmd = cmd
  return config
end

return M

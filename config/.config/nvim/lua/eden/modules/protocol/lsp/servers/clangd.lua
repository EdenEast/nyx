local M = {}

M.setup = function(config)
  local ext = edn.platform.is_windows and ".cmd" or ""
  config.cmd = {
    "clangd" .. ext,
    "--background-index",
    "--suggest-missing-includes",
    "--clang-tidy",
    "--header-insertion=iwyu",
  }

  return config
end

return M

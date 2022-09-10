local nlsp = require("lspconfig")

local M = {}

M.setup = function(config, on_attach, opts)
  config.cmd = { "rust-analyzer" } -- nix installed wraps all of the comamnd line args needed
  config.settings = {
    ["rust-analyzer"] = {
      files = {
        excludeDirs = {
          "./.direnv/",
          "./.git/",
          "./.github/",
          "./.gitlab/",
          "./node_modules/",
          "./ci/",
          "./docs/",
        },
      },
    },
  }

  return config
end

return M

local M = {}

local shfmt = {
  formatCommand = "shfmt -ci -i 2 -s",
  formatStdin = true,
}

local shellcheck = {
  lintCommand = "shellcheck -f gcc -x",
  lintSource = "shellcheck",
  lintFormats = {
    "%f:%l:%c: %tarning: %m",
    "%f:%l:%c: %trror: %m",
    "%f:%l:%c: %tote: %m",
  },
}

local eslint = {
  rootMarkers = { "package.json" },
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true,
}

local prettier = {
  rootMarkers = { "package.json" },
  formatCommand = [[prettierd "${INPUT}"]],
  -- formatCommand = (function()
  --   local is_local = not vim.fn.empty(vim.loop.cwd() .. "/node_modules/.bin/prettier")
  --   local cmd = is_local and "./node_modules/.bin/prettier" or "prettier"

  --   return cmd .. " --stdin-filepath ${INPUT}"
  -- end)(),
  formatStdin = true,
}

local stylua = {
  rootMarkers = { "stylua.toml" },
  formatCommand = "stylua -s -",
  formatStdin = true,
}

M.setup = function(config, on_attach, opts)
  if opts.cmd then
    config.cmd = opts.cmd
  end

  config.init_options = { documentFormatting = true }
  config.on_attach = function(client, bufnr)
    client.resolved_capabilities.rename = false
    on_attach(client, bufnr)
  end

  config.settings = {
    languages = {
      sh = { shfmt, shellcheck },
      lua = { stylua },
      javascript = { eslint, prettier },
      javascriptreact = { eslint, prettier },
      typescript = { eslint, prettier },
      typescriptreact = { eslint, prettier },
      html = { prettier },
      css = { prettier },
      json = { prettier },
      yaml = { prettier },
      markdown = { prettier },
    },
  }

  config.filetypes = vim.tbl_keys(config.settings.languages)

  return config
end

return M

-- https://github.com/FotiadisM/nvim-lua-setup/blob/8c8994a/lua/lsp/servers/efm.lua

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

M.setup = function(config)
  config.init_options = { documentFormatting = true }

  config.filetypes = {
    "sh",
  }

  config.settings = {
    languages = {
      sh = { shfmt, shellcheck },
    },
  }

  return config
end

return M

-- https://github.com/FotiadisM/nvim-lua-setup/blob/8c8994a/lua/lsp/servers/efm.lua

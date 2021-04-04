local config = {}

function config.nvim_treesitter()
  vim.api.nvim_command('set foldmethod=expr')
  vim.api.nvim_command('set foldexpr=nvim_treesitter#foldexpr()')
  require'nvim-treesitter.configs'.setup {
      highlight = {
        enable = true,
      },
      textobjects = {
        select = {
          enable = true,
          -- keymaps = {
          --   ["af"] = "@function.outer",
          --   ["if"] = "@function.inner",
          --   ["ac"] = "@class.outer",
          --   ["ic"] = "@class.inner",
          -- },
        },
      },
    ensure_installed = {
      'go',
      'rust',
      'toml',
      'bash',
      'c',
      'c_sharp',
      'comment',
      'json',
      'lua',
      'nix',
      'python',
    }
  }
end

return config

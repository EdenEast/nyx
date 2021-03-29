local config = {}

function config.nvim_treesitter()
 vim.api.nvim_command('set foldmethod=expr')
 vim.api.nvim_command('set foldexpr=nvim_treesitter#foldexpr()')

  -- Setting clang as the compiler to use as pre this solution
  -- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support#troubleshooting
  -- NOTE: Had issues with clang and nix installed build-essentials and gcc and it works
  require 'nvim-treesitter.install'.compilers = { 'gcc', 'clang', 'cl' }
  require 'nvim-treesitter.configs'.setup {
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
      'bash',
      'c',
      'c_sharp',
      'comment',
      'cpp',
      'go',
      'json',
      'lua',
      'nix',
      'python',
      'regex',
      'rust',
      'toml',
      'typescript',
    }
  }
end

return config

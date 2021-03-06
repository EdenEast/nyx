local config = {}

function config.nvim_treesitter()
  vim.cmd [[packadd nvim-treesitter-context]]

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
    playground = {
      enable = true,
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = {"BufWrite", "CursorHold"},
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
      'query',
      'regex',
      'rust',
      'toml',
      'typescript',
    },
  }

  require'treesitter-context.config'.setup()
end

function config.polyglot()
  vim.g.vim_markdown_folding_disabled = 1
  vim.g.vim_markdown_override_foldtext = 0
  vim.g.vim_markdown_no_default_key_mappings = 1
  vim.g.vim_markdown_conceal = 0
  vim.g.vim_markdown_conceal_code_blocks = 0
  vim.g.vim_markdown_formatter = 1
  vim.g.vim_markdown_frontmatter = 1
  vim.g.vim_markdown_toml_frontmatter = 1
  vim.g.vim_markdown_yaml_frontmatter = 1
  vim.g.vim_markdown_json_frontmatter = 1
  vim.g.vim_markdown_strikethrough = 1

  vim.g.rustfmt_autosave = 1
  vim.g.rustfmt_emit_files = 1
  vim.g.rustfmt_fail_silently = 0
end

return config

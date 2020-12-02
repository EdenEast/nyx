local use = require('packer').use

-- polyglot
use {
  'sheerun/vim-polyglot',
  config = function()
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
}

-- Markdown with preview
use {
  'iamcco/markdown-preview.nvim',
  run = function() vim.fn['mkdp#util#install']() end,
  ft = {'markdown', 'vimwiki'},
  cmd = { 'MarkdownPreview', 'MarkdownPreviewToggle' },
  config = {
    function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_echo_preview_url = 1
    end,
  }
}

-- Extend rust syntax support
use {
  'arzg/vim-rust-syntax-ext',
  ft = { 'rust' }
}

-- rust pest file
use {
  'pest-parser/pest.vim',
  ft = { 'pest' }
}

-- Just file
use {
  'vmchale/just-vim',
  ft = { 'just' }
}

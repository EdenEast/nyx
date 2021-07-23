local config = {}

function config.orgmode()
  require("orgmode").setup()
end

function config.markdown()
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

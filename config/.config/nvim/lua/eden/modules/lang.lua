local M = {}

M.plugins = {
  { "pest-parser/pest.vim", ft = { "pest" } },
  { "NoahTheDuke/vim-just", ft = { "just" } },
  { "plasticboy/vim-markdown", ft = { "markdown" } },
  {
    "kristijanhusak/orgmode.nvim",
    ft = { "org" },
    config = function()
      require("orgmode").setup()
    end,
  },
  { "Saecki/crates.nvim", ft = { "rust", "toml" } },
}

M.before = function()
  -- for plasticboy/markdown
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

  -- for rust.vim and ployglot
  vim.g.rustfmt_autosave = 1
  vim.g.rustfmt_emit_files = 1
  vim.g.rustfmt_fail_silently = 0
end

return M

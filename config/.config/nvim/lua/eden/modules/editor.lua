local M = {}

M.plugins = {
  {
    "editorconfig/editorconfig-vim",
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        patterns = { ".git", ".hg", ".root" },
        ignore_lsp = { "efm" },
        -- TODO: Not working
        -- datapath = path.cachehome,
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt", "vim" },
        enable_check_bracket_line = true,
      })
    end,
  },
  {
    "akinsho/nvim-toggleterm.lua",
    config = function()
      require("eden.modules.editor.toggleterm")
    end,
  },
  {
    "ojroques/nvim-bufdel",
    config = function()
      require("bufdel").setup({
        next = "alternate",
        quit = false,
      })

      edn.keymap("<leader>bq", [[<cmd>BufDel<cr>]])
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = { "markdown", "vimwiki" },
    cmd = { "MarkdownPreview", "MarkdownPreviewToggle" },
    config = function()
      edn.keymap("<leader>tp", ":MarkdownPreviewToggle<cr>")
    end,
  },
}

M.before = function()
  -- Editorconfig
  vim.g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*" }

  -- Markdown preview
  vim.g.mkdp_auto_close = 0
  vim.g.mkdp_echo_preview_url = 1
end

return M

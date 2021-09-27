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
}

M.before = function()
  vim.g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*" }
end

return M

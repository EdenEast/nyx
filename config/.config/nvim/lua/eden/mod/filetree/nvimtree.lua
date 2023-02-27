return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      update_focused_file = {
        enable = true,
      },
      renderer = {
        add_trailing = true,
        group_empty = true,
        highlight_git = true,
        icons = {
          glyphs = {
            default = "",
            symlink = "",
            git = {
              unstaged = "✚",
              staged = "✚",
              unmerged = "≠",
              renamed = "≫",
              untracked = "★",
            },
          },
        },
      },
      view = {
        mappings = {
          list = {
            { key = "l", action = "edit" },
            { key = "h", action = "close_node" },
          },
        },
      },
    })

    nmap("<leader>te", "<cmd>NvimTreeToggle<cr>")
  end,
}

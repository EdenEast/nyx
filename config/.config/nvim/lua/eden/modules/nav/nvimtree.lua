local tree_cb = require("nvim-tree.config").nvim_tree_callback

vim.g.nvim_tree_width_allow_resize = 0
-- vim.g.nvim_tree_bindings = {
--   { key = "l", cb = tree_cb("edit") },
--   { key = "h", cb = tree_cb("close_node") },
-- }

require("nvim-tree").setup({
  ignore_ft_on_setup = { ".git", "node_modules" },
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
        { key = "l", cb = tree_cb("edit") },
        { key = "h", cb = tree_cb("close_node") },
      },
    },
  },
})

nmap("<leader>te", "<cmd>NvimTreeToggle<cr>")

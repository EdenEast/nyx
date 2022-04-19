local tree_cb = require("nvim-tree.config").nvim_tree_callback

vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_width_allow_resize = 0
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_group_empty = 1
-- vim.g.nvim_tree_bindings = {
--   { key = "l", cb = tree_cb("edit") },
--   { key = "h", cb = tree_cb("close_node") },
-- }
vim.g.nvim_tree_icons = {
  default = "",
  symlink = "",
  git = {
    unstaged = "✚",
    staged = "✚",
    unmerged = "≠",
    renamed = "≫",
    untracked = "★",
  },
}

require("nvim-tree").setup({
  ignore_ft_on_setup = { ".git", "node_modules" },
  tab_open = true,
  update_focused_file = {
    enable = true,
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

edn.keymap("<leader>te", "<cmd>NvimTreeToggle<cr>")

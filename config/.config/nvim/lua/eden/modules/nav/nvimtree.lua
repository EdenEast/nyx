local tree_cb = require("nvim-tree.config").nvim_tree_callback

vim.g.nvim_tree_follow = 1
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_width_allow_resize = 0
vim.g.nvim_tree_disable_netrw = 1
vim.g.nvim_tree_hijack_netrw = 1
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_bindings = {
  { key = "l", cb = tree_cb("edit") },
  { key = "h", cb = tree_cb("close_node") },
}
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
  auto_close = true,
  tab_open = true,
})

edn.keymap("<leader>te", "<cmd>NvimTreeToggle<cr>")

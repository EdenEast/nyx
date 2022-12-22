return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },

  setup = function()
    vim.g.neo_tree_remove_legacy_commands = 1
  end,
  config = function()
    nmap("<leader>te", "<cmd>:Neotree toggle<cr>")
  end,
}

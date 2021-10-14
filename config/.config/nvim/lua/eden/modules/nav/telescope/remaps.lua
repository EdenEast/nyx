edn.keymap("<leader>f", {
  { "f", [[<cmd>Telescope find_files<cr>]] },
  { "d", [[<cmd>Telescope git_files<cr>]] },
  { "r", [[<cmd>Telescope live_grep<cr>]] },
  { "s", [[<cmd>Telescope lsp_workspace_symbols<cr>]] },
  { "b", [[<cmd>Telescope buffers<cr>]] },
  { "B", [[<cmd>Telescope builtin<cr>]] },
  { "h", [[<cmd>Telescope help_tags<cr>]] },
  { "e", [[<cmd>Telescope file_browser<cr>]] },
  { "q", [[<cmd>Telescope quickfix<cr>]] },
  { "Q", [[<cmd>Telescope loclist<cr>]] },
  {
    "g",
    {
      { "b", [[<cmd>Telescope git_branches<cr>]] },
      { "c", [[<cmd>Telescope git_commits<cr>]] },
      { "l", [[<cmd>Telescope git_bcommits<cr>]] },
      { "s", [[<cmd>Telescope git_status<cr>]] },
    },
  },
})

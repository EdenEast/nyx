local actions = require("telescope.actions")
local sorters = require("telescope.sorters")

-- local trouble = require("trouble.providers.telescope")

require("telescope").setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--hidden",
      "--smart-case",
    },

    layout_strategy = "horizontal",

    mappings = {
      i = {
        ["<C-x>"] = false,
        ["<C-s>"] = actions.select_horizontal,

        -- ["<c-t>"] = trouble.open_with_trouble,

        -- Experimental
        -- ["<tab>"] = actions.toggle_selection,

        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
    },

    file_sorter = sorters.get_fzy_sorter,
  },

  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
  },
})

require("telescope").load_extension("fzy_native")

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

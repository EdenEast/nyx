local is_lazy, _ = pcall(require, "lazy")
if not is_lazy then
  require("eden.lib.defer").immediate_load({
    "plenary.nvim",
    "telescope-fzy-native.nvim",
  })
end

local actions = require("telescope.actions")
local sorters = require("telescope.sorters")

require("telescope").setup({
  defaults = {
    pickers = {
      live_grep = {
        only_sort_text = true,
      },
    },
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

        -- Experimental
        -- ["<tab>"] = actions.toggle_selection,

        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
    },

    file_sorter = sorters.get_fzy_sorter,

    -- borderchars = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
  },

  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
  },
})

if not is_lazy then
  require("telescope").load_extension("fzy_native")
end

if vim.g.sqlite_found then
  if not is_lazy then
    require("eden.lib.defer").immediate_load({
      "sqlite.lua",
      "telescope-frecency.nvim",
    })
  end
  require("telescope").load_extension("frecency")
end

-- Load telescope mappings
require("eden.mod.telescope.remaps")

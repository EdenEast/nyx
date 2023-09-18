local Util = require("eden.util")
local T = Util.telescope

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>,", T("buffers", { show_all_buffers = true }), desc = "Switch Buffer" },
      { "<leader>/", T("live_grep"), desc = "Find in Files (Grep)" },
      { "<leader>?", T("current_buffer_fuzzy_find"), desc = "Buffer" },
      { "<leader>:", T("command_history"), desc = "Command History" },
      -- find
      { "<leader>fb", T("buffers"), desc = "Buffers" },
      { "<leader>ff", T("files"), desc = "Find Files (root dir)" },
      { "<leader>fF", T("files", { cwd = false }), desc = "Find Files (cwd)" },
      { "<leader>fg", T("git_files"), desc = "Git Files" },
      { "<leader>fr", T("oldfiles"), desc = "Recent" },
      -- git
      { "<leader>gc", T("git_commits"), desc = "Commits" },
      { "<leader>gC", T("git_bcommits"), desc = "Buffer commits" },
      -- search
      { "<leader>sb", T("current_buffer_fuzzy_find"), desc = "Buffer" },
      { "<leader>sc", T("command_history"), desc = "Command History" },
      { "<leader>sC", T("commands"), desc = "Commands" },
      { "<leader>sd", T("diagnostics"), desc = "Diagnostics" },
      { "<leader>sg", T("live_grep"), desc = "Grep (root dir)" },
      { "<leader>sG", T("live_grep", { cwd = false }), desc = "Grep (cwd)" },
      { "<leader>sh", T("help_tags"), desc = "Help Pages" },
      { "<leader>sH", T("highlights"), desc = "Search Highlight Groups" },
      { "<leader>sR", T("resume"), desc = "Resume" },
      { "<leader>sw", T("grep_string"), desc = "Word (root dir)" },
      { "<leader>sW", T("grep_string", { cwd = false }), desc = "Word (cwd)" },
      { "<leader>uT", T("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
      {
        "<leader>ss",
        T("lsp_document_symbols", {
          symbols = {
            "Class",
            "Function",
            "Method",
            "Constructor",
            "Interface",
            "Module",
            "Struct",
            "Trait",
            "Field",
            "Property",
          },
        }),
        desc = "Goto Symbol",
      },
      {
        "<leader>sS",
        T("lsp_workspace_symbols", {
          symbols = {
            "Class",
            "Function",
            "Method",
            "Constructor",
            "Interface",
            "Module",
            "Struct",
            "Trait",
            "Field",
            "Property",
          },
        }),
        desc = "Goto Symbol (Workspace)",
      },
    },
    config = function()
      local ts = require("telescope")
      ts.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          mappings = {
            i = {
              ["<c-t>"] = function(...) return require("trouble.providers.telescope").open_with_trouble(...) end,
              ["<a-t>"] = function(...) return require("trouble.providers.telescope").open_selected_with_trouble(...) end,
              ["<a-i>"] = function() T("find_files", { no_ignore = true })() end,
              ["<a-h>"] = function() T("find_files", { hidden = true })() end,
              ["<C-Down>"] = function(...) return require("telescope.actions").cycle_history_next(...) end,
              ["<C-Up>"] = function(...) return require("telescope.actions").cycle_history_prev(...) end,
              ["<C-f>"] = function(...) return require("telescope.actions").preview_scrolling_down(...) end,
              ["<C-b>"] = function(...) return require("telescope.actions").preview_scrolling_up(...) end,
            },
            n = {
              ["q"] = function(...) return require("telescope.actions").close(...) end,
            },
          },
        },
        pickers = {
          live_grep = {
            additional_args = function(_) return { "--hidden" } end,
          },
        },
      })

      ts.load_extension("notify")
    end,
  },
}

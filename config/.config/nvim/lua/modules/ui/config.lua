local config = {}

function config.dashboard()
  vim.g.dashboard_custom_header = {
    "███████╗██████╗ ███████╗███╗   ██╗",
    "██╔════╝██╔══██╗██╔════╝████╗  ██║",
    "█████╗  ██║  ██║█████╗  ██╔██╗ ██║",
    "██╔══╝  ██║  ██║██╔══╝  ██║╚██╗██║",
    "███████╗██████╔╝███████╗██║ ╚████║",
    "╚══════╝╚═════╝ ╚══════╝╚═╝  ╚═══╝",
  }
  vim.g.dashboard_default_executive = "telescope"
  vim.g.dashboard_custom_section = {
    a = { description = { "  Recently Used Files" }, command = "Telescope oldfiles" },
    b = { description = { "  Find File          " }, command = "Telescope find_files" },
    c = { description = { "  Load Last Session  " }, command = "SessionLoad" },
    d = { description = { "  Find Word          " }, command = "Telescope live_grep" },
    e = { description = { "  File Browser       " }, command = "Telescope file_browser" },
  }
  vim.g.dashboard_custom_footer = { "github.com/EdenEast" }
end

function config.whichkey()
  local whichkey = require("which-key")

  vim.opt.timeoutlen = 300

  whichkey.setup()
  whichkey.register({
    b = { name = "+buffer" },
    c = { name = "+code" },
    f = { name = "+find" },
    g = { name = "+git" },
    t = { name = "+toggle" },
    ["1"] = "which_key_ignore",
    ["2"] = "which_key_ignore",
    ["3"] = "which_key_ignore",
    ["4"] = "which_key_ignore",
    ["5"] = "which_key_ignore",
    ["6"] = "which_key_ignore",
    ["7"] = "which_key_ignore",
    ["8"] = "which_key_ignore",
    ["9"] = "which_key_ignore",
  }, {
    prefix = "<leader>",
  })
end

function config.indentline()
  -- vim.g.indentLine_char = '│'  -- U+2502
  -- vim.g.indentLine_char = '┆'  -- U+2506
  vim.g.indentLine_char = "┊" -- U+250A

  vim.g.indentLine_enabled = 1
  vim.g.indentLine_concealcursor = "niv"
  vim.g.indentLine_showFirstIndentLevel = 0
  vim.g.indentLine_fileTypeExclude = {
    "defx",
    "denite",
    "startify",
    "dashboard",
    "tagbar",
    "vista_kind",
    "vista",
    "Help",
    "term",
    "toggerm",
  }
end

function config.gitsigns()
  require("gitsigns").setup({
    signs = {
      add = { hl = "GitGutterAdd", text = "▋" },
      change = { hl = "GitGutterChange", text = "▋" },
      delete = { hl = "GitGutterDelete", text = "▋" },
      topdelete = { hl = "GitGutterDeleteChange", text = "▔" },
      changedelete = { hl = "GitGutterChange", text = "▎" },
    },
    keymaps = {
      -- Default keymap options
      noremap = true,
      buffer = true,

      ["n ]g"] = { expr = true, "&diff ? ']g' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'" },
      ["n [g"] = { expr = true, "&diff ? '[g' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'" },

      ["n <leader>ghs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
      ["n <leader>ghu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
      ["n <leader>ghr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
      ["n <leader>ghp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
      ["n <leader>ghb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',

      -- Text objects
      ["o ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
      ["x ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
    },
  })
end

function config.bufferline()
  vim.keymap({
    { "]b", ":BufferLineCycleNext<cr>" },
    { "[b", ":BufferLineCyclePrev<cr>" },

    {
      "<leader>b",
      {
        { "l", ":BufferLineMoveNext<cr>" },
        { "h", ":BufferLineMovePrev<cr>" },
        { "e", ":BufferLineSortByExtension<CR><cr>" },
        { "d", ":BufferLineSortByDirectory<cr>" },
      },
    },
  })

  require("bufferline").setup({
    options = {
      modified_icon = "✥",
      buffer_close_icon = "x",
      mappings = true,
      always_show_bufferline = false,
    },
  })
end

function config.nvim_tree()
  local tree_cb = require("nvim-tree.config").nvim_tree_callback
  vim.g.nvim_tree_ignore = { ".git", "node_modules" }
  vim.g.nvim_tree_auto_close = 1
  vim.g.nvim_tree_auto_ignore_ft = { "startify", "dashboard" }
  vim.g.nvim_tree_follow = 1
  vim.g.nvim_tree_indent_markers = 1
  vim.g.nvim_tree_git_hl = 1
  vim.g.nvim_tree_tab_open = 1
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
  vim.keymap("<leader>te", "<cmd>NvimTreeToggle<cr>")
end

function config.truezen()
  require("true-zen").setup({
    integrations = {
      gitsigns = true,
      lualine = true,
    },
  })

  vim.keymap({
    { "<leader>bm", [[<cmd>TZFocus<cr>]] },
    { "<leader>tz", [[<cmd>TZAtaraxis<cr>]] },
  })
end

function config.zenmode()
  require("zen-mode").setup()

  vim.keymap("<leader>tz", [[<cmd>ZenMode<cr>]])
end

return config

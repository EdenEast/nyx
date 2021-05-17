local wk = require('core.whichkey')
local config = {}

function config.startify()
  local nnoremap = vim.keymap.nnoremap
  local ascii = {
    '',
    '    ███████╗██████╗ ███████╗███╗   ██╗',
    '    ██╔════╝██╔══██╗██╔════╝████╗  ██║',
    '    █████╗  ██║  ██║█████╗  ██╔██╗ ██║',
    '    ██╔══╝  ██║  ██║██╔══╝  ██║╚██╗██║',
    '    ███████╗██████╔╝███████╗██║ ╚████║',
    '    ╚══════╝╚═════╝ ╚══════╝╚═╝  ╚═══╝',
    '',
  }

  vim.g.startify_custom_header = ascii
  vim.g.startify_bookmarks = {
    {n = '~/.local/nyx/flake.nix'},
    {v = '~/.local/nyx/home/files/.config/nvim/init.lua'},
    {g = '~/.local/nyx/home/files/.config/git/config'},
  }

  vim.g.startify_skiplist = {
    '^/tmp',
    '/.git/',
  }

  nnoremap { '<leader>ts',':<c-u>Startify<cr>' }
  -- wk('<leader>ts', 'start-page')
  wk('<leader>ts', 'start-page')

  vim.api.nvim_exec(
    [[
     autocmd! FileType startify
     autocmd FileType startify set laststatus=0 showtabline=0 | autocmd BufLeave <buffer> set laststatus=2 showtabline=1
     autocmd User Startified setlocal buflisted
    ]],
  false)
end

function config.whichkey()
  local whichkey = require('which-key')

  whichkey.setup()
  whichkey.register({
    b = { name = '+buffer' },
    c = { name = '+code' },
    f = { name = '+find' },
    g = { name = '+git' },
    t = { name = '+toggle' },
    ["1"] = 'which_key_ignore',
    ["2"] = 'which_key_ignore',
    ["3"] = 'which_key_ignore',
    ["4"] = 'which_key_ignore',
    ["5"] = 'which_key_ignore',
    ["6"] = 'which_key_ignore',
    ["7"] = 'which_key_ignore',
    ["8"] = 'which_key_ignore',
    ["9"] = 'which_key_ignore',
    }, {prefix = '<leader>'})
end

-- function config.whichkey()
--   local nnoremap = vim.keymap.nnoremap
--   local vnoremap = vim.keymap.vnoremap

--   vim.opt.timeoutlen = 300

--   -- Hide status line on which key
--   vim.cmd([[
--       autocmd! FileType which_key
--       autocmd  FileType which_key set laststatus=0 noshowmode noruler
--       \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler
--   ]])

--   -- Register which_keymaps defined on load
--   vim.fn['which_key#register']('<Space>', vim.which_leader)
--   vim.fn['which_key#register'](',', vim.which_localleader)
--   vim.fn['which_key#register']('[', vim.which_prev)
--   vim.fn['which_key#register'](']', vim.which_next)

--   nnoremap { '<leader>', [[:WhichKey '<Space>'<cr>]], silent = true }
--   vnoremap { '<leader>', [[:WhichKeyVisual '<Space>'<cr>]], silent = true }

--   nnoremap { '<localleader>', [[:WhichKey ','<cr>]], silent = true }
--   vnoremap { '<localleader>', [[:WhichKeyVisual ','<cr>]], silent = true }

--   nnoremap { '[', [[:WhichKey '['<cr>]], silent = true }
--   nnoremap { ']', [[:WhichKey ']'<cr>]], silent = true }
-- end

function config.indentline()
 -- vim.g.indentLine_char = '│'  -- U+2502
 -- vim.g.indentLine_char = '┆'  -- U+2506
 vim.g.indentLine_char = '┊'  -- U+250A

 vim.g.indentLine_enabled = 1
 vim.g.indentLine_concealcursor = 'niv'
 vim.g.indentLine_showFirstIndentLevel = 0
 vim.g.indentLine_fileTypeExclude = {
  'defx',
  'denite',
  'startify',
  'dashboard',
  'tagbar',
  'vista_kind',
  'vista',
  'Help',
  'term',
  'toggerm',
 }
end

function config.vista()
  local nnoremap = vim.keymap.nnoremap

  -- Use coc as the backend
  if vim.g.eden_nvimlsp then
    vim.g.vista_default_executive = 'nvim_lsp'
  else
    vim.g.vista_default_executive = 'coc'
  end

  -- Enable fzf preview with vista
  vim.g.vista_fzf_preview = {'right:50%'}

  -- Keep original g:fzf_colors when using fzf
  vim.g.vista_keep_fzf_colors = 1

  -- Make vista sidebar slightly bigger default '30'
  vim.g.vista_sidebar_width = 40

  nnoremap { '<leader>tv',':<c-u>Vista!!<cr>' }
  wk('<leader>tv', 'vista')
  nnoremap { '<leader>fv', ':<c-u>Vista finder<cr>' }
  wk('<leader>fv', 'vista')

  -- Map / in vista buffer to search with fzf
  -- vim.cmd([[autocmd FileType vista,vista_kind nnoremap <buffer><silent> / :<c-u>call vista#finder#fzf#Run()<CR>]]
end

function config.gitsigns()
  if not packer_plugins['plenary.nvim'].loaded then
    vim.cmd [[packadd plenary.nvim]]
  end
  require('gitsigns').setup {
    signs = {
      add = {hl = 'GitGutterAdd', text = '▋'},
      change = {hl = 'GitGutterChange',text= '▋'},
      delete = {hl= 'GitGutterDelete', text = '▋'},
      topdelete = {hl ='GitGutterDeleteChange',text = '▔'},
      changedelete = {hl = 'GitGutterChange', text = '▎'},
    },
    keymaps = {
       -- Default keymap options
       noremap = true,
       buffer = true,

       ['n ]g'] = { expr = true, "&diff ? ']g' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
       ['n [g'] = { expr = true, "&diff ? '[g' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},

       ['n <leader>ghs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
       ['n <leader>ghu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
       ['n <leader>ghr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
       ['n <leader>ghp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
       ['n <leader>ghb'] = '<cmd>lua require"gitsigns".blame_line()<CR>',

       -- Text objects
       ['o ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>',
       ['x ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>'
     },
  }

  wk('<leader>gh', {
    name = '+hunk',
    b = 'blame',
    p = 'preview',
    r = 'reset',
    s = 'stage',
    u = 'unstage',
  })

  vim.which_prev['g'] = 'git-hunk'
  vim.which_next['g'] = 'git-hunk'
end

function config.bufferline()
  local nnoremap = vim.keymap.nnoremap

  nnoremap { ']b', ':BufferLineCycleNext<cr>', silent = true }
  vim.which_next['b'] = 'buffer'

  nnoremap { '[b', ':BufferLineCyclePrev<cr>', silent = true }
  vim.which_prev['b'] = 'buffer'

  nnoremap { '<leader>bl', ':BufferLineMoveNext<cr>', silent = true }
  wk('<leader>bl', 'next')

  nnoremap { '<leader>bh', ':BufferLineMovePrev<cr>', silent = true }
  wk('<leader>bh', 'prev')

  nnoremap { '<leader>be', ':BufferLineSortByExtension<CR><cr>', silent = true }
  wk('<leader>be', 'sort-extension')

  nnoremap { '<leader>bd', ':BufferLineSortByDirectory<cr>', silent = true }
  wk('<leader>bd', 'sort-directory')

  require('bufferline').setup{
    options = {
      modified_icon = '✥',
      buffer_close_icon = 'x',
      mappings = true,
      always_show_bufferline = false,
    }
  }

  -- wk('<leader>', {
  --     ['1'] = 'which_key_ignore',
  --     ['2'] = 'which_key_ignore',
  --     ['3'] = 'which_key_ignore',
  --     ['4'] = 'which_key_ignore',
  --     ['5'] = 'which_key_ignore',
  --     ['6'] = 'which_key_ignore',
  --     ['7'] = 'which_key_ignore',
  --     ['8'] = 'which_key_ignore',
  --     ['9'] = 'which_key_ignore',
  --   })

  -- wk('<leader>1', 'which_key_ignore')
  -- wk('<leader>2', 'which_key_ignore')
  -- wk('<leader>3', 'which_key_ignore')
  -- wk('<leader>4', 'which_key_ignore')
  -- wk('<leader>5', 'which_key_ignore')
  -- wk('<leader>6', 'which_key_ignore')
  -- wk('<leader>7', 'which_key_ignore')
  -- wk('<leader>8', 'which_key_ignore')
  -- wk('<leader>9', 'which_key_ignore')
end

function config.nvim_tree()
  vim.g.nvim_tree_side = 'left'
  vim.g.nvim_tree_width = 30
  vim.g.nvim_tree_ignore = { '.git', 'node_modules' }
  vim.g.nvim_tree_auto_open = 1
  vim.g.nvim_tree_auto_close = 1
  vim.g.nvim_tree_auto_ignore_ft = {'startify', 'dashboard'}
  vim.g.nvim_tree_quit_on_open = 0
  vim.g.nvim_tree_follow = 1
  vim.g.nvim_tree_indent_markers = 1
  vim.g.nvim_tree_hide_dotfiles = 0
  vim.g.nvim_tree_git_hl = 1
  vim.g.nvim_tree_root_folder_modifier = ':~'
  vim.g.nvim_tree_tab_open = 1
  vim.g.nvim_tree_width_allow_resize = 0
  vim.g.nvim_tree_disable_netrw = 1
  vim.g.nvim_tree_hijack_netrw = 1
  vim.g.nvim_tree_add_trailing = 1
  vim.g.nvim_tree_group_empty = 1
  vim.g.nvim_tree_bindings = {
    ["l"] = ":lua require'nvim-tree'.on_keypress('edit')<CR>",
    ["s"] = ":lua require'nvim-tree'.on_keypress('vsplit')<CR>",
    ["i"] = ":lua require'nvim-tree'.on_keypress('split')<CR>",
  }
  vim.g.nvim_tree_icons = {
    default =  '',
    symlink =  '',
    git = {
     unstaged = "✚",
     staged =  "✚",
     unmerged =  "≠",
     renamed =  "≫",
     untracked = "★",
    },
  }

  vim.keymap.nnoremap { '<leader>te', '<cmd>NvimTreeToggle<cr>', silent=true }
  wk('<leader>te', 'file-explorer')
end

function config.neoscroll()
  require('neoscroll').setup()
end

return config

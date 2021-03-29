local config = {}

function config.startify()
  vim.api.nvim_exec(
    [[
     autocmd! FileType startify
     autocmd FileType startify set laststatus=0 showtabline=0 | autocmd BufLeave <buffer> set laststatus=2 showtabline=1
     autocmd User Startified setlocal buflisted
    ]],
  false)
end

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
end

return config

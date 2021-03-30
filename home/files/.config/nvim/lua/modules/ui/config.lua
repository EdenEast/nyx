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
  nnoremap { '<leader>fv', ':<c-u>Vista finder<cr>' }

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
end

function config.bufferline()
  local nnoremap = vim.keymap.nnoremap

  nnoremap { ']b', ':BufferLineCycleNext<cr>' }
  nnoremap { '[b', ':BufferLineCyclePrev<cr>' }

  nnoremap { '<leader>bl', ':BufferLineMoveNext<cr>' }
  nnoremap { '<leader>bh', ':BufferLineMovePrev<cr>' }

  nnoremap { '<leader>be', ':BufferLineSortByExtension<CR><cr>' }
  nnoremap { '<leader>bd', ':BufferLineSortByDirectory<cr>' }

  require('bufferline').setup{
    options = {
      modified_icon = '✥',
      buffer_close_icon = 'x',
      mappings = true,
      always_show_bufferline = false,
    }
  }
end

return config

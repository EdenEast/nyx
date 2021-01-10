function! eden#lightline#read_only()
  return &readonly ? '' : ''
endfunction

function! eden#lightline#filename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

function! eden#lightline#fugitive() abort
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    return branch !=# '' ? ' '.branch : ''
  endif
  return ''
endfunction

function! eden#lightline#lsp() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

function! eden#lightline#vista_nearest_func() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

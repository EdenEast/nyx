" function! SynStack ()
"   let l:s = synID(line('.'), col('.'), 1)
"   echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
" endfunction

function! SynStack()
  for i1 in synstack(line("."), col("."))
    let i2 = synIDtrans(i1)
    let n1 = synIDattr(i1, "name")
    let n2 = synIDattr(i2, "name")
    echo n1 "->" n2
  endfor
endfunction
command! -nargs=0 -bar SynStack call SynStack()

map gm <cmd> SynStack<CR>
map gn <cmd>TSHighlightCapturesUnderCursor<cr>

map <F8> :lua require('nightfox').reload()<cr>


function eden#font#inc() abort
  let l:matches = matchlist(&guifont, '\v^(.*):h([0-9]+)$')
  let l:fontname = l:matches[1]
  let l:size = l:matches[2] + 1
  call eden#font#sizechange(l:fontname, l:size)
endfunction

function eden#font#dec() abort
  let l:matches = matchlist(&guifont, '\v^(.*):h([0-9]+)$')
  let l:fontname = l:matches[1]
  let l:size = l:matches[2] - 1
  call eden#font#sizechange(l:fontname, l:size)
endfunction

function eden#font#sizechange(fontname, size) abort
  let &guifont = substitute(a:fontname, '\v\s', '\ ', '') . ':h' . a:size
  execute 'GuiFont ' . a:fontname . ':h' . a:size
endfunction

function eden#font#reset() abort
  let &guifont = substitute(g:default_gui_font, '\v\s', '\ ', '') . ':h' . g:default_gui_font_size
  execute 'GuiFont ' . g:default_gui_font . ':h' . g:default_gui_font_size
endfunction

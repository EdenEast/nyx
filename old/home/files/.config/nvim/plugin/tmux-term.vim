if has('termguicolors')
  " https://vi.stackexchange.com/a/20284
  if &term =~# '256color' && ( &term =~# '^screen'  || &term =~# '^tmux' )
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif

  set termguicolors           " use guifg/guibg instead of ctermfg/ctermbg in terminal
endif

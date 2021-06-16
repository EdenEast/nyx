"compile_root To check if neovim-qt is running, use `exists('g:GuiLoaded')`,
" see https://github.com/equalsraf/neovim-qt/issues/219
if exists('g:GuiLoaded')
  call GuiWindowMaximized(1)
  GuiTabline 0
  GuiPopupmenu 0
  " GuiLinespace 2

  " Use shift+insert for paste inside neovim-qt,
  " see https://github.com/equalsraf/neovim-qt/issues/327#issuecomment-325660764
  inoremap <silent> <S-Insert>  <C-R>+
  cnoremap <silent> <S-Insert> <C-R>+

  " For Windows, Ctrl-6 does not work. So we use this mapping instead.
  nnoremap <silent> <C-6> <C-^>

  " let g:default_gui_font = 'Consolas'
  " let g:default_gui_font = 'UbuntuMono NF'
  let g:default_gui_font = 'Hack Nerd Font Mono'
  let g:default_gui_font_size = 9

  call eden#font#reset()

  command! -nargs=0 -bar GuiFontInc call eden#font#inc()
  command! -nargs=0 -bar GuiFontDec call eden#font#dec()
  command! -nargs=0 -bar GuiFontReset call eden#font#reset()
endif

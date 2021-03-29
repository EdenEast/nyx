let s:header = [
      \'',
      \'    ███████╗██████╗ ███████╗███╗   ██╗',
      \'    ██╔════╝██╔══██╗██╔════╝████╗  ██║',
      \'    █████╗  ██║  ██║█████╗  ██╔██╗ ██║',
      \'    ██╔══╝  ██║  ██║██╔══╝  ██║╚██╗██║',
      \'    ███████╗██████╔╝███████╗██║ ╚████║',
      \'    ╚══════╝╚═════╝ ╚══════╝╚═╝  ╚═══╝',
      \'',
      \]


" let g:startify_custom_header = eden#util#center_lines(s:header)
let g:startify_custom_header = s:header

nnoremap <silent> <Leader>ts  :<C-u>Startify<CR>
let g:which_key_map.t.s = 'startify'

let g:startify_session_autoload = 1
let g:startify_bookmarks = [
      \ {'n': '~/.config/nvim/init.vim'},
      \ {'v': '~/.config/vim/vimrc'},
      \ {'g': '~/.config/git/config'},
      \ {'a': '~/.config/awesome/rc.lua'},
      \ {'x': '~/.xmonad/xmonad.hs'},
      \ {'b': '~/.local/bin'},
      \ {'s': '~/.local/share'},
      \]

let g:startify_skiplist = [
      \ '^/tmp',
      \ '/.git/',
      \]

autocmd! FileType startify
autocmd FileType startify set laststatus=0 showtabline=0
  \| autocmd BufLeave <buffer> set laststatus=2 showtabline=1
autocmd User Startified setlocal buflisted

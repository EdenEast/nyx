"
" ███╗   ██╗██╗   ██╗██╗███╗   ███╗
" ████╗  ██║██║   ██║██║████╗ ████║    James Simpson
" ██╔██╗ ██║██║   ██║██║██╔████╔██║    https://github.com/edeneast
" ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║    https://github.com/edeneast/dots
" ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
" ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
"

" Depending on the environment, this folder might not be in the runtimepath.
" For example on windows I link this folder to %LocalAppData%\nvim
let g:nvim_user_config_path = fnamemodify(resolve(expand('<sfile>')), ':p:h')
let g:original_rtp = &rtp
let g:original_packpath = &packpath

" Only override runtimepath if paths have not been setup before
if !exists('g:eden_has_path_setup')
  let &runtimepath = g:nvim_user_config_path
endif

let g:eden_use_builtin_lsp = 0

call eden#setup_paths(g:original_rtp, g:original_packpath)
call eden#init()
call eden#whichkey_init()
call eden#source_file(eden#path#join([g:config_root, 'core', 'core.vim']))

if has("nvim")
  lua require('init')
endif

if has('nvim-0.5')
  command! -nargs=? ResetLuaPlugin lua require"devtools".reset_package(<q-args>)
endif

" call eden#theme#init()


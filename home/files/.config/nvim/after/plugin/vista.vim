
" Use coc as the backend
let g:vista_default_executive = 'coc'

" Enable fzf preview with vista
let g:vista_fzf_preview = ['right:50%']

" Keep original g:fzf_colors when using fzf
let g:vista_keep_fzf_colors = 1

" Make vista sidebar slightly bigger default '30'
let g:vista_sidebar_width = 40

nnoremap <leader>tv :<c-u>Vista!!<cr>
let g:which_key_map.t.v = 'vista'

nnoremap <leader>fv :<c-u>Vista finder<cr>
let g:which_key_map.f.v = 'vista'

" Map / in vista buffer to search with fzf
autocmd FileType vista,vista_kind nnoremap <buffer><silent> / :<c-u>call vista#finder#fzf#Run()<CR>

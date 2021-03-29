" Fugitive
nnoremap <silent> <leader>ga :Git add %:p<cr>
let g:which_key_map.g.a = 'add'

nnoremap <silent> <leader>gd :Gdiffsplit<cr>
let g:which_key_map.g.d = 'diff'

nnoremap <silent> <leader>gc :Git commit<cr>
let g:which_key_map.g.c = 'commit'

nnoremap <silent> <leader>gb :Git blame<cr>
let g:which_key_map.g.b = 'blame'

nnoremap <silent> <leader>gf :Gfetch<cr>
let g:which_key_map.g.f = 'fetch'

nnoremap <silent> <leader>gs :Git<cr>
let g:which_key_map.g.s = 'status'

nnoremap <silent> <leader>gp :Gpush<cr>
let g:which_key_map.g.p = 'push'

" Magit
nnoremap <silent> <leader>gg :Magit<cr>
let g:which_key_map.g.p = 'magit'

" git-messenger
let g:git_messenger_no_default_mapping = 0

nnoremap <silent> <leader>gm <Plug>(git-messenger)
let g:which_key_map.g.p = 'show-commit'

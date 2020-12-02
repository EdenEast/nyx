if g:eden_use_builtin_lsp != 0
  finish
endif

let g:coc_config_home = g:config_root
let g:coc_data_home = eden#path#join([g:cache_root, 'coc'])
let g:coc_global_extensions  = [
      \ 'coc-actions',
      \ 'coc-clangd',
      \ 'coc-cmake',
      \ 'coc-eslint',
      \ 'coc-explorer',
      \ 'coc-git',
      \ 'coc-github',
      \ 'coc-go',
      \ 'coc-json',
      \ 'coc-markdownlint',
      \ 'coc-marketplace',
      \ 'coc-rust-analyzer',
      \ 'coc-snippets',
      \ 'coc-tslint',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ 'coc-yaml',
      \ 'coc-zi',
      \ ]


" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" Highlight the symbol and its references when holding the cursor.
if exists('g:coc_loaded')
  autocmd CursorHold * silent call CocActionAsync('highlight')
endif

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <TAB> for selections ranges.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" Multiple cursors --------------------------------------------------------------------------------
nmap <expr> <silent><M-d> <SID>select_current_word()
xmap <silent><M-d> <Plug>(coc-cursors-range)

" use normal command like `<M-c>i(`
nmap <silent><M-c>  <Plug>(coc-cursors-operator)

function! s:select_current_word()
  if !get(g:, 'coc_cursors_activated', 0)
    return "\<Plug>(coc-cursors-word)"
  endif
  return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
endfunc

" File and buffer explorer ------------------------------------------------------------------------
let g:coc_exploerer_global_presets = {
      \ 'floating' : {
      \  'position' : 'floating'
      \  }
      \}
noremap <silent> <F2> :execute 'CocCommand explorer' .
      \ ' --toggle' .
      \ ' --sources=buffer-,file+'<CR>

" Function text objects ---------------------------------------------------------------------------
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Navigation --------------------------------------------------------------------------------------
nmap <silent> ]a :<c-u>CocNext<cr>
nmap <silent> [a :<c-u>CocPrev<cr>
nmap <silent> ]e <Plug>(coc-diagnostic-next)
nmap <silent> [e <Plug>(coc-diagnostic-prev)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview windw
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

" Actions -----------------------------------------------------------------------------------------
" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction

" Note the nmap is a motion
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>

" Coc and Clap ------------------------------------------------------------------------------------
nmap <silent> <leader>ce :<C-u>CocList diagnostics<cr>
let g:which_key_map.c.e = 'Lsp Show Diagnostics'

nmap <silent> <leader>co :<C-u>CocList outline<cr>
let g:which_key_map.c.o = 'Lsp Show Outline'

" TODO: find somewhere to put Clap coc_services coc_symbols coc_outline

" Code actions ------------------------------------------------------------------------------------
nmap <leader>cn <Plug>(coc-rename)
let g:which_key_map.c.n = 'rename'

nmap <leader>cf <Plug>(coc-format-selected)
vmap <leader>cf <Plug>(coc-format-selected)
let g:which_key_map.c.f = 'format'

nmap <leader>cF <Plug>(coc-fix-current)
let g:which_key_map.c.F = 'fix'

" Git actions -------------------------------------------------------------------------------------
" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)

nnoremap <leader>gi  <Plug>(coc-git-chunkinfo)
let g:which_key_map.g.i = 'chunk diff at point'

nnoremap <leader>gm <Plug>(coc-git-commit)
let g:which_key_map.g.m = 'commit message at point'

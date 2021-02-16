" 'j' and 'k' moves up and down visible lines in editor not actual lines
" This is noticable when text wraps to next line
nnoremap j gj
nnoremap k gk

" Read the current line and execute that in your $SHELL.
" The resulting output of the command will replace the line
" that you were on. This is very handy. Also we dont use Ex mode
nnoremap Q !!$SHELL <cr>

" Yank the current line and then execute it as a :command
nnoremap <M-q> yy:@" <cr>

" Map Y to be the same as D and C
nnoremap Y y$
vnoremap Y y$

" center search
nmap n nzz
nmap N Nzz

" Swtich between the last two buffers
nnoremap <leader><leader> <c-^>

" Tab/shift-tab to indent/outdent in visual mode.
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Keep selection when indenting/outdenting.
vnoremap > >gv
vnoremap < <gv

" Search for selected text
vnoremap * "xy/<C-R>x<CR>

" Toggle highlight search
nnoremap <silent><expr> <Leader>th (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"
let g:which_key_map.t.h = 'highlight search'

nnoremap <leader>w :<c-u>w<cr>
let g:which_key_map.w = 'write'

nnoremap <leader>q :<c-u>q<cr>
let g:which_key_map.q = 'quit'

nnoremap <leader>x :<c-u>x<cr>
let g:which_key_map.x = 'write + quit'

" Buffers ---------------------------------------------------------------------
nnoremap <leader>bw :w<cr>
let g:which_key_map.b.w = 'write'

nnoremap <leader>bq :q<cr>
let g:which_key_map.b.q = 'quit'

nnoremap <leader>bn :bNext<cr>
let g:which_key_map.b.n = 'next'

nnoremap <leader>bp :bprevious<cr>
let g:which_key_map.b.p = 'prev'

" Delete all bufers except for current buffer:
" - save file | delete all buffers | edit file in last opened register | delete [no name] buffer created from deleting
"   all buffers | move cursor back to position
nnoremap <leader>bo :w\|%bd\|e#\|bd#<cr>\|'"
let g:which_key_map.b.o = 'only'

nnoremap <leader>bO :w\|%bd!\|e#\|bd!#<cr>\|'"
let g:which_key_map.b.O = 'force only'

nnoremap [b :bprevious<cr>
nnoremap ]b :bNext<cr>

" Jump list -------------------------------------------------------------------
" Because currently in alacritty we cannot tell the difference between <tab> and
" <c-i> mapping <m-i> and <m-o> to go forward and backwards in the jump list
"
" https://vi.stackexchange.com/a/23344
nnoremap <m-i> <c-i>
nnoremap <m-o> <c-o>

" Tabs ------------------------------------------------------------------------
nnoremap [t :tabprevious<cr>
nnoremap ]t :tabNext<cr>

" Splits ----------------------------------------------------------------------
" Move around splits without having to press <C-w> before each movement
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <A-h> <C-w>3<
nnoremap <A-l> <C-w>3>
nnoremap <A-k> <C-w>3+
nnoremap <A-j> <C-w>3-

" Function key mappings -------------------------------------------------------
" Open vim config file in a new tab to make edits from anywhere
" while using vim (also dont use <F1> for help, have :h for that)
map <F1> :tabedit $HOME/.config/nvim/init.vim<cr>
map <leader><F1> :source $MYVIMRC<cr>

" " Refresh the current file
map <F4> :e! %<cr>
map <leader><F4> :call eden#source_file(expand('%'))<cr>

" Quickfix jumping shortcuts
"
" Jump to the next and previous entry in quickfix list
" using <F5> and <F7> keys. To move to the first and last
" are accessable through leader modifiers. To run make
" that is per language but the key is <F6>
map <F5> :cp<cr>
map <leader><F5> :cp<cr>
" map <F6> :make<cr>
map <F7> :cn<cr>
map <leader><F7> :cn<cr>

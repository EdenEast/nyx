if exists('&belloff')
  set belloff=all             " i NEVER want to hear this bell for ANY reason
endif

" if exists('+colorcolumn')
"   let &l:colorcolumn='+' . join(range(0, 254), ',+')
" endif
set cursorline                " highlight current line

if has('folding')
  if has('windows')
    set fillchars=vert:┃      " BOX DRAWINGS HEAVY VERTICAL (U+2503, UTF-8: E2 94 83)
    set fillchars+=fold:·     " MIDDLE DOT (U+00B7, UTF-8: C2 B7)
  endif

  if eden#platform#nvim()
    set fillchars+=eob:\    " suppress ~ at EndOfBuffer
  endif

  set foldmethod=indent       " not as cool as syntax, but faster
  set foldlevelstart=99       " start unfolded
endif

if !eden#platform#nvim()
  set highlight+=@:Conceal    " ~/@ at end of window, 'showbreak'
  set highlight+=N:DiffText   " make current line number stand out a little
  set highlight+=c:LineNr     " blend vertical separators with line numbers
endif

set laststatus=2              " always show status line
set lazyredraw                " dont bother updating screen durring macro playback

set list                      " show whitespace
set listchars=nbsp:⦸          " CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
set listchars+=tab:▷┅         " WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7)
" + BOX DRAWINGS HEAVY TRIPLE DASH HORIZONTAL (U+2505, UTF-8: E2 94 85)
set listchars+=extends:»      " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
set listchars+=precedes:«     " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
set listchars+=trail:•        " BULLET (U+2022, UTF-8: E2 80 A2)

set mousehide                 " hide the mouse cursor when typing

set number                    " show line numbers in gutter
if exists('+relativenumber')
  set relativenumber          " show relative numbers in the gutter
endif

set scrolloff=3               " start scrolling 3 lines before edge of view port
set sidescrolloff=3           " same as 'scrolloff' but for columns

set shortmess+=A              " ignore annoying swapfile messages
set shortmess+=I              " no spash screen
set shortmess+=O              " file-read message overrites previous
set shortmess+=T              " truncate non-file messages in middle
set shortmess+=W              " dont echo '[w]/[written]' when writing
set shortmess+=a              " use abbreviations in message '[ro]' instead of '[readonly]'
set shortmess+=o              " overwrite file-written mesage
set shortmess+=t              " truncate file messages at start

if has('linebreak')
  let &showbreak='↳ '         " downwards arrow with tip rightwards(U+21B3, UTF-8: E2 86 B3)
endif

if has('showcmd')
  set noshowcmd               " dont show extra info at end of command line
endif

set showmode                  " this should be the default

if has('syntax')
  set synmaxcol=200           " dont bother syntax highlighting long lines
endif

if has('termguicolors')
  " https://vi.stackexchange.com/a/20284
  if &term =~# '256color' && ( &term =~# '^screen'  || &term =~# '^tmux' )
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif

  set termguicolors           " use guifg/guibg instead of ctermfg/ctermbg in terminal
endif

set title                     " set the title of the window to 'titlestring'
set ttyfast                   " let vim know that I am using a fast term

if has('virtualedit')
  set virtualedit=block       " allow cursor to move where there is no text in visual block mode
endif

set visualbell t_vb=          " stop beeping for non-error errors, please god


scriptencoding utf-8

set autoindent                  " maintain indent of current line
set backspace=indent,start,eol  " allow unrestricted backspaceing in insert mode
if has('clipboard')
  set clipboard=unnamedplus       " use '+' register for all yanks, and deletes
endif
set expandtab                   " always use spaces instead of tabs
set formatoptions+=j            " remove comment leader when joning comments
set formatoptions+=n            " smart auto indenting inside numbered lists
set hidden                      " allows you to hide buffers with unsaved changes without being prompted
set iskeyword+=-                " treat - seperated words as a word object
set iskeyword+=_                " treat _ seperated words as a word object

if has('linebreak')
  set linebreak                 " wrap long lines at characters in 'breakat'
endif

set modelines=5                 " scan this many lines looking for modeline
set mouse=a                     " automatically enable mouse usage
set nojoinspaces                " don't autoinsert two spaces after '.', '?', '!' for join command
set shiftround                  " always indent by multiple of shiftwidth
set shiftwidth=4                " spaces per tab (when shifting)
set smarttab                    " <tab><bs> indent/deindent in leading whitespace

if v:progname != 'vi'
  set softtabstop=-1            " use 'shiftwidth' for tab/bs at end of line
endif

if has('syntax')
  set spellcapcheck=            " dont check for capital letters at the start of sentences
endif

if has('windows')
  set splitbelow                " open horizontal splits below the current one
endif

if has('vertsplit')
  set splitright                " open vertical splits right of the current one
endif

set switchbuf=usetab            " try to reuse windows/tabs when switching buffers

set tabstop=4                   " spaces per tab
set textwidth=120               " automatically hard wrap at 120 columns
set whichwrap=b,h,l,s,<,>,[,],~ " allow <BS>/h/l/<Left>/<Right>/<Space>, ~ to cross line boundaries
set wildcharm=<C-z>             " substitute for 'wildchar' (<Tab>) in macros

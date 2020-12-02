if has('wildignore')
  set backupskip+=*.re,*.rei   " prevent bsb's watch mode from getting confused
endif

set ignorecase                 " ignore case in search
set incsearch                  " do incremental searching
set smartcase                  " use case sensitive search if capital letter is present

if exists('&inccommand')
  set inccommand=split         " line preview of :s results
endif

if has('wildignore')
  set wildignore+=*.o,*.rej    " patters to ignore during file-navigation
endif

if has('wildmenu')
  set wildmenu                 " show options as list when switching buffers etc
endif

set wildmode=longest:full,full " shell-like autocomplete to unambiguous portions

" When entering a window or leaving insert mode highlight
" trailing whitespace
augroup trailing_whitespace
  autocmd!
  autocmd BufWinEnter * match Error /\s\+%#@<!$/
  autocmd InsertEnter * match Error /\s\+%#@<!$/
  autocmd InsertLeave * match Error /\s\+$/
augroup end

" Makes sure that vim returns to the same line when you reenter a file
augroup line_return
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup end

" Relative numbers are default unless you are in insert mode.
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup end

" Prevent me from editing files that i have marked as original copies
autocmd BufRead *.orig set readonly

augroup cargo_compiler
  autocmd!
  autocmd BufRead,BufNewFile Cargo.toml,Cargo.lock compiler cargo
  autocmd BufRead,BufNewFile Cargo.toml,Cargo.lock setlocal makeprg=cargo
augroup end

" Make quickfix window show up automaticly after compiling
augroup quicifix_fix
  autocmd!
  autocmd QuickFixCmdPost [^l]* nested cwindow
  autocmd QuickFixCmdPost    l* nested lwindow
augroup end

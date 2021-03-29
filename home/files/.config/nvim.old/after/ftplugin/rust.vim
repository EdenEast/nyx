" Make check will populate quickfix list with compiler warnings and errors.
" Clippy is accessable with leader modifier
map <buffer> <F6> :make check --all-targets<cr>
map <buffer> <leader><F6> :make clippy<cr>

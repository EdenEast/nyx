if !has("nvim")
  finish
endif

" Detect terminal and set it as a filetype
augroup TermDetect
    au!
    au TermOpen term://*  set filetype=term
    au TermOpen term://*#toggleterm#*  set filetype=toggleterm
augroup END

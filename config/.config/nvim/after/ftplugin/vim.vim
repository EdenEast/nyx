if has('conceal')
  setlocal concealcursor=nc

  " Fragile hack to stop indentLine plug-in from overwriting this back to "inc".
  let b:indentLine_ConcealOptionSet = 1
endif

setlocal iskeyword-=#

setlocal foldmethod=marker
setlocal foldlevel=0 fdc=1

setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal expandtab

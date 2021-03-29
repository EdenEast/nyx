function! eden#theme#init()
  " local cached colorscheme or default
  let l:default = 'xcodedark'
  let l:cache = s:theme_cache_file()
  if !exists('g:colors_name')
    set background=dark
    let l:scheme = filereadable(l:cache) ? readfile(l:cache)[0] : l:default
    silent! execute 'colorscheme' l:scheme
  endif
endfunction

function! s:theme_autoload()
  if exists('g:colors_name')
    call writefile([g:colors_name], s:theme_cache_file())
  endif
endfunction

function! s:theme_cache_file()
  return eden#path#join([g:cache_root, 'theme.txt'])
endfunction

function! s:theme_cleanup()
  if !exists('g:colors_name')
    return
  endif

  highlight clear
endfunction

augroup eden_themes
  autocmd!
  autocmd ColorScheme * call s:theme_autoload()
  if has('patch-8.0.1781') || has('nvim-0.3.2')
    autocmd ColorSchemePre * call s:theme_cleanup()
  endif
augroup END

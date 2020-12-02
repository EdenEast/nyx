" Platform specific checks
function eden#platform#windows()
  return (has('win32') || has('win64'))
endfunction

function eden#platform#linux()
  return has('unix') && !has('macunix') && !has('win32unix')
endfunction

function eden#platform#osx()
  return has('macunix')
endfunction

function eden#platform#wsl()
  return eden#platform#linux() && system('uname -r') =~ 'Microsoft'
endfunction

" Linux information
function eden#platform#kernalversion()
  return substitute(system('uname -r'), '[\n]\+', '', 'g')
endfunction

function eden#platform#distro()
  return substitute(system('lsb_release -si'), '[\n]\+', '', 'g')
endfunction

function eden#platform#path_sep()
  if eden#platform#windows()
    return '\'
  endif
  return '/'
endfunction

" Vim information
function eden#platform#nvim()
  return has('nvim')
endfunction

function eden#platform#gvim()
  return has('gui_running')
endfunction

function eden#platform#nvimqt()
  return has('g:GuiLoaded')
endfunction

function eden#platform#oni()
  return exists('g:gui_oni')
endfunction

function eden#platform#vimr()
  return has('gui_vimr')
endfunction

function eden#platform#winshell()
  return &shell =~ '(cmd|powershell)'
endfunction


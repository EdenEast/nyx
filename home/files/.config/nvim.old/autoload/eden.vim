function eden#setup_paths(original_rtp, original_packpath)
  if exists('g:eden_has_path_setup')
    return
  endif
  let g:eden_has_path_setup = 1

  " Define main configuration paths
  let $VIM_PATH=expand('$HOME/.config/nvim')
  let g:config_root=expand('$HOME/.config/nvim')
  let g:cache_root=expand('$HOME/.cache/nvim')
  let g:package_root=g:cache_root . '/packages'
  let $VIM_LOCAL_PATH=expand('$HOME/.local/share/nvim')
  let g:local_config_root=expand('$HOME/.local/share/nvim')

  " Runtimepath ---------------------------------------------------------------
  let l:o_rtps = split(a:original_rtp, ',')
  let l:rtps = [g:config_root, g:local_config_root]
  let l:after_rtps =
              \   [ eden#path#join([g:config_root, 'after']) ]
              \ + [ eden#path#join([g:local_config_root, 'after']) ]

  for iter in l:o_rtps
    if iter =~ '[/\\]after$'
      if index(l:after_rtps, iter) == -1
        call add(l:after_rtps, iter)
      endif
    else
      if index(l:rtps, iter) == -1
        call add(l:rtps, iter)
      endif
    endif
  endfor

  let &runtimepath = join(l:rtps, ',') . ',' . join(l:after_rtps, ',')

  " Packpath ------------------------------------------------------------------
  let l:o_packpaths = split(a:original_packpath, ',')
  let l:packpaths =
              \   [ g:config_root ]
              \ + [ eden#path#join([g:local_config_root, 'site']) ]
              \ + [ eden#path#join([g:cache_root, 'site']) ]
  let l:after_packpath =
              \   [ eden#path#join([g:config_root, 'after']) ]
              \ + [ eden#path#join([g:local_config_root, 'after', 'site']) ]
              \ + [ eden#path#join([g:cache_root, 'site']) ]

  for iter in l:o_packpaths
    if iter =~ '[/\\]after$'
      if index(l:after_packpath, iter) == -1
        call add(l:after_packpath, iter)
      endif
    else
      if index(l:packpaths, iter) == -1
        call add(l:packpaths, iter)
      endif
    endif
  endfor

  let &packpath = join(l:packpaths, ',') . ',' . join(l:after_packpath, ',')
endfunction

function eden#init()
  if exists('g:eden_has_initialized')
    return
  endif
  let g:eden_has_initialized = 1

  if &compatible
    set nocompatible
  endif

  " These are the basics of any editor
  syntax on
  filetype plugin indent on

  " Making sure that our encoding is correct
  set encoding=UTF-8

  " Initialize base requirements
  if has('vim_starting')
    let g:mapleader="\<Space>"
    let g:maplocalleader='\\'

    " Release keymappings prefixes, evict entirely for use of plug-ins.
    nnoremap <Space>  <Nop>
    xnoremap <Space>  <Nop>
    nnoremap \        <Nop>
    xnoremap \        <Nop>
  endif

  " autocmd to source init.vim when ever a file in changed either global or local config root
  " augroup source_nvim_config
  "   autocmd!
  "   autocmd BufWritePost $VIM_PATH/* execute eden#source_file(expand("%:p"))
  " augroup end
endfunction

function eden#source_if_exists(filename)
  if filereadable(a:filename)
    call eden#source_file(a:filename)
  endif
endfunction

function eden#source_file(filename)
  if a:filename =~ '.vim$'
    execute 'source' a:filename
  elseif a:filename =~ '.lua$'
    execute 'luafile' a:filename
  endif
endfunction

function eden#whichkey_init()
  " Define which-key directory here so that plugins can register their
  " bindings and description in place. If which-key is not installed
  " then this will not be used. If not used that is acceptable
  let g:which_key_map = {}
  let g:which_local_key_map = {}

  " Defining categories of mappings
  let g:which_key_map.b = { 'name' : '+buffer' }
  let g:which_key_map.c = { 'name' : '+code' }
  let g:which_key_map.f = { 'name' : '+find' }
  let g:which_key_map.g = { 'name' : '+vcs' }
  let g:which_key_map.t = { 'name' : '+toggle' }
endfunction

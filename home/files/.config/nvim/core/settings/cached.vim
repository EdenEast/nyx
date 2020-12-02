" Create nvim cache directory if it does not exist
call eden#path#create_dir(g:cache_root)

" Backups
let g:backup_dir = eden#path#join([g:cache_root, 'backup'])
call eden#path#create_dir(g:backup_dir)
let &backupdir = g:backup_dir

" Swap
let g:swap_dir = eden#path#join([g:cache_root, 'swap'])
call eden#path#create_dir(g:swap_dir)
let &directory = g:swap_dir
set updatecount=80  " update swap file every 80 characters typed
set updatetime=2000 " cursorhold interval for swap file
if exists('&swapsync')
  set swapsync=     " let OS sync swapfile lazily
endif

" Undo
if has('persistent_undo')
  let g:undo_dir = eden#path#join([g:cache_root, 'undo'])
  call eden#path#create_dir(g:undo_dir)
  let &undodir = g:undo_dir
  set undofile
endif

" Viminfo
if has('viminfo')
  let g:viminfo_file = eden#path#join([g:cache_root, 'viminfo'])
  let &viminfo = g:viminfo_file
endif

" Session views
if has('mksession')
  let g:session_dir = eden#path#join([g:cache_root, 'session'])
  call eden#path#create_dir(g:session_dir)
  let &viewdir = g:session_dir
  set viewoptions=cursor,folds " save/restore just these (with :{mk, load}view)
endif

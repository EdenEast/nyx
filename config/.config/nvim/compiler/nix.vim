" Vim compiler file
" Compiler:         `nix` command line

if exists("current_compiler")
  finish
endif

let current_compiler = "nix"

let s:cpo_save = &cpo
set cpo&vim

CompilerSet makeprg=nix

CompilerSet errorformat =
    \%trror:\ %m\ at\ %f:%l:%c

let &cpo = s:cpo_save
unlet s:cpo_save

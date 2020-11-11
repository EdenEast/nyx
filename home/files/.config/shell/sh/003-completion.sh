# setting git completion for yadm command
source $HOME/.local/etc/git/git-completion.bash
hash "yadm" &>/dev/null && __git_complete yadm __git_main && __git_complete y __git_main
__git_complete g __git_main


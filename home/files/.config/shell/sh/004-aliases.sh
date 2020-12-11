# directories
alias ..='cd ..'
alias cd..='cd ..'

# quick shortcuts
alias c=cargo
alias e=$EDITOR
alias g=git && __git_complete g __git_main
alias m=make
alias t=tmux
alias v=vim
alias y=yadm

alias cb='cargo b'
alias cc='cargo c'
alias ccp='cargo +nightly clippy -- -D warnings'
alias cf='cargo +nightly fmt --all'
alias cl="cargo clean"
alias cr='cargo r'
alias ct='cargo t'
alias cm=cmake
alias jt=just

alias psake='powershell -c Invoke-Psake'

# default command flags
[[ -n "$(command -v bat)" ]] && alias bat='bat --terminal-width $(tput cols)'
alias df="df -Tha --total"
alias egrep='egrep --color=auto'
alias grep='grep --color=auto'
alias pgrep='pgrep -l'

# git and yadm shortcuts
alias ga="git add"
alias gc="git commit --verbose"
alias gs="git status -s"
alias ya="yadm add"
alias yc="yadm commit --verbose"
alias ys="yadm status -s"

# tmux shortcuts
alias tn="tmux -u new"
alias ta="tmux -u attach"

# source rc file for your shell
[[ $SHELL =~ /bash$ ]] && alias src='source $HOME/.bashrc'
[[ $SHELL =~ /zsh$ ]] && alias src='source $HOME/.config/zsh/.zshrc'

# if exa is installed use that for ls
[[ -x "$(command -v exa)" ]] && {
    alias l="exa --group-directories-first --color=auto --git -a"
    alias ls="exa --group-directories-first --color=auto --git"
    alias ll="exa --group-directories-first --color=auto --git -la"
    alias lll="exa --group-directories-first --color=auto --git -l"
} || {
    # have to check if we are on a bsd system (cough, cough... mac) as
    # it does not have color mode because of course...
    [[ -n "$(command ls --color=auto)" ]] && ls_color='--color=always'
    alias l="ls --group-directories-first -ahCF $ls_color"
    alias ls="ls --group-directories-first -hCFG $ls_color"
    alias ll="ls --group-directories-first -alh $ls_color"
    alias lll="ls --group-directories-first -lh $ls_color"
    unset ls_color
}

[[ -x "$(command -v pacman)" ]] && {
    alias mirror='sudo reflector --protocol https --latest 50 --number 20 --sort rate --save /etc/pacman.d/mirrorlist'
    alias pacman="sudo pacman --color auto"
    alias paclist="comm -23 <(pacman -Qqett | sort) <(pacman -Qqg -g base-devel | sort | uniq)"
}


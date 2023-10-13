# directories
alias ..='cd ..'
alias cd..='cd ..'

# quick shortcuts
alias c=cargo
alias e=$EDITOR
alias g=git
alias j=just
alias m=make
alias n=nix
alias t=tm
alias v=vim
alias nn=nyx

# default command flags
[[ -n "$(command -v bat)" ]] && alias cat=bat
alias df="df -Tha --total"
alias egrep='egrep --color=auto'
alias grep='grep --color=auto'
alias pgrep='pgrep -l'

# git shortcuts
alias ga="git add"
alias gc="git commit --verbose"
alias gs="git status -s"

# if exa is installed use that for ls
if [[ -x "$(command -v eza)" ]]; then
  alias l="eza --group-directories-first --color=auto --git -a"
  alias ls="eza --group-directories-first --color=auto --git"
  alias ll="eza --group-directories-first --color=auto --git -la"
  alias lll="eza --group-directories-first --color=auto --git -l"
else
  # have to check if we are on a bsd system (cough, cough... mac) as
  # it does not have color mode because of course...
  [[ -n "$(command ls --color=auto)" ]] && ls_color='--color=always --group-directories-first'
  alias l="ls -ahCF $ls_color"
  alias ls="ls -hCFG $ls_color"
  alias ll="ls -alh $ls_color"
  alias lll="ls -lh $ls_color"
  unset ls_color
fi

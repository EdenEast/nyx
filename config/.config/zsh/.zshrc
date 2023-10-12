#
#    ███████╗███████╗██╗  ██╗██████╗  ██████╗
#    ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#      ███╔╝ ███████╗███████║██████╔╝██║
#     ███╔╝  ╚════██║██╔══██║██╔══██╗██║
# ██╗███████╗███████║██║  ██║██║  ██║╚██████╗
# ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
#

function_profile=false
command_profile=false

if [[ $function_profile == true ]]; then
    zmodload zsh/zprof
fi

if [[ $command_profile == true ]]; then
    zmodload zsh/datetime
    setopt promptsubst
    PS4='+$EPOCHREALTIME %N:%i> '
    exec 3>&2 2> startlog.$$
    setopt xtrace prompt_subst
fi

autoload -Uz compinit
compinit

if [ -d $HOME/.config/shell/sh ]; then
    for rc in $HOME/.config/shell/sh/*.sh; do
        emulate bash -c ". $rc"
    done
fi

# Source zsh specific configuration
if [[ -d $HOME/.config/shell/zsh ]]; then
    for rc in $HOME/.config/shell/zsh/*.zsh; do
        source $rc
    done
fi


[[ -f $HOME/.local/share/zsh/zshrc ]] && . $HOME/.local/share/zsh/zshrc

# Sourcing this after all local zsh files as this might have syntax highlighting
# which must be the last line in the source file
[[ -f $HOME/.local/share/zsh/nyx_zshrc ]] && . $HOME/.local/share/zsh/nyx_zshrc

if [[ $function_profile == true ]]; then
    zprof > startup-functions.log
fi

if [[ $command_profile == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
fi

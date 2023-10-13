#
#    ███████╗███████╗██╗  ██╗██████╗  ██████╗
#    ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#      ███╔╝ ███████╗███████║██████╔╝██║
#     ███╔╝  ╚════██║██╔══██║██╔══██╗██║
# ██╗███████╗███████║██║  ██║██║  ██║╚██████╗
# ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
#

# Profile ---------------------------------------------------------------------
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


# Completion ------------------------------------------------------------------
mkdir -p $HOME/.cache/zsh
export ZSH_COMPDUMP=$HOME/.cache/zsh/zcompdump
autoload -Uz compinit
if [ ! -f $ZSH_COMPDUMP ] || [ "$(find $ZSH_COMPDUMP -mtime +1)" ]; then
    # Either the compdump file does not exist or is older then a day, regen
    compinit -d "$ZSH_COMPDUMP"
fi
compinit -C -d $ZSH_COMPDUMP

# Load shared shell -----------------------------------------------------------
if [ -d $HOME/.config/shell/sh ]; then
    for rc in $HOME/.config/shell/sh/*.sh; do
        source $rc
    done
fi

# Source zsh specific configuration
if [[ -d $HOME/.config/shell/zsh ]]; then
    for rc in $HOME/.config/shell/zsh/*.zsh; do
        source $rc
    done
fi


# Source local profiles -------------------------------------------------------
[[ -f $HOME/.local/share/zsh/zshrc ]] && . $HOME/.local/share/zsh/zshrc

# Sourcing this after all local zsh files as this might have syntax highlighting
# which must be the last line in the source file
[[ -f $HOME/.local/share/zsh/nyx_zshrc ]] && . $HOME/.local/share/zsh/nyx_zshrc


# Post profile ----------------------------------------------------------------
if [[ $function_profile == true ]]; then
    zprof > startup-functions.log
fi

if [[ $command_profile == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
fi

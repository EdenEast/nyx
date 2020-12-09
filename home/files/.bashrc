#
#    ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗
#    ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔════╝
#    ██████╔╝███████║███████╗███████║██████╔╝██║
#    ██╔══██╗██╔══██║╚════██║██╔══██║██╔══██╗██║
# ██╗██████╔╝██║  ██║███████║██║  ██║██║  ██║╚██████╗
# ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
#

# if shell is not interactive then we be done here
[[ $- != *i* ]] && return

[[ -d $HOME/.config/shell/sh ]] && {
    for rc in $HOME/.config/shell/sh/*.sh; do
        source $rc
    done
}

# Source bash specific configuration
[[ -d $HOME/.config/shell/bash ]] && {
    for rc in $HOME/.config/shell/bash/*.bash; do
        source $rc
    done
}

[[ -f $HOME/.local/share/bash/nyx_bashrc ]] && . $HOME/.local/share/bash/nyx_bashrc
[[ -f $HOME/.local/share/bash/bashrc ]]     && . $HOME/.local/share/bash/bashrc

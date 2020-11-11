#
#    ██████╗ ██████╗  ██████╗ ███████╗██╗██╗     ███████╗
#    ██╔══██╗██╔══██╗██╔═══██╗██╔════╝██║██║     ██╔════╝
#    ██████╔╝██████╔╝██║   ██║█████╗  ██║██║     █████╗
#    ██╔═══╝ ██╔══██╗██║   ██║██╔══╝  ██║██║     ██╔══╝
# ██╗██║     ██║  ██║╚██████╔╝██║     ██║███████╗███████╗
# ╚═╝╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝
#

[[ -d $HOME/.config/shell/login ]] && {
    for rc in $HOME/.config/shell/login/*.sh; do
        source $rc
    done
}

[[ -f $HOME/.local/share/bash/profile ]] && . $HOME/.local/share/bash/profile

# lauch x server when logging in to tty1
[[ "$(tty)" = "/dev/tty1" ]] && {
    [[ -x $(command -v startx) ]] && {
        ( pgrep xinit &>/dev/null && echo "Note: X Server is already running." || startx )
    }
}


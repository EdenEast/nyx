#
#    ██████╗ ██████╗  ██████╗ ███████╗██╗██╗     ███████╗
#    ██╔══██╗██╔══██╗██╔═══██╗██╔════╝██║██║     ██╔════╝
#    ██████╔╝██████╔╝██║   ██║█████╗  ██║██║     █████╗
#    ██╔═══╝ ██╔══██╗██║   ██║██╔══╝  ██║██║     ██╔══╝
# ██╗██║     ██║  ██║╚██████╔╝██║     ██║███████╗███████╗
# ╚═╝╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝
#

# if nix is installed then source profile
[[ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]] && . $HOME/.nix-profile/etc/profile.d/nix.sh
[[ -f $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh ]] && . $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
[[ -f /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh ]] && . /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh

[[ -d $HOME/.config/shell/login ]] && {
    for rc in $HOME/.config/shell/login/*.sh; do
        source $rc
    done
}

[[ -f $HOME/.local/share/bash/nyx_profile ]] && . $HOME/.local/share/bash/nyx_profile
[[ -f $HOME/.local/share/bash/profile ]]     && . $HOME/.local/share/bash/profile

# lauch x server when logging in to tty1
[[ "$(tty)" = "/dev/tty1" ]] && {
    [[ -x $(command -v startx) ]] && {
        ( pgrep xinit &>/dev/null && echo "Note: X Server is already running." || startx )
    }
}


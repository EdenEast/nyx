#
#    ███████╗██████╗ ██████╗  ██████╗ ███████╗██╗██╗     ███████╗
#    ╚══███╔╝██╔══██╗██╔══██╗██╔═══██╗██╔════╝██║██║     ██╔════╝
#      ███╔╝ ██████╔╝██████╔╝██║   ██║█████╗  ██║██║     █████╗
#     ███╔╝  ██╔═══╝ ██╔══██╗██║   ██║██╔══╝  ██║██║     ██╔══╝
# ██╗███████╗██║     ██║  ██║╚██████╔╝██║     ██║███████╗███████╗
# ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝
#

# if nix is installed then source profile
[[ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]] && . $HOME/.nix-profile/etc/profile.d/nix.sh
[[ -f $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh ]] && . $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
[[ -f /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh ]] && . /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh

# loading all files from login.d
if [ -d $HOME/.config/shell/login ]; then
    for rc in $HOME/.config/shell/login/*.sh; do
        source $rc
    done
fi

[[ -f $HOME/.local/share/zsh/nyx_zprofile ]] && . $HOME/.local/share/zsh/nyx_zprofile
[[ -f $HOME/.local/share/zsh/zprofile ]] && . $HOME/.local/share/zsh/zprofile


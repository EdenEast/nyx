# if sccache is installed add that as a rustc wrapper
[[ -x "$(command -v sccache)" ]] && {
    # export RUSTC_WRAPPER="sccache"
    export SCCACHE_DIR="$HOME/.cache/sccache"
}

# if zoxide is insatlled then source helper scripts
[[ -x "$(command -v zoxide)" ]] && {
    export _ZO_DATA="$HOME/.cache/zoxide/data"
    mkdir -p $HOME/.cache/zoxide
}

# if git-delta is installed then use this as the git pager
[[ -n "$(command -v delta)" ]] && {
    export GIT_PAGER="delta --dark --theme TwoDark"
} || {
    export GIT_PAGER="less"
}


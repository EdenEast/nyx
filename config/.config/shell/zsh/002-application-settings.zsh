# if repo is installed then source the work script
[[ -x "$(command -v repo)" ]] && {
    [ -x "$(command -v fzf)" ] && eval "$(repo init zsh --fzf)" || eval "$(repo init zsh)"
}

# if zoxide is installed then source the helper script
[[ -x "$(command -v zoxide)" ]] && {
    eval "$(zoxide init zsh)"
}

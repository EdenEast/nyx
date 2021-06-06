# if repo is installed then soure the work script
[[ -x "$(command -v repo)" ]] && {
    [ -x "$(command -v fzf)" ] && eval "$(repo init zsh --fzf)" || eval "$(repo init zsh)"
}

# if zoxide is insatlled then source helper scripts
[[ -x "$(command -v zoxide)" ]] && {
    eval "$(zoxide init zsh)"
}

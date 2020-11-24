# If starship prompt is installed use that prompt if not then fallback to
# my custom minimal-prompt
[ -n "$(command -v starship)" ] && {
    eval "$(starship init bash)"
} || {
    source "$HOME/.config/shell/bash/minimal-prompt"
}

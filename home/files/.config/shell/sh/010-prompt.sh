
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# If starship prompt is installed use that prompt if not then fallback to
# my custom minimal-prompt
[ -n "$(command -v starship)" ] && {
    eval "$(starship init bash)"
} || {
    source "$HOME/.config/shell/bash.d/010-minimal-prompt"
}


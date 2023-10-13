# if repo is installed then soure the work script
if [ "$(command -v repo)"]; then
  eval "$(repo init zsh --fzf)"
fi

# if zoxide is insatlled then source helper scripts
if [ "$(command -v zoxide)" ]; then
  eval "$(zoxide init zsh)"
fi

eval "$(wt source)"

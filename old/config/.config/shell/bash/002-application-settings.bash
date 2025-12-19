# if repo is installed then soure the work script
if [ "$(command -v repo)" ]; then
  eval "$(repo init bash --fzf)"
fi

# if zoxide is insatlled then source helper scripts
if [ "$(command -v zoxide)" ]; then
  eval "$(zoxide init bash)"
fi

eval "$(git-wt source)"

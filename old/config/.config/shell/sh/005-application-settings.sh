# if zoxide is insatlled then source helper scripts
if [ $(command -v zoxide) ]; then
  export _ZO_DATA="$HOME/.cache/zoxide/data"
  mkdir -p $HOME/.cache/zoxide
fi

# if git-delta is installed then use this as the git pager
if [ $(command -v delta) ]; then
  export GIT_PAGER="delta --dark"
else
  export GIT_PAGER="less"
fi

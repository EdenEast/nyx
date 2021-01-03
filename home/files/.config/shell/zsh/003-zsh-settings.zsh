HISTSIZE=10000
SAVEHIST=10000

HISTFILE=$HOME/.cache/zsh/history
mkdir -p $(dirname "$HISTFILE")

# https://www.commandlinux.com/man-page/man1/zshoptions.1.html
setopt   HIST_FCNTL_LOCK        # Better file lock call with histfile
setopt   HIST_IGNORE_DUPS       # Ignore command if duplicate of prev event
setopt   HIST_IGNORE_SPACE      # Ignore command if starts with a space
setopt   HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first
setopt   SHARE_HISTORY          # Share history between zsh sessions
unsetopt EXTENDED_HISTORY       # Make sure no timestamps in histfile

# Ignore case completion for zsh
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'


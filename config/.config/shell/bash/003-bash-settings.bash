# https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html#Bash-Variables
HISTSIZE=10000
HISTFILE="$HOME/.cache/bash/history"
mkdir -p $(dirname "$HISTFILE")

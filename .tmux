#!/bin/sh

# create new session with session-name `nyx` and a new window called `code`
tmux new-session -s nyx -n code -d

# create lorri daemon window and start `lorri daemon`
tmux new-window -t nyx -n lorri -d
tmux send-keys -t nyx:lorri "lorri daemon" Enter

# reattach to window
tmux select-window -t nyx:code
tmux -u attach -t nyx

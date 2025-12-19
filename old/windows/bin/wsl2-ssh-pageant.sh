#!/usr/bin/env bash

pagfile="$HOME/.ssh/wsl2-ssh-pageant.exe"

if [ -x "$pagfile" ]; then
  mv "$pagfile" "${pagfile}.bak"
fi

wget -O "$pagfile" "https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/latest/download/wsl2-ssh-pageant.exe"

if [ -f "$pagfile" ]; then
  chmod +x "$pagfile"
  rm "$pagfile.bak"
fi

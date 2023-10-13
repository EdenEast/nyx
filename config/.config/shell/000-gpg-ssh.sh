# For wsl2 to access yubikey from windows
# https://github.com/BlackReloaded/wsl2-ssh-pageant
# Note: This has been archived. I made a fork just to be safe

function wsl_ssh_and_gpg() {
  local windows_dest="/mnt/c/Users/Public/wsl2-ssh-pageant.exe"
  local linux_dest="$HOME/.ssh/wsl2-ssh-pageant.exe"

  if [[ -z $WSL_LOCAL_APPDATA ]]; then
    echo 'Please define $WSL_LOCAL_APPDATA. Example "C\:/Users/<Name>/Appdata/Local/gnupg"'
    echo 'Define this in either "~/.local/share/zsh/zprofile" or "~/.local/share/bash/profile"'
    return
  fi

  # This was the first method to get the local appdata. This breaks tmux vertical split.
  # local appdata_path="$(wslvar LOCALAPPDATA | cut -c 2- | sed -e 's@\\@/@g')"
  # local socket_path="C\\${appdata_path}/gnupg"

  local socket_path="$WSL_LOCAL_APPDATA/gnupg"
  if [[ ! -x $windows_dest ]]; then
    wget -O "$windows_dest" "https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/latest/download/wsl2-ssh-pageant.exe"
    chmod +x "$windows_dest"
  fi

  if [[ ! -L $linux_dest ]]; then
    mkdir -p ~/.ssh
    ln -s "$windows_dest" "$linux_dest"
  fi

  export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
  if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
    rm -f "$SSH_AUTH_SOCK"
    if test -x "$linux_dest"; then
      (setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$linux_dest -gpgConfigBasepath ${socket_path}" >/dev/null 2>&1 &)
    else
      echo >&2 "WARNING: $linux_dest is not executable."
    fi
  fi

  export GPG_AGENT_SOCK="$HOME/.gnupg/S.gpg-agent"
  if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
    rm -rf "$GPG_AGENT_SOCK"
    if test -x "$linux_dest"; then
      (setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$linux_dest -gpgConfigBasepath ${socket_path} --gpg S.gpg-agent" >/dev/null 2>&1 &)
    else
      echo >&2 "WARNING: $linux_dest is not executable."
    fi
  fi
}

if [[ $(uname -r) =~ microsoft ]]; then
  wsl_ssh_and_gpg
elif [[ $(uname -s) != "Darwin" ]]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

unset wsl_ssh_and_gpg

# vim: set ft=sh

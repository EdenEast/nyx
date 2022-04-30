# For wsl2 to access yubikey from windows
# https://github.com/BlackReloaded/wsl2-ssh-pageant

if [[ $(uname -r) =~ microsoft ]]; then
  wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
  local_appdata_path="$(powershell.exe write-host '$env:LOCALAPPDATA' | cut -c 2- | sed -e 's@\\@/@g')"
  socket_path="C\\${local_appdata_path}/gnupg"
  export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
  if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
    rm -f "$SSH_AUTH_SOCK"
    if test -x "$wsl2_ssh_pageant_bin"; then
      (setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin -gpgConfigBasepath ${socket_path}" >/dev/null 2>&1 &)
    else
      echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
    fi
  fi

  export GPG_AGENT_SOCK="$HOME/.gnupg/S.gpg-agent"
  if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
    rm -rf "$GPG_AGENT_SOCK"
    if test -x "$wsl2_ssh_pageant_bin"; then
      (setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin -verbose -gpgConfigBasepath ${socket_path} --gpg S.gpg-agent" >/dev/null 2>&1 &)
    else
      echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
    fi
  fi

  unset wsl2_ssh_pageant_bin
  unset local_appdata_path
  unset socket_path
else
  if [[ $(uname -s) != "Darwin" ]]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  fi
fi

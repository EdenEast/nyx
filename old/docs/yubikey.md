# YubiKey

## Setup with WSL2

This is required to make wsl able to access the Yubikey from windows.

### Windows

```powershell
choco install gpg4win putty
mkdir %HOMEPATH%\AppData\Roaming\gnupg
(echo enable-ssh-support & echo enable-putty-support) > %HOMEPATH%\AppData\Roaming\gnupg\gpg-agent.conf
echo "reader-port Yubico YubiKey OTP+FIDO+CCID 0" > %HOMEPATH%\AppData\Roaming\gnupg\scdaemon.conf
```

### Wsl

```bash
sudo apt install socat
mkdir -p ~/.ssh
wget https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/latest/download/wsl2-ssh-pageant.exe -O ~/.ssh/wsl2-ssh-pageant.exe
chmod +x ~/.ssh/wsl2-ssh-pageant.exe
```

For `wsl2-ssh-pageant` it requires that these are in your profile
```sh
# SSH
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
ss -a | grep -q $SSH_AUTH_SOCK
if [ $? -ne 0 ]; then
  rm -f $SSH_AUTH_SOCK
  (setsid nohup socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:$HOME/.ssh/wsl2-ssh-pageant.exe >/dev/null 2>&1 &)
fi
# GPG
export GPG_AGENT_SOCK=$HOME/.gnupg/S.gpg-agent
ss -a | grep -q $GPG_AGENT_SOCK
if [ $? -ne 0 ]; then
  rm -rf $GPG_AGENT_SOCK
  (setsid nohup socat UNIX-LISTEN:$GPG_AGENT_SOCK,fork EXEC:"$HOME/.ssh/wsl2-ssh-pageant.exe --gpg S.gpg-agent" >/dev/null 2>&1 &)
fi
```

### Resources

- Yubikey on WSL2
  - [part 1](https://dev.to/dzerycz/the-ultimate-guide-to-yubikey-on-wsl2-part-1-5aed)
  - [part 2](https://dev.to/dzerycz/the-ultimate-guide-to-yubikey-on-wsl2-part-2-kli)
- gpg/ssh keys in wsl2 and yubikey
  - [post](https://snapcraft.ninja/2020/07/30/gpg-ssh-keys-in-wsl2-with-yubikeys/)
- Good windows and yubikey info
  - [post](https://codingnest.com/how-to-use-gpg-with-yubikey-wsl/)


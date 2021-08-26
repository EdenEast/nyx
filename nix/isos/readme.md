# Iso images

This is a directory that stores iso images.

## Yubukey installer

Liveusb installer where I can use my yubikey for git creds.

Build the installer and copy it to a USB drive.

```bash

$ nix build -f yubikey-installer.nix --out-link installer

$ sudo cp -v installer/iso/*.iso /dev/sdb; sync
'installer/iso/nixos-20.03.git.c438ce1-x86_64-linux.iso' -> '/dev/sdb'
```

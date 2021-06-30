# Sloth

## Overview

This is an old lanovo T530 laptop.

## Machine setup

```bash
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart primary 512MiB -8GiB
parted /dev/sda -- mkpart primary linux-swap -8GiB 100%
parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/sda -- set 3 esp on

mkfs.ext4 -L nixos /dev/sda1
mkfs.fat -F 32 -n boot /dev/sda3
mkswap -L swap /dev/sda2
swapon /dev/sda2

mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```

Once the disk has been setup this flake can then be cloned and used.

```bash
# Shell with flake support
nix-shell -p nixFlakes

# Write config file to nix config location to enable nix command and flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

# Clone and cd into nyx repo
git clone https://github.com/edeneast/nyx && cd nyx

# Edit flake.nix file to comment out internal.hostConfigurations.sloth

# Install nixos with flake
sudo nixos-install --root /mnt --flake .#sloth
```

### Note on nixos-install

There is currently some issues with `nixos-install` and a dependency in `home-manager`. 
There is an error saying that accessing `nmd` in the `/nix/store` is forbidden.

See [discourse] discussion and nix [issue-4081] and nixpkgs [issue-126141].

My current workaround is to comment out `internal.hostConfigurations.sloth` before the
`nixos-install` command.

[discourse]: https://discourse.nixos.org/t/how-to-get-nixos-install-flake-to-work/10069
[issue-4081]: https://github.com/NixOS/nix/issues/4081
[issue-126141]: https://github.com/NixOS/nixpkgs/issues/126141




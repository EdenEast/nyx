# Thor

Headless x86_64 desktop for remote development. Includes key-only SSH, Eden's
shell and editor setup, tmux, direnv, Node.js, Python, Rust tooling, and Tailscale.
Sleep and hibernation are disabled.

The previous Thor configuration, preserved in git at `cc54598b^:hosts/thor`,
used legacy BIOS with GRUB. Its README lists an Intel i7-3770S, 16 GB RAM,
a 128 GB SSD, and two 1 TB HDDs. GRUB targeted the Crucial SSD at
`/dev/disk/by-id/ata-M4-CT128M4SSD2_000000001224090D56BE`.

This configuration uses legacy BIOS and the replacement 1 TB Crucial BX500 SSD
at `/dev/disk/by-id/ata-CT1000BX500SSD1_2532E9C88DC5`. Verify that this path
points to the intended SSD before installing. `disko.nix` defines ext4 root
and FAT32 `/boot`. The hardware configuration was generated on Thor with
`--no-filesystems`. The previous `/data` mount and homelab
services are not enabled in this development host.

## Prepare the configuration

The `eden` account accepts the public keys in `secrets/publicKeys/eden_*.pub`.
Currently that includes `eden_wrath.pub`. Thor also authorizes the setup
client's hardware-backed `eden@rize` public key in `configuration.nix`.
Confirm you have an authorized private key on
your connecting machine, or add your client's public key to that directory
with the same naming pattern. Never copy the client's private key to the server.

Eden has passwordless sudo and no usable local password. Root SSH login is
disabled. Verify that your client has an authorized key before installing.

If the SSD has changed, update `disko.devices.disk.main.device` in `disko.nix`
to the whole boot disk's actual path. GRUB uses that same value. Disko creates
a GPT layout with a 1 MiB unformatted BIOS boot partition of type `EF02`,
a 512 MiB FAT32 `/boot` partition, and ext4 root using the remaining space.

## Boot without a keyboard or monitor

Build the custom minimal installer on your development machine:

```bash
cd /home/eden/.local/nyx
git add installers/thor.nix packages/thor-installer hosts/thor
nix build .#thor-installer --accept-flake-config --out-link result-thor-installer
```

The ISO is `result-thor-installer/iso/thor-installer.iso`. Flash it to your USB
using the same tool you used for the stock installer. This replaces the USB's
contents. The image supports legacy BIOS and UEFI and selects its default
boot entry after five seconds. Thor's firmware still needs to boot from USB;
the image cannot change the firmware's boot order.

Connect Thor to your router with Ethernet, insert the USB, and power on.
Find `thor-installer` in your router's DHCP leases and connect from the machine
holding an authorized private key:

```bash
ssh nixos@THOR_IP
```

Replace `THOR_IP` with the DHCP address. The installer authorizes the same
`secrets/publicKeys/eden_*.pub` keys as the installed host and starts SSH
automatically. No password setup is needed. Password login and root SSH are
disabled. The installer does not partition or install anything automatically.

In the SSH session, start tmux so installation can continue through a dropped
connection, then copy the configuration embedded in the image:

```bash
tmux new -A -s install
mkdir -p ~/nyx
cp -r /etc/thor-nyx/. ~/nyx/
chmod -R u+w ~/nyx
cd ~/nyx
git init
git add .
```

This is the checkout used when the ISO was built. Changes made after the ISO
build must be copied over SSH separately. Internet access is still needed to
download installation dependencies.

## Install over SSH

Inspect the disks with `lsblk -f` and `ls -l /dev/disk/by-id/`. Confirm the configured SSD
path points to your intended install disk. The Disko script below erases and
partitions that SSD, then mounts root at `/mnt` and boot at `/mnt/boot`.
Back up anything you need on the SSD first. Only the SSD is declared in
Disko; the two data HDDs are left alone.

Run these commands from `~/nyx` in the installer's SSH session:

```bash
# Git flakes only include tracked files. Stage the host and any added public keys.
git add hosts/thor secrets/publicKeys

# Build the partitioning script using this flake's pinned Disko input.
nix --extra-experimental-features 'nix-command flakes' build \
  .#nixosConfigurations.thor.config.system.build.diskoScript \
  --accept-flake-config --out-link /tmp/thor-disko

# DESTRUCTIVE: erases the configured SSD, formats it, and mounts it at /mnt.
sudo /tmp/thor-disko

# Disko provides filesystem definitions, so exclude them from generated hardware.
sudo nixos-generate-config --root /mnt --no-filesystems
sudo cp /mnt/etc/nixos/hardware-configuration.nix hosts/thor/hardware.nix
git add hosts/thor/hardware.nix

nix --extra-experimental-features 'nix-command flakes' build \
  .#nixosConfigurations.thor.config.system.build.toplevel \
  --accept-flake-config --no-link
sudo nixos-install --flake .#thor --no-root-passwd

# Preserve the writable configuration and generated hardware on the installed SSD.
sudo mkdir -p /mnt/home/eden/.local/nyx
sudo cp -a ~/nyx/. /mnt/home/eden/.local/nyx/
sudo chown -R 1000 /mnt/home/eden/.local
sudo poweroff
```

Remove the USB after shutdown, then power on Thor. Check its DHCP address
again and connect as `eden`, using the same authorized key. The installed
system generates a new SSH host key. If SSH reports the expected key change
for that IP, remove the installer's entry with `ssh-keygen -R THOR_IP` before
connecting again.

Keep the generated hardware file in your working copy so future rebuilds use
the desktop's actual kernel modules and CPU settings. Disko provides the
filesystem definitions, so always use `--no-filesystems` when regenerating
hardware configuration. Keep both
`stateVersion` values at `26.05` after installation.

## Connect and develop

Find the desktop's DHCP address on your router or with `ip -br address` on its
console. From a client with an authorized SSH key:

```bash
ssh eden@DESKTOP_IP
```

For access over your tailnet, run `sudo tailscale up` on the server and follow
the login URL. Then connect with `ssh eden@thor` if MagicDNS is enabled, or
use the server's Tailscale IP. This uses the same OpenSSH authorized keys.

Start or resume a persistent development session with `tmux new -A -s dev`.
VS Code Remote SSH can connect to `eden@DESKTOP_IP` as well. Nix shells and
direnv provide project-specific dependencies. For Rust, install a toolchain
with `rustup default stable` when needed.

Keep a writable checkout in `~/.local/nyx` for later configuration changes.
Rebuild from that checkout with:

```bash
sudo nixos-rebuild switch --flake .#thor
```

## Deploy with Colmena

Colmena connects to Thor as `eden` and uses passwordless sudo for activation.
From another machine with an authorized SSH key, build or copy the configuration
with:

```bash
nix develop --command thor build
nix develop --command thor push
```

Before activating the configuration that imports `secrets.nix`, encrypt the
Tailscale auth secret for Thor's SSH host key. On a machine that can already
decrypt the secrets, such as Wrath, run from its checkout:

```bash
nix develop
ssh eden@thor 'sudo cat /etc/ssh/ssh_host_ed25519_key.pub' > secrets/publicKeys/root_thor.pub
git add secrets/publicKeys/root_thor.pub
cd secrets
ragenix --rekey
```

Bring the new public key and rekeyed secrets back to the deploying checkout,
then activate with:

```bash
nix develop --command thor switch
```

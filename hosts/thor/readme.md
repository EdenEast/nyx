# Thor

## Overview

Headless x86_64 desktop for remote development over SSH and Tailscale.
Sleep and hibernation are disabled.

## Specs

| Component | Details              |
| --------- | -------------------- |
| CPU       | Intel i7-3770S       |
| RAM       | 16GB                 |
| Storage   | 1TB Crucial BX500 SSD |
| Boot      | Legacy BIOS, GRUB    |

## Filesystems

| Mount   | Format | Size                 |
| ------- | ------ | -------------------- |
| `/`     | Ext4   | Remaining SSD space  |
| `/boot` | FAT32  | 512MiB               |

[disko.nix](./disko.nix) defines the SSD layout. The two 1TB data HDDs are
not mounted.

## Remote development

Connect with an authorized SSH key and start a persistent session:

```bash
ssh eden@thor
tmux new -A -s dev
```

Use Thor's IP address if Tailscale MagicDNS is unavailable. Nix shells and
direnv provide project dependencies.

Install or update Claude Code, Codex, and Pi with:

```bash
agent-tools-update
```

## T3 headless browser

T3 downloads a pinned Chrome for Testing headless shell under
`~/.t3/tools/chrome-headless-shell`. It does not use the Chromium installed by
Home Manager. No desktop environment or display server is needed.

`configuration.nix` adds that shell's runtime dependencies to Thor's existing
`programs.nix-ld.libraries`. The default nix-ld libraries already include
systemd's `libudev`; `at-spi2-core` supplies ATK and the AT-SPI bridge libraries.
Thor's existing Fontconfig setup supplies fonts.

After an authorized NixOS activation, retry `html_preview` in T3. Do not run
the suggested `sudo t3 browser setup` distro installer on NixOS. To check the
browser directly, substitute the version T3 has installed:

```bash
browser="$HOME/.t3/tools/chrome-headless-shell/linux64/<version>/chrome-headless-shell"
"$browser" --version
work=$(mktemp -d)
env -u DISPLAY -u WAYLAND_DISPLAY "$browser" \
  --headless --disable-gpu --user-data-dir="$work/profile" \
  --screenshot="$work/preview.png" --window-size=728,300 \
  'data:text/html,<html><body><h1>Thor headless preview</h1></body></html>'
```

This uses an isolated temporary profile and leaves a PNG in `$work`. Keep the
sandbox enabled; `--no-sandbox` is not a fix for missing shared libraries.
Activation changes the system-wide nix-ld library path and requires separate
approval. Building or evaluating the configuration alone does not activate it.

## Obsidian Sync

Obsidian Headless is installed through Nix. The user service syncs
`~/vaults/codex` continuously, including after SSH disconnects and at boot.
It stays inactive until setup completes. Notes and all attachment types sync
bidirectionally, along with core and community plugins and their settings.
General application, appearance, and hotkey settings are excluded.

Back up your existing vault before first use, then run as `eden` on Thor:

```bash
ob login
ob sync-list-remote
obsidian-sync-setup
```

Setup prompts for authentication and the vault encryption password, performs
the first sync, then starts the service. Credentials and sync state remain in
the home directory, outside the Nix store. Edit notes with any terminal editor.

```bash
systemctl --user status obsidian-sync
journalctl --user -u obsidian-sync -f
ob sync-status --path ~/vaults/codex
ob sync-config --path ~/vaults/codex
```

For a temporary deployment without changing the boot configuration:

```bash
nix develop --command colmena apply-local --sudo --node thor test
```

## Obsidian backups

Thor's Restic configuration backs up the vault hourly to TrueNAS over SFTP.
See [backup setup and recovery](./backup.md) for NAS account setup, credentials,
activation, verification, and restoring notes. NAS provisioning and a verified
SSH host key are required before backups can run.

## Rebuild

From `~/.local/nyx` on Thor:

```bash
sudo nixos-rebuild switch --flake .#thor
```

Or deploy from another machine with an authorized SSH key:

```bash
nix develop --command thor switch
```

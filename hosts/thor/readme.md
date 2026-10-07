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

## Rebuild

From `~/.local/nyx` on Thor:

```bash
sudo nixos-rebuild switch --flake .#thor
```

Or deploy from another machine with an authorized SSH key:

```bash
nix develop --command thor switch
```

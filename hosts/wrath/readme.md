# Wrath

## Overview

Framework 13 laptop with `AMD Ryzen 5 7640U`.

---

## Specs

| Component   | Details                        |
| ----------- | ------------------------------ |
| **Model**   | Framework 13 AMD Ryzen 5 7640U |
| **CPU**     | AMD Ryzen 5 7640U              |
| **RAM**     | 16GB DDR5-5600 (2x8)           |
| **Storage** | 1TB NVMe SSD                   |
| **Display** | 13" 2256x1504 60Hz             |

---

## Filesystems

### `/` (Root)

- **Format**: Ext4.

---

## Display

- **Scaling**: Scaled to 1.25x.

---

## Agent tools

Claude Code, Codex, Pi, and T3 Code update too frequently for the pinned Nix
packages on this host. Nix provides Node.js, AppImage support, and the update
command, while npm and T3 own their writable installations under `~/.local`.

Install or update all command-line tools after a rebuild with:

```bash
agent-tools-update
```

The command installs the latest Claude Code, Codex, and Pi npm packages. It also
installs or updates the T3 Code CLI and the current T3 Code Desktop AppImage.
Existing credentials and application data remain in their normal home-directory
locations.

The desktop AppImage lives at
`~/.local/opt/t3-code/T3-Code.AppImage`. The updater verifies it against the
SHA-256 digest published with the GitHub release before replacing the installed
version. Home Manager provides both the application-menu entry and the
`t3-code-desktop` command.

---

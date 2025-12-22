# Nyx

[![Build](https://github.com/EdenEast/nyx/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/EdenEast/nyx/actions/workflows/build.yml)
[![NixOS 25.11](https://img.shields.io/badge/NixOS-v25.11-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)
[![Licence](https://img.shields.io/badge/license-Unlicense-blue)](https://github.com/EdenEast/nyx/blob/main/LICENSE)

## Structure

```
.
├── flake.nix         # Main entry point
├── config/           # Application files used by home-manager or symlinked
├── hosts/            # Machine configuration entry point
│   ├── home/         # Standalone home hosts
│   └── nixos/        # Nixos hosts
└── modules/          # Modular
    ├── flake/        # Main entry point into the flake
    │   ├── home.nix  # Home-manager configuration setup
    │   ├── lib.nix   # Main library
    │   ├── nixos.nix # Nixos-specific
    │   └── ...       # Other flake components
    ├── home/         # Home-manager modules
    ├── nixos/        # NixOS-specific modules
    └── snippets/     # Reusable configuration snippets
```

## Todo

- [ ] Document readme
- [ ] Runelite
- [ ] Nushell
- [ ] niri desktop setup
- [ ] hyperland desktop setup
- [ ] nixos-wsl and standalone home-manager
- [ ] Some sort of backup solution like [borgmatic](https://torsion.org/borgmatic/) [borgbackup](https://www.borgbackup.org/) or drive

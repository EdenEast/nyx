# Nyx

[![Build](https://github.com/EdenEast/nyx/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/EdenEast/nyx/actions/workflows/build.yml)
[![NixOS 25.11](https://img.shields.io/badge/NixOS-v25.11-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)
[![Licence](https://img.shields.io/badge/license-Unlicense-blue)](https://github.com/EdenEast/nyx/blob/main/LICENSE)

Welcome to my Nixos and Dotfiles configuration!

This repository contain my NixOS, and home-manager configurations for all my systems as well as the modules that they
are built upon.

Some notable areas for others would be:

| Area | Description |
| -----: | :----- |
| [Neovim](https://github.com/edeneast/nvim-config) | Self contained neovim flake |
| [Git](./config/.config/git) | Highly customized and documented git configuration and extensions |


## Structure

```
.
├── flake.nix         # Main entry point
├── config/           # Application files used by home-manager or symlinked
├── hosts/            # Machine configuration entry point
│   ├── home/         # Standalone home hosts
│   └── nixos/        # Nixos hosts
└── modules/          # Modules
    ├── flake/        # Main entry point into the flake
    │   ├── home.nix  # Home-manager configuration setup
    │   ├── lib.nix   # Main library
    │   ├── nixos.nix # Nixos-specific
    │   └── ...       # Other flake components
    ├── home/         # Home-manager modules
    ├── nixos/        # NixOS-specific modules
    └── snippets/     # Reusable configuration snippets
```

## Resources, References and Acknowledgements

These public repositories have been used as example references and resources for this project configuration. The main
project architecture is based off of [alyraffauf's](https://aly.codes/) [configuration][nixcfg], a well structured
and modular setup based on [flake-parts](https://flake.parts/) which has been a great resource.

- [alyraffauf/nixcfg][nixcfg]
  - Very good modular structure based around flake-parts.
- [calops/nix](https://github.com/calops/nix)
  - Nix home and nixos configuration [blueprint](https://github.com/numtide/blueprint) and niri as a wm
- [hmajid2301/nixicle](https://github.com/hmajid2301/nixicle)
  - Multiple window managers with multiple Quickshell modules (dms, caelestia, noctalia)
- [TophC7/dot.nix](https://github.com/TophC7/dot.nix)
  - niri setup with dms

[nixcfg]: https://github.com/alyraffauf/nixcfg

## Todo

- [ ] Runelite
- [ ] Nushell
- [ ] hyperland desktop setup
- [ ] nixos-wsl and standalone home-manager
- [ ] Some sort of backup solution like [borgmatic](https://torsion.org/borgmatic/) [borgbackup](https://www.borgbackup.org/) or drive

# Nyx

[![Build](https://github.com/EdenEast/nyx/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/EdenEast/nyx/actions/workflows/build.yml)
[![NixOS 25.05](https://img.shields.io/badge/NixOS-v25.05-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)
[![Licence](https://img.shields.io/badge/license-Unlicense-blue)](https://github.com/EdenEast/nyx/blob/main/LICENSE)

This repository provides configuration files for all of my Unix-based systems, including NixOS, Linux, and macOS, using
[`nix`][nix]. It also contains my dotfiles, which are shared across all these systems as well as Windows. On platforms
that support [`nix`][nix], my dotfiles are managed with [home-manager].

[nix]: https://nixos.org/
[home-manager]: https://github.com/nix-community/home-manager

## Structure

```
.
├── flake.nix          # Main entry point
├── bin                # Scripts added to $Path
├── config             # Application configuration files used by home-manager or symlinked
├── home               # Home-manager confiugrations root folder
│   ├── common         # Common variables used accross hosts
│   ├── hosts          # Home-manager standalone hosts (mainly non-nixos systems)
│   ├── modules        # Home-manager modules
│   └── profiles       # Home manager module configuration definition grouped by theme
├── lib                # Flake's utility library
├── nix                # Nixpkgs configurations
│   ├── isos           # Configurations that build ISO's
│   ├── overlays       # Nixpkgs Overlays
│   ├── pkgs           # Nixpkgs package definitions
│   └── templates      # Template defintions
├── system             # Machine configurations for both nixos and darwin
│   ├── common         # Shared defitions between nxios and darwin
│   │   ├── modules    # Common module definitions between nixos and darwin
│   │   └── profiles   # Common profile definitions between nixos and darwin
│   ├── darwin         # MacOS machine confiugrations
│   │   ├── hosts      # Host machine confiugrations
│   │   ├── modules    # Darwin modules
│   │   └── profiles   # Darwin profiles
│   └── nixos          # NixOS machine confiugrations
│       ├── hosts      # Host machine confiugrations
│       ├── modules    # NixOS modules
│       └── profiles   # NixOS profiles
├── user               # Confiugration and variable defined for a specific user
└── windows            # Scripts and configuration related to settings up windows machines
```


## Dotfiles

My `.dotfiles` are located in the `config/` directory. When using Nix and this flake repository, these files are managed
automatically by `home-manager`, which sources configurations directly from the `config/` folder. This setup also makes
it easy to use my configurations on systems not managed by Nix (such as Windows): I simply symlink the files from
`config/` to their appropriate locations. Notable configurations include:

- [Neovim](https://github.com/edeneast/nvim-config)
- [Git](./config/.config/git)
- [Awesome](./config/.config/awesome)
- [Bash/Zsh](./config/.config/shell)

## Hosts

| Configuration | Type   | Description                                      |
| ------------- | ------ | ------------------------------------------------ |
| [wrath]       | System | Framework Laptop 13 AMD 7640U                    |
| [eden]        | Home   | Generic home config for non nixos machines (wsl) |
| [pride]       | System | Asus UX331U notebook laptop                      |
| [sloth]       | System | An old lenovo T530 Laptop                        |

[wrath]: ./system/nixos/hosts/wrath
[eden]: ./home/hosts/eden.nix
[pride]: ./system/nixos/hosts/pride
[sloth]: ./system/nixos/hosts/sloth

## Ci/Cd

I use GitHub Actions workflows to automatically build my configurations and deploy the results to a binary cache server
via [cachix]. Twice a month, a workflow creates a pull request that updates the flake lock file. This pull request
action compares the differences in packages between the current and updated lockfiles. It also runs a security scan using
[vulnix]. The results, including a detailed report, are posted in the pull request so I can review and accept the changes.

[cachix]: https://app.cachix.org/cache/edeneast
[vulnix]: https://github.com/flyingcircusio/vulnix

## Resources

### Manuals

- [Nix][nix-manual] - The expression language and package manager
- [Nixpkgs][nixpkgs-manual] - The repository of packages
- [NixOS][nixos-manual] - The operating system built on top of nix
- [Home Manager][home-manager-manual] - Manage user environments

### Learning

- [Awesome Nix][awe-nix] - A curated list of the best resources in the Nix community.
- [Learn][nix-learn] - Home page for learning the nix eco-system
- [NixOS Wiki][wiki] - Community maintained wiki
- [Nix Pills][nix-pills] - A learn nix by example understanding how it works step by step
- [nix.dev][nix-dev] - An opinionated guide for developers getting things done using the Nix ecosystem
- [NixOS Guide][nixos-guide] - A collection of resources about different topics for nixos

### Flakes

- Nix Flakes Series by [Eelco Dolstra][edolstra]. Great introduction to flakes
  - [Part 1][flake-1] - An introduction and tutorial
  - [Part 2][flake-2] - Evaluation caching
  - [Part 3][flake-3] - Managing NixOS systems
- [Flake wiki][flake-wiki] - Wiki page on flakes

I agree with [@hlissner][hlissner]. This is needed when nix [drives you to drink][drive-to-drink].

[nix-manual]: https://nixos.org/manual/nix/stable/
[nixpkgs-manual]: https://nixos.org/manual/nixpkgs/stable/
[nixos-manual]: https://nixos.org/manual/nixos/stable/
[home-manager-manual]: https://nix-community.github.io/home-manager/
[awe-nix]: https://nix-community.github.io/awesome-nix/
[nix-learn]: https://nixos.org/learn.html
[wiki]: https://nixos.wiki/
[nix-pills]: https://nixos.org/guides/nix-pills/
[nix-dev]: https://nix.dev/
[nxios-guide]: https://github.com/mikeroyal/NixOS-Guide
[edolstra]: https://github.com/edolstra
[flake-1]: https://www.tweag.io/blog/2020-05-25-flakes/
[flake-2]: https://www.tweag.io/blog/2020-06-25-eval-cache/
[flake-3]: https://www.tweag.io/blog/2020-07-31-nixos-flakes/
[flake-wiki]: https://nixos.wiki/wiki/Flakes
[drive-to-drink]: https://youtu.be/Eni9PPPPBpg

## References

- [@davidwco](https://github.com/davidtwco) [veritas](https://github.com/davidtwco/veritas)
- [@hlissner](https://github.com/hlissner) [dotfiles](https://github.com/hlissner/dotfiles)
- [@LEXUGE](https://github.com/LEXUGE) [nixos](https://github.com/LEXUGE/nixos)
- [@utdemir](https://github.com/utdemir) [dotfiles](https://github.com/utdemir/dotfiles)
- [@cole-mickens](https://github.com/cole-mickens) [nixcfg](https://github.com/cole-mickens/nixcfg)
- [@pinpox](https://github.com/pinpox) [nixos](https://github.com/pinpox/nixos)
- [@MayNiklas](https://github.com/MayNiklas) [nixos](https://github.com/MayNiklas/nixos)
- [@yurrriq](https://github.com/yurrriq) [dotfiles](https://github.com/yurrriq/dotfiles)

[hlissner]: https://github.com/hlissner

## TODO

- [ ] handle wsl now that wsl-ssh-pageant is archived. Resources [here](https://neurrone.com/posts/yubikeys-in-2023/)
  [here](https://github.com/masahide/OmniSSHAgent) or switch to [nixos-wsl](https://github.com/nix-community/NixOS-WSL)
    - (An idea is to use nixos-wsl and build my-own install iso with [usb kernal passthough](https://1-bit-wonder.github.io/blog/how-to-use-yubikey-with-wsl/How%20to%20use%20Yubikey%20with%20WSL%20via%20USB%20passthrough/))
- [ ] Create wsl options, check this [commit](https://github.com/davidtwco/veritas/commit/62cf0dd3f30b117462e3c31682b602d6cde3bc6a)
- [ ] Some sort of backup solution like [borgmatic](https://torsion.org/borgmatic/) [borgbackup](https://www.borgbackup.org/)
- [ ] rewrite structure using a different framework like [flake-parts](https://github.com/hercules-ci/flake-parts) or [blueprints](https://github.com/numtide/blueprints)

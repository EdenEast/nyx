# Nyx

[![Build](https://github.com/EdenEast/nyx/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/EdenEast/nyx/actions/workflows/build.yml)
[![NixOS 21.05](https://img.shields.io/badge/NixOS-v21.05-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)
[![Licence](https://img.shields.io/badge/license-Unlicense-blue)](https://github.com/EdenEast/nyx/blob/main/LICENSE)

This repository contains my configuration for all my systems, written primarily in [Nix].
This repository defines machines running [NixOS][nix], or unix machines running nix and
[home-manager], or Windows.

[nix]: https://nixos.org/
[home-manager]: https://github.com/nix-community/home-manager

## Structure

- `bin/` - Contains scripts that will be added to the `$PATH` variable
  - `windows/` - Scripts that are user to setup my windows machines
- `config/` - Contains `.dotfiles` for various applications. You can think of this as my `$HOME` directory
- `home/` - Configuration for my user. This is where home-manager configurations lives
  - `hosts/` - The definition of a home user. If same name as a `nixos/hosts` will be used by it
  - `modules/` - A defined set of home modules that can be enabled in a `home/host`
  - `profiles/` - A collection of module configurations grouped together to be used by a `home/host`
  - `secrets/` - A folder of secrets used by the user
- `lib/` - List of helper functions
- `nix/` - Nix package manager configurations
  - `overlays/` - Nix overlays
  - `pkgs/` - Self packaged applications
- `nixos/` - Machine configurations
  - `hosts/` - The definition of a nixos machine
  - `modules/` - Nixos modules
  - `profiles/` - A collection of module configurations
  - `secrets/` - Secrets used for a machine host

## Dotfiles

My `.dotfiles` can be found under `config/`. On systems managed by nix and this flake repository
they are managed by `home-manager`. I `home-manager` to use the `config/` folder as the source for
my configurations. This helps when I am on a machine that is not managed by nix (*cough windows
cough*). On these machines I symlink the files in the `config/` folder into their respective
locations. Some configurations of note:

- [Neovim](./config/.config/nvim)
- [Git](./config/.config/git)
- [Awesome](./config/.config/awesome)
- [Bash/Zsh](./config/.config/shell)

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

## TODO:

- Create wsl options, check this [commit](https://github.com/davidtwco/veritas/commit/62cf0dd3f30b117462e3c31682b602d6cde3bc6a)

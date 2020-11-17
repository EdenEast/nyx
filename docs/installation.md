# Installation

## Wsl on Windows

- Install wsl2 by following the [documentation](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
  - Currently I use Ubuntu as the distribution to install as it is the most supported
- Install Alacritty
  - Currently Alacritty landed configuration import support but it only handles absolute paths that
    exist. This does not work well for dotfiles that are tracked in source control and used my
    multiple systems. I have a fork of Alacritty that supports optional imports and expanded `~`.
    Current [fork branch](https://github.com/EdenEast/alacritty/tree/import-improvement)
- Symlink `%APPLOCALDATA%\alacritty` to `~/.config/alacritty`. In
  `~/.local/share/alacritty/config.yml` add the following:

```yml
  # Wsl2
  shell:
    program: C:/Windows/System32/bash.exe
    args:
      - --login
      - -i

  working_directory: %USERPROFILE%
```

- Launch alacritty and execute the following steps:

```bash
# Install nix
sh <(curl -L https://nixos.org/nix/install)

# Source nix-profile
. ~/.nix-profile/etc/profile.d/nix.sh

# Create a temp nix shell that contains packages needed to clone and build the flake
nix-shell -p git nixFlake gnumake

# Clone nyx into a directory
git clone https://github.com/edeneast/nyx && cd nyx

# Build flake with make
make

# Activate the built flake
./result/activate
```


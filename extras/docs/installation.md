# Installation

## Wsl2 on Windows

- Install wsl2 by following the [documentation](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
  - Currently I use Ubuntu or Debian as they are the distributions most supported by wsl
- Install Alacritty
  - My current configuration will work with the next minor version `v0.7.0`. For now alacritty
    needs to be built from master
  - Symlink `%APPLOCALDATA%\alacritty` to somewhere where nyx is cloned on windows
      `home/files/.config/alacritty`. Add the following to `~/.local/share/alacritty/config.yml`

```yml
  # Wsl2
  shell:
    program: C:/Windows/System32/wsl.exe

  working_directory: %USERPROFILE%
```

Launch alacritty and execute the following steps:

```bash
# In case base install does not come with curl and xz-utils to open tar files from nix install
sudo apt install curl xz-utils

# Install nix
sh <(curl -L https://nixos.org/nix/install)

# Source nix-profile
. ~/.nix-profile/etc/profile.d/nix.sh

# Install experimental flake support for the system
nix-env -iA nixpkgs.nixFlakes

# Create a temp nix shell that contains packages needed to clone and build the flake
nix-shell -p git just

# Make .local directory just in case
mkdir -p ~/.local && cd ~/.local

# Clone nyx into a directory
git clone https://github.com/edeneast/nyx && cd nyx

# Depending on what output target you want to default this system to build set the default target in
# a .env file
echo "NYX_DEFAULT_TARGET=wsl" > .env

# Build flake with just and install the results
just install
```


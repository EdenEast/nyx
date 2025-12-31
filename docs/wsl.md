# Wsl2

On windows, I use either [alacritty] or [wezterm] as a terminal emulator to launch wsl2.

[alacritty]: https://github.com/alacritty/Alacritty
[wezterm]: https://wezfurlong.org/wezterm/

## Alacritty

For `alacritty` I have to set the shell to launch wsl. My alacritty [config][alacritty-config] looks
for a local file and will source if it exists. Add the following code snippet to path:
`~/.local/share/alacritty/config.yml`.

```yml
  # Wsl2
  shell:
    program: C:/Windows/System32/wsl.exe

  working_directory: %USERPROFILE%
```

[alacritty-config]: ../config/.config/alacritty/alacritty.yml

## Wezterm

For `wezterm` my default lua [config][wezconfig] file already checks if it is running on windows and
will set the default shell command to run wsl. Just have to make sure that `$NYX_ROOT_DIR/config` is
symlinked to `$HOME/.config`. Wezterm will look for a config file at
`$HOME/.config/wezterm/wezterm.lua` even on windows 😄.

[wezconfig]: ../config/.config/wezterm/wezterm.lua

## Linux

Once wsl is launched execute the following:


```bash
# In case base install does not come with curl and xz-utils to open tar files from nix install
sudo apt install curl xz-utils

# Install nix
sh <(curl -L https://nixos.org/nix/install)

# Source nix-profile
. ~/.nix-profile/etc/profile.d/nix.sh

# Make .local directory just in case
mkdir -p ~/.local && cd ~/.local

# Make sure to have a shell that has git
nix-shell -p git

# Clone nyx into a directory
git clone https://github.com/edeneast/nyx && cd nyx

# Execute `nyx` helper to switch to the current configuration
./bin/nyx switch
```


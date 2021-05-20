# Export env var
export USER := env_var("USER")
export HOME := env_var("HOME")
export HOME_MANAGER_BACKUP_EXT := "nbak"

default-target := "${NYX_DEFAULT_TARGET:-}"
expflags       := "--experimental-features 'nix-command flakes'"
input-all      := "all"

nvim_home       := "${HOME}/.config/nvim"
packer_compiled := "${HOME}/.local/share/nvim/plugin/packer_compiled.vim"

# colors
reset  := '\033[0m'
red    := '\033[1;31m'
green  := '\033[1;32m'
yellow := '\033[1;33m'

alias b := build
alias c := check
alias f := fmt
alias i := install
alias u := update

# Validate all outputs of the flake and execute its tests
check:
    nix flake check {{expflags}}

# Build an output target of the nix flake
@build target=default-target:
    printf "Building target:   {{green}}{{target}}{{reset}}\n"
    nix build .#{{target}} {{expflags}}

# Install an output target of the nix flake
@install target=default-target: (build target)
    printf "Installing target: {{green}}{{target}}{{reset}}\n"
    [ {{nvim_home}} -ef "{{justfile_directory()}}/home/files/.config/nvim" ] && rm {{nvim_home}} || echo "did not"
    [ -f ./result/activate ] && ./result/activate

# Update flake lockfile input or all
update:
    #!/usr/bin/env bash
    nix flake update {{expflags}}

# Execute formatter on all .nix files
@fmt:
    fd --type f --extension nix --exec nixfmt {}

# Remove a symlink for neovim and symlink to `home/files/.config/nvim`
# This is useful for developing and woriing with nvim config
nvim:
    #!/usr/bin/env bash
    [[ -L "{{nvim_home}}" ]] && rm "{{nvim_home}}"
    [[ -d "{{nvim_home}}" ]] && {
        printf "{{red}}Error{{reset}}: {{yellow}}{{nvim_home}}{{reset}} exists and not a symlink\n"
    } || {
        ln -s "{{justfile_directory()}}/home/files/.config/nvim" "{{nvim_home}}"
    }

    # Find if there is a packer_compiled file and delete it just in case
    [[ -f {{packer_compiled}} ]] && {
        rm {{packer_compiled}}
        printf "Removed: {{yellow}}{{packer_compiled}}{{reset}}\n"
    }


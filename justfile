# Export env var
export USER := env_var("USER")
export HOME := env_var("HOME")

default-target := "${NYX_DEFAULT_TARGET:-minimal}"
expflags := "--experimental-features 'nix-command flakes'"
input-all := "all"

# colors
reset := '\033[0m'
red   := '\033[1;31m'
green := '\033[1;32m'

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
    [ -f ./result/activate ] && ./result/activate

# Update flake lockfile input or all
@update input=input-all:
    #!/usr/bin/env bash
    [[ {{input}} == "all" ]] && input="--recreate-lock-file" || input="--update-input {{input}}"
    nix flake update $input

# Execute formatter on all .nix files
@fmt:
    fd --type f --extension nix --exec nixfmt {}

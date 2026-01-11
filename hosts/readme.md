# Hosts

This directory contains all host definitions for all 3 types of systems (`nixos`, `darwin`, and standalone
`home-manager`). Each subdirectory corresponds to a specific host, containing its definition. The type of host is
determined by the type of configuration entry point found.

| Type         | Entry File                               | Flake output           |
| ------------ | ---------------------------------------- | ---------------------- |
| Base         | `default.nix`                            | `...`                  |
| Nixos        | `configuration.nix`                      | `nixosConfigurations`  |
| Darwin       | `darwin-configuration.nix`               | `darwinConfigurations` |
| Home-Manager | `home-configuration.nix` + `system.nix`  | `homeConfigurations`   |

---

## 📂 Directory Structure

The `hosts/` directory is organized as follows:

<!-- eza --tree --level 1 --only-dirs ./hosts -->
```plaintext
hosts
└── wrath   # Framework 13
```

---

## Example Standalone Home Manager Host

As there is no current example of a standalone home-manager host configuration here is a base example:

```nix
# ./hosts/<user>/home-configuration.nix
{
  config,
  pkgs,
  ...
}: {
  home.stateVersion = "25.11";

  nix = {
    inherit (config.my.snippets.nix) settings;
    package = pkgs.nix;
  };

  my.home = {
    base.enable = true;
  };
}

# ./hosts/<user>/system.nix
"x86_64-linux"
```

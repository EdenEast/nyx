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

## 📂 Directory Structure

The `hosts/` directory is organized as follows:

```plaintext
hosts/
├── eden/    # HP Omnibook Ultra Flip 14
└── wrath/   # Framework 13
```

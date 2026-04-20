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
├── rize   # NixOS-wsl2
├── thor   # Homelab
└── wrath  # Framework 13
```

---

## 🐝 Colmena Hive

[Colmena](https://github.com/zhaofengli/colmena) is used for deploying NixOS configurations to remote hosts. A NixOS
host is automatically included in the colmena hive if its host directory contains a `hive.nix` file.

### How it works

The flake builds the hive by filtering all NixOS hosts that have a `hive.nix`, then merging each host's
`configuration.nix` and `hive.nix` into a colmena node. The `hive.nix` receives `hostname` as a special argument
(set from the directory name) alongside the standard NixOS module arguments.

### Adding a host to the hive

Create a `hive.nix` in the host's directory:

```nix
# ./hosts/<hostname>/hive.nix
{hostname, ...}: {
  deployment = {
    targetHost = hostname;
  };
}
```

The `targetHost` is the address colmena will SSH into. Using `hostname` assumes the hostname resolves via DNS or
`/etc/hosts`. Override it with an IP or fully-qualified domain name if needed:

```nix
{...}: {
  deployment = {
    targetHost = "192.168.1.10";
    targetUser = "root"; # defaults to current user if omitted
  };
}
```

### Deploying

```bash
# Deploy all hive hosts
colmena apply

# Deploy a specific host
colmena apply --on <hostname>

# Build without deploying
colmena build
```

`meta.allowApplyAll` is set to `false`, so `colmena apply` requires an explicit `--on <hostname>` or `--on @<tag>`
selector — a bare `colmena apply` will error. This prevents accidental mass deployments.


---

## 🏠 Example Standalone Home Manager Host

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

## 💻 Provisioning New Device

To add a new device to this configuration, follow these steps:

1. **Create Host Configuration**:
    - Duplicate an existing host directory within `hosts/` and rename it to the new device's hostname.
    - Modify the `configuration.nix` and other relevant Nix modules (e.g., `disko.nix`, `hardware.nix`, `home.nix`) to match the new device's specifications.
    - Track new host files in flake git repository.


1. **Install NixOS**:
   - Install NixOS on the new device using this flake. Note that secrets will not be available on the first boot without a valid SSH private key.

1. **Authorize SSH Key**:
   - On a separate machine, copy the new system's public SSH key (`/etc/ssh/ssh_host_ed25519_key.pub`) to this repository (`secrets/publicKeys/root_$HOSTNAME.pub`).

1. **(Optional) Configure User SSH Key**:
   - Generate a new user SSH key and copy it to the secrets repository at `secrets/publicKeys/$USER_$HOSTNAME.pub` to enable passwordless logins to other hosts.

1. **Rekey Secrets**:
   - Rekey all secrets:
     ```bash
     ragenix --rekey
     ```
   - Push the changes to the repository.
   - Review [secrets readme](../secrets/readme.md) for more information

1. **Rebuild System**:
   - On the new device, rebuild the system from the repository. Secrets will be automatically decrypted and available in `/run/agenix/` for NixOS and `$XDG_RUNTIME_DIR/agenix/` for users.

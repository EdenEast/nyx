# Base Profile

Essential NixOS system configuration enabled on most of my systems, bot hdesktops and servers.

## Usage

```nix
{
  myNixOS.profiles.base.enable = true;
}
```

## What It Does

- **Essential packages**: git, vim editor, htop, wget, curl, inxi system info, lm_sensors.
- **Modern coreutils**: Uses uutils over GNU coreutils.
- **Development environment**: direnv with nix-direnv for automatic shell environments.
- **Flake configuration**: Sets `FLAKE` and `NH_FLAKE` to `github:edeneast/nyx` for system rebuilds.
- **GnuPG integration**: GPG agent with SSH support for key management.
- **Sudo configuration**: Uses sudo-rs (Rust sudo) with passwordless wheel group access.
- **Network management**: NetworkManager for WiFi and network connectivity.
<!-- - **System integration**: Polkit for privilege escalation, rtkit for realtime scheduling. -->
<!-- - **File system caching**: CacheFS with 20% run, 10% cull, 5% stop thresholds. -->
<!-- - **Remote development**: VS Code server support for remote editing. -->
<!-- - **SSH security**: Disables password authentication, uses SSH keys only, includes known hosts. -->

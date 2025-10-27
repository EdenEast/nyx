# Nyx

```plaintext
.
├── flake.nix                # Main entry point
├── hosts/                   # NixOS Darwin and Home configurations
│   ├── darwin/              # Darwin configurations
│   ├── home/                # Home configuration
│   └── nixos/               # NixOS configuration
├── modules/                 # Modular configurations
│   ├── darwin/              # macOS-specific modules
│   ├── home/                # home-manager modules
│   ├── flake/               # Organized flake components
│   │   ├── darwin.nix       # macOS-specific configurations
│   │   ├── home-manager.nix # Home-manager configurations
│   │   ├── nixos.nix        # NixOS-specific configurations
│   │   └── ...              # Other flake components
│   ├── nixos/               # NixOS-specific modules
│   └── snippets/            # Reusable configuration snippets
└── overlays/                # Custom Nixpkgs overlays
```

## Resources and References

- [alyraffauf/nixcfg](https://github.com/alyraffauf/nixcfg)
  - Very good modular structure based around flake-parts
- [srid/nixos-config](https://github.com/srid/nixos-config)
  - Flake-part structure using nixos-unified
- [fmoda3/nix-config](https://github.com/fmoda3/nix-configs)
  - Another flake-part module structure example

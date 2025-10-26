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

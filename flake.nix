{
  description = ''
    Nyx is the personal configuration for James Simpson. This repository holdes .dotfile configuration as well as both
    nix (with home-manager) and nixos configurations.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    # Overlays
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
  };


  outputs = { self, ... }@inputs:
  with inputs.nixpkgs.lib;
  let
    inherit (lib.my) mkHomeConfig mkHostConfig;

    lib = inputs.nixpkgs.lib.extend
        (self: super: { my = import ./lib { inherit inputs; lib = self; }; });
  in {
    lib = lib.my;

    internal = {
      hostConfigurations = inputs.nixpkgs.lib.mapAttrs' mkHostConfig {
        eden = { system = "x86_64-linux"; config = ./home/hosts/eden.nix; };
      };
    };

    overlays = [
      inputs.neovim-nightly.overlay
    ];

    homeManagerConfigurations = mapAttrs' mkHomeConfig {
      eden = { system = "x86_64-linux"; };
    };

    eden = self.homeManagerConfigurations.eden.activationPackage;
  };
}

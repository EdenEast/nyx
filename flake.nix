# flake-parts with nixpkgs-unstable:
#   - https://sourcegraph.com/search?q=context:global+lang:nix+and+file:flake.nix+and+%22pkgs-unstable+%3D%22+and+%22flake-parts%22&patternType=keyword&sm=0
#   - https://sourcegraph.com/github.com/mccurdyc/nixos-config@bc204c649fb3a8a4a48f4bf50205c436bf42fec2/-/blob/flake.nix
#   - https://sourcegraph.com/github.com/stackbuilders/nixpkgs-terraform@14308101ad049053cc42b409b1e3e245fd707047/-/blob/flake.nix?L9:5-9:16
#   - https://sourcegraph.com/github.com/semickolon/fak@a92846f06d0f82b35958f7a0871ee83384d405da/-/blob/flake.nix?L17:9-17:24
{
  description = ''
    Nyx is the personal configuration. This repository holdes .dotfile configuration as well as both nix (with
    home-manager) and nixos configurations.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/nur";

    neovim-flake.url = "github:neovim/neovim?dir=contrib";
    neovim-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-substituters = [
      "https://edeneast.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "edeneast.cachix.org-1:a4tKrKZgZXXXYhDytg/Z3YcjJ04oz5ormt0Ow6OpExc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-parts, systems, ... }@inputs:
    with self.lib;
    let
      mkPkgs = p: s: import p {
        inherit s;
        config = import ./nix/conf.nix;
        # overlays = self.overlays."${s}";
      };
      mkStable = s: mkPkgs nixpkgs s;
      mkUnstable = s: mkPkgs nixpkgs-unstable s;
    in
    flake-parts.lib.mkFlake
      { inherit inputs; }
      {
        # This is needed for pkgs-unstable - https://github.com/hercules-ci/flake-parts/discussions/105
        imports = [ inputs.flake-parts.flakeModules.easyOverlay ];
        systems = [ "aarch64-darwin" "x86_64-linux" ];

        flake = {
          lib = import ./lib { inherit inputs; } // inputs.nixpkgs.lib;

          templates = import ./nix/templates;

          homeManagerConfigurations = mapAttrs' mkHome {
            eden = { };
          };

          nixosConfigurations = mapAttrs' mkSystem {
            pride = { };
            sloth = { };
            wrath = { };
            vm-dev = { };
          };

          darwinConfigurations = mapAttrs' mkDarwin {
            theman = { user = "work"; };
          };
        };
        perSystem = { system, ... }:
          let
            pkgs = import inputs.nixpkgs { inherit system; config = import ./nix/conf.nix; };
            pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; config = import ./nix/conf.nix; };
          in
          {
            inherit pkgs-unstable;
            # This is needed for pkgs-unstable - https://github.com/hercules-ci/flake-parts/discussions/105
            overlayAttrs = { inherit pkgs-unstable; };

            formatter = pkgs.nixpkgs-fmt;

            packages = import ./nix/pkgs self system;

            devShells.default = import ./shell.nix { inherit pkgs pkgs-unstable; };
          };
      };
}

{
  description = ''
    Nyx is the personal configuration. This repository holdes .dotfile configuration as well as both nix (with
    home-manager) and nixos configurations.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:nix-darwin/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/nur";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nvim-config = {
      url = "github:EdenEast/nvim-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nushell-src.url = "github:nushell/nushell";
    nushell-src.flake = false;

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.home-manager.follows = "home-manager";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    ghostty.url = "github:ghostty-org/ghostty";
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

  outputs = {self, ...} @ inputs:
    with self.lib; let
      systems = ["x86_64-linux" "aarch64-darwin"];
      foreachSystem = genAttrs systems;
      pkgsBySystem = foreachSystem (
        system:
          import inputs.nixpkgs {
            inherit system;
            config = import ./nix/config.nix;
            overlays = self.overlays."${system}";
          }
      );

      treefmtEval = foreachSystem (
        system:
          inputs.treefmt-nix.lib.evalModule pkgsBySystem."${system}" {
            projectRootFile = "flake.nix";
            programs = {
              deadnix.enable = true;
              alejandra.enable = true;
              stylua = {
                enable = true;
                settings = {
                  indent_type = "Spaces";
                  indent_width = 2;
                  collapse_simple_statement = "Always";
                };
              };
            };
          }
      );
    in {
      lib = import ./lib {inherit inputs;} // inputs.nixpkgs.lib;

      devShell = foreachSystem (system: import ./shell.nix {pkgs = pkgsBySystem."${system}";});

      formatter = foreachSystem (system: treefmtEval."${system}".config.build.wrapper);

      templates = import ./nix/templates;

      legacyPackages = pkgsBySystem;
      packages = foreachSystem (system: import ./nix/pkgs self system);
      overlay = foreachSystem (system: _final: _prev: self.packages."${system}");
      overlays = foreachSystem (
        system:
          with inputs; let
            ovs = attrValues (import ./nix/overlays self);
          in
            [
              (self.overlay."${system}")
              (nur.overlays.default)
              (import rust-overlay)
            ]
            ++ ovs
      );

      homeConfigurations = mapAttrs' mkHome {
        eden = {};
      };

      nixosConfigurations = mapAttrs' mkSystem {
        pride = {};
        sloth = {};
        wrath = {};
        vm-dev = {};
      };

      darwinConfigurations =
        mapAttrs' mkDarwin {
        };

      # Convenience output that aggregates the outputs for home, nixos, and darwin configurations.
      # Also used in ci to build targets generally.
      top = let
        nixtop =
          genAttrs
          (builtins.attrNames inputs.self.nixosConfigurations)
          (attr: inputs.self.nixosConfigurations.${attr}.config.system.build.toplevel);
        hometop =
          genAttrs
          (builtins.attrNames inputs.self.homeConfigurations)
          (attr: inputs.self.homeConfigurations.${attr}.activationPackage);
        darwintop =
          genAttrs
          (builtins.attrNames inputs.self.darwinConfigurations)
          (attr: inputs.self.darwinConfigurations.${attr}.system);
      in
        nixtop // hometop // darwintop;
    };
}

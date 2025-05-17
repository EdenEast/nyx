{
  description = ''
    Nyx is the personal configuration. This repository holdes .dotfile configuration as well as both nix (with
    home-manager) and nixos configurations.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/nur";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    neovim-flake.url = "github:nix-community/neovim-nightly-overlay";
    neovim-flake.inputs.nixpkgs.follows = "nixpkgs";

    nushell-src.url = "github:nushell/nushell";
    nushell-src.flake = false;

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    ghostty.url = "github:ghostty-org/ghostty";

    # eww.url = "github:elkowar/eww";
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

  outputs = { self, ... }@inputs:
    with self.lib;
    let
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      foreachSystem = genAttrs systems;
      pkgsBySystem = foreachSystem (
        system:
        import inputs.nixpkgs {
          inherit system;
          config = import ./nix/config.nix;
          overlays = self.overlays."${system}";
        }
      );
    in
    rec {
      lib = import ./lib { inherit inputs; } // inputs.nixpkgs.lib;

      devShell = foreachSystem (system: import ./shell.nix { pkgs = pkgsBySystem."${system}"; });

      templates = import ./nix/templates;

      legacyPackages = pkgsBySystem;
      packages = foreachSystem (system: import ./nix/pkgs self system);
      overlay = foreachSystem (system: _final: _prev: self.packages."${system}");
      overlays = foreachSystem (
        system: with inputs; let
          ovs = attrValues (import ./nix/overlays self);
        in
        [
          (self.overlay."${system}")
          (nur.overlays.default)
          (import rust-overlay)
          # (_:_: { inherit (eww.packages."${system}") eww; })
        ] ++ ovs
      );

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

      # Convenience output that aggregates the outputs for home, nixos, and darwin configurations.
      # Also used in ci to build targets generally.
      top =
        let
          nixtop = genAttrs
            (builtins.attrNames inputs.self.nixosConfigurations)
            (attr: inputs.self.nixosConfigurations.${attr}.config.system.build.toplevel);
          hometop = genAttrs
            (builtins.attrNames inputs.self.homeManagerConfigurations)
            (attr: inputs.self.homeManagerConfigurations.${attr}.activationPackage);
          darwintop = genAttrs
            (builtins.attrNames inputs.self.darwinConfigurations)
            (attr: inputs.self.darwinConfigurations.${attr}.system);
        in
        nixtop // hometop // darwintop;
    };
}

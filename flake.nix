{
  description = ''
    Nyx is the personal configuration. This repository holdes .dotfile configuration as well as both nix (with
    home-manager) and nixos configurations.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/nur";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    # Overlays
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    eww.url = "github:elkowar/eww";
  };

  outputs = { self, ... }@inputs:
    with self.lib;
    let
      systems = [ "x86_64-linux" "x86_64-darwin" ];
      foreachSystem = genAttrs systems;
      pkgsBySystem = foreachSystem (
        system:
          import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = self.overlays."${system}";
            # overlays = with inputs; [ nur.overlay neovim-nightly.overlay fenix.overlay ];
          }
      );
    in
      rec {
        inherit pkgsBySystem;
        lib = import ./lib { inherit inputs; } // inputs.nixpkgs.lib;

        devShell = foreachSystem (system: import ./shell.nix { pkgs = pkgsBySystem."${system}"; });

        packages = foreachSystem (system: import ./nix/pkgs self system);
        overlay = foreachSystem (system: _final: _prev: self.packages."${system}");
        overlays = foreachSystem (
          system: with inputs; let
            ovs = attrValues (import ./nix/overlays self);
          in
            [
              (self.overlay."${system}")
              (nur.overlay)
              (neovim-nightly.overlay)
              (fenix.overlay)
              (_:_: { inherit (eww.packages."${system}") eww; })
            ] ++ ovs
        );

        homeManagerConfigurations = mapAttrs' mkHome {
          eden = {
            config = ./home/hosts/eden.nix;
          };
          theman = {
            config = ./home/hosts/theman.nix;
            user = ./user/work.nix;
            system = "x86_64-darwin";
          };
        };

        # TODO: Add users to system
        nixosConfigurations = mapAttrs' mkSystem {
          pride = { config = ./nixos/hosts/pride; };
          sloth = { config = ./nixos/hosts/sloth; };
        };

        # darwinConfigurations = mapAttrs' mkDarwin {
        #   theman = { config = ./darwin/hosts/theman; };
        # };

        top =
          let
            nixtop = genAttrs
              (builtins.attrNames inputs.self.nixosConfigurations)
              (attr: inputs.self.nixosConfigurations.${attr}.config.system.build.toplevel);
            hometop = genAttrs
              (builtins.attrNames inputs.self.homeManagerConfigurations)
              (attr: inputs.self.homeManagerConfigurations.${attr}.activationPackage);
            # darwintop = genAttrs
            #   (builtins.attrNames inputs.self.darwinConfigurations)
            #   (attr: inputs.self.darwinConfigurations.${attr}.system);
          in
            nixtop // hometop; # // darwintop;
      };
}

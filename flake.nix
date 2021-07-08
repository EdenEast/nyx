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
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
  };


  outputs = { self, ... }@inputs:
    with inputs.nixpkgs.lib;
    let
      inherit (lib.my) mkHomeConfig mkHostConfig mkSystemConfig mapModules mkPkgs;

      system = "x86_64-linux";
      pkgs = mkPkgs system;

      lib = inputs.nixpkgs.lib.extend
        (self: super: { my = import ./lib { inherit inputs; lib = self; }; });
    in
      {
        lib = lib.my;

        internal = {
          overlays = [ (inputs.neovim-nightly.overlay) (inputs.fenix.overlay) ] ++ (attrValues (mapModules ./nix/overlays import));

          hostConfigurations = inputs.nixpkgs.lib.mapAttrs' mkHostConfig {
            eden = { inherit system; config = ./home/hosts/eden.nix; };
            wsl = { inherit system; config = ./home/hosts/wsl.nix; };
            sloth = { inherit system; config = ./home/hosts/sloth.nix; };
          };
        };

        overlay = final: prev: {
          my = self.packages."${system}";
        };

        packages."${system}" = mapModules ./nix/pkgs (p: pkgs.callPackage p {});

        homeManagerConfigurations = mapAttrs' mkHomeConfig {
          eden = { inherit system; };
        };

        nixosConfigurations = mapAttrs' mkSystemConfig {
          wsl = { inherit system; config = ./nixos/hosts/wsl; };
          sloth = { inherit system; config = ./nixos/hosts/sloth; };
        };

        top = let
          nixtop = genAttrs
            (builtins.attrNames inputs.self.nixosConfigurations)
            (attr: inputs.self.nixosConfigurations.${attr}.config.system.build.toplevel);

          hometop = genAttrs
            (builtins.attrNames inputs.self.homeManagerConfigurations)
            (attr: inputs.self.homeManagerConfigurations.${attr}.activationPackage);
        in
          nixtop // hometop;

        # Can be executed with `nix run . -- <args>`
        defaultApp."${system}" = {
          type = "app";
          program = ./bin/nyx;
        };
      };
}

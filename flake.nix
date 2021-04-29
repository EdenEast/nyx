{
  description = "Something";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # primary nixpkgs
    nixpkgs-master.url =
      "github:nixos/nixpkgs/master"; # for packages on the edge

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    # Overlays
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, ... }@inputs:
    let
      # supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      # forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
      system = "x86_64-linux";

      util = import ./lib inputs;
      inherit (util) mkHome;
      inherit (util) pkgs;

      shell = pkgs.mkShell {
        name = "nyx";
        naitiveBuildInputs = with pkgs; [
          git-crypt
          git
          just
          nixfmt
          nixFlakes
          fd
          nix-build-uncached
          nix-prefetch-git
        ];

        shellHook = ''
          PATH=${
            pkgs.writeShellScriptBin "nix" ''
              ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
            ''
          }/bin:$PATH
        '';
      };
    in {
      overlay."${system}" = _: _: self.packages.x86_64-linux;
      overlays = [
        (self.overlay."${system}")
        (import ./nix/overlays/git-open)
        inputs.neovim-nightly.overlay
      ];

      packages."${system}" = {
        cargo-whatfeatures = pkgs.callPackage ./nix/pkgs/cargo-whatfeatures { };
        cargo-why = pkgs.callPackage ./nix/pkgs/cargo-why { };
        repo = pkgs.callPackage ./nix/pkgs/repo { };
        xplr = pkgs.callPackage ./nix/pkgs/xplr { };
      };

      devShell."${system}" = shell;

      homeConfigurations = {
        kiiro = mkHome ./hosts/kiiro;
        chairo = mkHome ./hosts/chairo;
      };
      kiiro = self.homeConfigurations.kiiro.activationPackage;
      chairo = self.homeConfigurations.chairo.activationPackage;
    };
}

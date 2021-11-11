{ inputs, ... }:

with inputs.nixpkgs.lib;
rec {
  # Derivation agnostic settings for all types of top level derivations (nixos, home-manager && darwin).
  mkUserHome = { config, system ? "x86_64-linux" }:
  { ... }: {
    imports = [
      (import ../home/modules)
      (import ../home/profiles)
      (import config)
    ];

    # For compatibility with nix-shell, nix-build, etc.
    home.file.".nixpkgs".source = inputs.nixpkgs;
    home.sessionVariables."NIX_PATH" =
      "nixpkgs=$HOME/.nixpkgs\${NIX_PATH:+:}$NIX_PATH";

    # TODO: Note sure where this should go
    home.sessionPath = [ "$HOME/.local/nyx/bin" "$XDG_BIN_HOME" ];

    home.stateVersion = "20.09";
  };

  # Top level derivation for just home-manager
  mkHome = name: { config, username, system ? "x86_64-linux" }:
    let
      pkgs = inputs.self.pkgsBySystem."${system}";
      homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
    in
      nameValuePair name (
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs system username homeDirectory;
          configuration = { ... }: {
            imports = let home = mkUserHome { inherit config system; }; in [ home ];
          };
          extraSpecialArgs = let self = inputs.self; in { inherit name system inputs self; };
        }
      );

  mkSystem = name: { config, system ? "x86_64-linux" }:
    nameValuePair name (
      let
        pkgs = inputs.self.pkgsBySystem."${system}";
      in
        nixosSystem {
          inherit system;
          modules = [
            (
              { name, ... }: {
                networking.hostName = name;
              }
            )
            (
              { inputs, ... }: {
                # Use the nixpkgs from the flake.
                nixpkgs = { inherit pkgs; };

                # For compatibility with nix-shell, nix-build, etc.
                environment.etc.nixpkgs.source = inputs.nixpkgs;
                nix.nixPath = [ "nixpkgs=/etc/nixpkgs" ];
              }
            )
            (
              { pkgs, ... }: {
                # Don't rely on the configuration to enable a flake-compatible version of Nix.
                nix = {
                  package = pkgs.nixFlakes;
                  extraOptions = "experimental-features = nix-command flakes";
                };
              }
            )
            (
              { inputs, ... }: {
                # Re-expose self and nixpkgs as flakes.
                nix.registry = {
                  self.flake = inputs.self;
                  nixpkgs = {
                    from = { id = "nixpkgs"; type = "indirect"; };
                    flake = inputs.nixpkgs;
                  };
                };
              }
            )
            (
              { ... }: {
                system.stateVersion = "21.05";
              }
            )
            (inputs.home-manager.nixosModules.home-manager)
            (import ../nixos/modules)
            (import ../nixos/profiles)
            (import config)
          ];
          specialArgs = let self = inputs.self; in { inherit name system inputs self; };
        }
    );

  mkDarwin = name: { config }:
    nameValuePair name (
      let
        system = "x86_64-darwin";
        pkgs = inputs.self.pkgsBySystem."${system}";
      in
        inputs.darwin.lib.darwinSystem {
          inherit system;
          modules = [
            (inputs.home-manager.darwinModules.home-manager)
            (import ../darwin/modules)
            (import ../darwin/profiles)
            (import config)
          ];
          inputs = let self = inputs.self; in { inherit name system inputs self; };
        }
    );
}

{ lib, inputs, ... }:

{
  # Creates a host configuration that can them be used by either the mkHomeConfiguration, or mkSystemConfiguration
  # functions. These are internal abstractions.
  mkSystemConfig = name: { system, config }:
    lib.nameValuePair name (
      lib.nixosSystem {
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
              nixpkgs = { pkgs = lib.my.mkPkgs system; };

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
          (import ../nixos/modules)
          (import ../nixos/profiles)
          (import config)
        ];

        specialArgs = { inherit name inputs; };
      }
    );
}

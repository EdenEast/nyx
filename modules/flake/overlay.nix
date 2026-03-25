# This gives you:
#   pkgs.stable.*    - packages from stable nixpkgs
#   pkgs.unstable.*  - packages from unstable nixpkgs
#
#   Overridden packages from overlays/
{
  self,
  lib,
  inputs,
  ...
}: {
  flake.overlays.default = final: prev: let
    inherit (final.stdenv.hostPlatform) system;

    overlays = lib.pipe (self.lib.fs.scanAttrs ../../overlays) [
      (lib.mapAttrs (_: value: import value {inherit inputs self;} final prev))
      (lib.concatMapAttrs (_: v: v))
    ];

    # TODO: Have to find a way to define packages in the overlay as trying to use packages
    # via `self` causes a infinite recusion.
    # packages = self.packages.${prev.stdenv.hostPlatform.system};

    channels = {
      stable = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };

      unstable = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      master = import inputs.nixpkgs-master {
        inherit system;
        config.allowUnfree = true;
      };
    };
  in
    overlays // channels;
}

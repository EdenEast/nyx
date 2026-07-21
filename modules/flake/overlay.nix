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
    inherit (prev.stdenv.hostPlatform) system;

    overlays = lib.pipe (self.lib.fs.scanAttrs ../../overlays) [
      (lib.mapAttrs (_: value: import value {inherit inputs self;} final prev))
      (lib.concatMapAttrs (_: v: v))
    ];

    packages = self.packages.${system} or {};

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
    overlays // packages // channels;
}

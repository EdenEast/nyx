{self, ...}: let
  inherit (self.lib) forAllNixFiles;
in {
  perSystem = {pkgs, ...}: {
    legacyPackages = pkgs;
    packages = forAllNixFiles ./. (_name: fn: pkgs.callPackage fn {});
  };
}

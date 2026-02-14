{
  lib,
  self,
  ...
}: {
  imports = self.lib.fs.scanPaths ./.;

  options.my.nixos.FLAKE = lib.mkOption {
    type = lib.types.str;
    default = "github:edeneast/nyx";
    description = "Default flake URL for this NixOS configuration.";
  };
}

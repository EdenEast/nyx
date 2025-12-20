{
  lib,
  self,
  ...
}: {
  imports = self.lib.importsAllNixFiles ./.;

  options.myNixOS.FLAKE = lib.mkOption {
    type = lib.types.str;
    default = "github:edeneast/nyx";
    description = "Default flake URL for this NixOS configuration.";
  };
}

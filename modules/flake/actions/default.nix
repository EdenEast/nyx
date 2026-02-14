{
  lib,
  self,
  inputs,
  ...
}: {
  imports = [
    inputs.actions-nix.flakeModules.default
  ];

  flake.actions-nix = {
    pre-commit.enable = true;
    workflows = self.lib.fs.importAndMarge ./. {inherit inputs self lib;};
  };
}

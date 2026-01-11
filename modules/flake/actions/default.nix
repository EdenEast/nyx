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
    workflows = self.lib.importDir ./. (entries:
      lib.pipe entries [
        (lib.filterAttrs (name: _: name != "default"))
        (lib.mapAttrs (_: value: import value.path {inherit inputs self lib;}))
        (lib.concatMapAttrs (_: v: v))
      ]);
  };
}

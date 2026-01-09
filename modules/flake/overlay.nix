{
  self,
  lib,
  inputs,
  ...
}: {
  flake.overlays.default = final: prev:
    self.lib.importDir ../../overlays (entries:
      lib.pipe entries [
        (lib.mapAttrs (_: value: import value.path {inherit inputs self;} final prev))
        (lib.concatMapAttrs (_: v: v))
      ]);
}

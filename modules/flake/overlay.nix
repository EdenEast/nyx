{
  self,
  lib,
  inputs,
  ...
}: {
  flake.overlays.default = final: prev:
    lib.pipe (self.lib.fs.scanAttrs ../../overlays) [
      (lib.mapAttrs (_: value: import value {inherit inputs self;} final prev))
      (lib.concatMapAttrs (_: v: v))
    ];
}

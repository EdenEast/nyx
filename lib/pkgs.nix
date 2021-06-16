{ inputs, lib, ... }:

{
  mkPkgs = system: import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = lib.attrValues inputs.self.overlays;
  };
}

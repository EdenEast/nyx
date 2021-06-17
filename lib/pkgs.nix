{ inputs, lib, ... }:

{
  mkPkgs = system: import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [inputs.self.overlay] ++ (lib.attrValues inputs.self.overlays);
  };
}

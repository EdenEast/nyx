{ inputs, lib, ... }:

{
  mkPkgs = system: import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [ inputs.self.overlay ] ++ inputs.self.internal.overlays;
  };
}

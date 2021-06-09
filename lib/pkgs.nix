{ inputs, ... }:

{
  mkPkgs = system: import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = inputs.self.internal.overlays;
  };
}

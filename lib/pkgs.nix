{ inputs, ... }:

{
  mkPkgs = pkgs: system: import pkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = inputs.self.overlays;
  };
}

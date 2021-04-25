{ self, nixpkgs, ... }@inputs:

let
  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    config = { allowUnfree = true; };
    overlays = self.overlays;
  };

in pkgs

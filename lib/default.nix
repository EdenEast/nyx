{ self, nixpkgs, home-manager, ... }@inputs:

let lib = self.lib;
in {
  mkHost = import ./mkHost.nix inputs;
  pkgs = import ./pkgs.nix inputs;
}

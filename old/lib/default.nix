{ self, nixpkgs, home-manager, ... }@inputs:

let lib = self.lib;
in {
  mkHome = import ./mkHome.nix inputs;
  pkgs = import ./pkgs.nix inputs;
}

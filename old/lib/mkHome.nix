{ self, home-manager, nixpkgs, ... }@inputs:

file:

let
  inherit (import file inputs) system username config;
  pkgs = import ./pkgs.nix inputs;

  isDarwin = system: (import nixpkgs { inherit system; }).stdenv.isDarwin;
  homeDirectory = isDarwin:
    "/${if isDarwin then "Users" else "home"}/${username}";
in home-manager.lib.homeManagerConfiguration {
  inherit username system pkgs;

  homeDirectory = homeDirectory (isDarwin system);
  configuration = { ... }: {
    imports = [ (../home/aspects) (../home/profiles) (config) ];

    nixpkgs.overlays = self.overlays;
    nixpkgs.config = import ../nix/config.nix;

    systemd.user.startServices = true;

    home.stateVersion = "20.09";
  };
}

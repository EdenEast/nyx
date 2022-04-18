{ config, lib, pkgs, ... }:

{
  nyx = {
    modules = {
      user.home = ./home.nix;
    };

    profiles = {
      desktop.enable = true;
    };
  };

  environment.systemPackages = with pkgs;[
    # kitty
  ];
}

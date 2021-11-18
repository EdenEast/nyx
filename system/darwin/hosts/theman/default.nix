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
}

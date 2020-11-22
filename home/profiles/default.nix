{ lib, ... }:

{
  imports = [
    ./common.nix
    ./development.nix
    ./extended.nix
  ];

  config.nyx.profiles.common.enable = lib.mkDefault true;
}


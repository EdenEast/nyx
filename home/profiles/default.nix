{ lib, ... }:

{
  imports = [
    ./common.nix
    ./development.nix
  ];

  config.nyx.profiles.common.enable = lib.mkDefault true;
}


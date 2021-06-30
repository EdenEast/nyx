{ lib, ... }:

{
  imports = [
    ./common.nix
    ./desktop.nix
  ];

  config.nyx.profiles.common.enable = lib.mkDefault true;
}

{ lib, ... }:

{
  imports = [
    ./common.nix
  ];

  config.nyx.profiles.common.enable = lib.mkDefault true;
}

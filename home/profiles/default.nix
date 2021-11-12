{ lib, ... }:

{
  imports = [ ./common.nix ./desktop.nix ./development.nix ./extended.nix ];

  config.nyx.profiles.common.enable = lib.mkDefault false;
}


{ config, lib, ... }:

with lib;
let
  cfg = config.nyx.aspects.xdg;
in
{
  options.nyx.aspects.xdg.enable = mkEnableOption "xdg configuration";

  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      mime.enable = true;
    };
  };
}


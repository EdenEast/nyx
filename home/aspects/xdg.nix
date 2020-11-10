{ config, lib, ... }:

with lib;
let
  cfg = config.nyx.configs.xdg;
in
{
  options.nyx.configs.xdg.enable = mkEnableOption "xdg configuration";

  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      mime.enable = true;
    };
  };
}


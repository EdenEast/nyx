{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.configs.lf;
in
{
  options.nyx.configs.lf = {
    enable = mkEnableOption "lf configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.lf ];
    xdg.configFile."lf".source = ../dots/.config/lf;
  };
}

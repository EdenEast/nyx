{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.alacritty;
in {
  options.nyx.aspects.alacritty = {
    enable = mkEnableOption "alacritty configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.alacritty ];
    xdg.configFile."alacritty".source = ../files/.config/alacritty;
  };
}

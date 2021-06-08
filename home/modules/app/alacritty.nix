{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.app.alacritty;
in {
  options.nyx.modules.app.alacritty = {
    enable = mkEnableOption "alacritty configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.alacritty ];
    xdg.configFile."alacritty".source = ../../../config/.config/alacritty;
  };
}

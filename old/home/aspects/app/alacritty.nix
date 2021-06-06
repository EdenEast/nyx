{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.app.alacritty;
in {
  options.nyx.aspects.app.alacritty = {
    enable = mkEnableOption "alacritty configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.alacritty ];
    xdg.configFile."alacritty".source = ../../files/.config/alacritty;
  };
}

{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.app.wezterm;
in {
  options.nyx.modules.app.wezterm = {
    enable = mkEnableOption "wezterm configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.wezterm ];
    xdg.configFile."wezterm".source = ../../../config/.config/wezterm;
  };
}

{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.profiles.desktop;
in
{
  options.nyx.profiles.desktop = { enable = mkEnableOption "desktop profile"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      feh
      light
      lm_sensors
      rofi
      networkmanagerapplet
      synergy
      xdotool
    ];

    xdg.configFile."awesome".source = ../../config/.config/awesome;
    xsession = {
      enable = true;
      scriptPath = ".hm-xsession";
      windowManager.awesome.enable = true;
    };

    nyx.modules = {
      app.alacritty.enable = true;
      app.discord.enable = true;
      app.wezterm.enable = true;
    };
  };
}

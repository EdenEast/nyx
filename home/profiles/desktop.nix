{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.profiles.desktop;
  laptopPkgs = with pkgs; [
    acpi
  ];
in
{
  options.nyx.profiles.desktop = {
    enable = mkEnableOption "desktop profile";
    laptop = mkOption {
      description = "Add packages required when machine is a laptop";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      brightnessctl
      playerctl
      feh
      lm_sensors
      rofi
      networkmanagerapplet
      synergy
      xdotool
    ] ++ optionals cfg.laptop laptopPkgs;

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

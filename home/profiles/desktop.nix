{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.profiles.desktop;
in
{
  options.nyx.profiles.desktop = {
    enable = mkEnableOption "desktop profile";
    laptop = mkOption {
      type = types.bool;
      default = false;
      description = "Install packages that are used for laptops";
    };
  };

  config = mkIf cfg.enable {
    # Packages used with windows managers
    home.packages = with pkgs;
    let
      defaultPkgs = [
        synergy
        light
        rofi
        lm_sensors
        feh
        xdotool
      ];
      laptopPkgs = if cfg.laptop then [ acpid ] else [];
    in defaultPkgs ++ laptopPkgs;

    nyx.modules = {
      app.alacritty.enable = true;
      app.discord.enable = true;
      app.wezterm.enable = true;
      desktop.awesome.enable = true;
    };
  };
}

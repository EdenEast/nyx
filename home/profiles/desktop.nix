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
      # eww
      deadhead-font
    ] ++ optionals cfg.laptop laptopPkgs;

    xdg.configFile."awesome".source = ../../config/.config/awesome;
    xsession = {
      enable = true;
      scriptPath = ".hm-xsession";
      windowManager.awesome.enable = true;
    };

    home.file.".Xresources".text = with config.nyx.modules.theme.colors; ''
      *background: #${bg}
      *foreground: #${fg}
      *color0: #${base.black}
      *color1: #${base.red}
      *color2: #${base.green}
      *color3: #${base.yellow}
      *color4: #${base.blue}
      *color5: #${base.magenta}
      *color6: #${base.cyan}
      *color7: #${base.white}
      *color8: #${bright.black}
      *color9: #${bright.red}
      *color10: #${bright.green}
      *color11: #${bright.yellow}
      *color12: #${bright.blue}
      *color13: #${bright.magenta}
      *color14: #${bright.cyan}
      *color15: #${bright.white}
      *color16: #${base.orange}
      *color17: #${base.pink}
    '';

    nyx.modules = {
      app.alacritty.enable = true;
      app.discord.enable = true;
      app.firefox.enable = true;
      app.wezterm.enable = true;
    };
  };
}

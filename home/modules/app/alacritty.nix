{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.app.alacritty;
in
{
  options.nyx.modules.app.alacritty = {
    enable = mkEnableOption "alacritty configuration";
    package = mkOption {
      description = "Package for alacritty";
      type = with types; nullOr package;
      default = pkgs.alacritty;
    };
    fontSize = mkOption {
      description = "Override font size";
      type = with types; nullOr int;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    home.packages = mkIf (cfg.package != null) [ cfg.package ];
    xdg.configFile."alacritty".source = ../../../config/.config/alacritty;

    xdg.dataFile."alacritty/nyx-config.yml".text =
      let
        fontText =
          if cfg.fontSize != null then ''
            font:
              size: ${toString cfg.fontSize}
          '' else "";
        colorText = with config.nyx.modules.theme.colors; ''
          colors:
            primary:
              background: "0x${bg}"
              foreground: "0x${fg}"
            normal:
              black:   '0x${base.black}'
              red:     '0x${base.red}'
              green:   '0x${base.green}'
              yellow:  '0x${base.yellow}'
              blue:    '0x${base.blue}'
              magenta: '0x${base.magenta}'
              cyan:    '0x${base.cyan}'
              white:   '0x${base.white}'
            bright:
              black:   '0x${bright.black}'
              red:     '0x${bright.red}'
              green:   '0x${bright.green}'
              yellow:  '0x${bright.yellow}'
              blue:    '0x${bright.blue}'
              magenta: '0x${bright.magenta}'
              cyan:    '0x${bright.cyan}'
              white:   '0x${bright.white}'
        '';
      in
      ''
        ${fontText}
        ${colorText}
      '';
  };
}

{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.app.wezterm;
in
{
  options.nyx.modules.app.wezterm = {
    enable = mkEnableOption "wezterm configuration";
    package = mkOption {
      description = "Package for wezterm";
      type = with types; nullOr package;
      default = pkgs.wezterm;
    };
    fontSize = mkOption {
      description = "Override font size";
      type = with types; nullOr int;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    home.packages = mkIf (cfg.package != null) [ cfg.package ];
    xdg.configFile."wezterm".source = ../../../config/.config/wezterm;
    xdg.dataFile."wezterm/nyx.lua".text =
      let
        fontText =
          if cfg.fontSize != null then ''
            font_size = ${toString cfg.fontSize},
          '' else "";
        colorText = with config.nyx.modules.theme.colors; ''
          colors = {
            background = "#${bg}",
            foreground = "#${fg}",

            cursor_border = "#${comment}",
            cursor_bg = "#${comment}",
            cursor_fg = "#${bg}",

            selection_bg = "#${comment}",
            selection_fg = "#${fg}",

            ansi = {
              "#${base.black}",
              "#${base.red}",
              "#${base.green}",
              "#${base.yellow}",
              "#${base.blue}",
              "#${base.magenta}",
              "#${base.cyan}",
              "#${base.white}"
            },
            brights = {
              "#${bright.black}",
              "#${bright.red}",
              "#${bright.green}",
              "#${bright.yellow}",
              "#${bright.blue}",
              "#${bright.magenta}",
              "#${bright.cyan}",
              "#${bright.white}"
            },
          },
        '';
      in
      ''
        return {
          ${fontText}
          ${colorText}
        }
      '';
  };
}



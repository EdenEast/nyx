{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.app.kitty;
in
{
  options.nyx.modules.app.kitty = {
    enable = mkEnableOption "kitty configuration";
    package = mkOption {
      description = "Package for wezterm";
      type = with types; nullOr package;
      default = pkgs.kitty;
    };
    fontSize = mkOption {
      description = "Override font size";
      type = with types; nullOr int;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "Hack Nerd Font Mono";
        size = if cfg.fontSize != null then cfg.fontSize else 11;
      };

      settings =
        with config.nyx.modules.theme.colors; let
          hex = x: "#${x}"; in
        {
          # Colors -------------------------------------------------------------
          background = hex bg;
          foreground = hex fg;

          selection_background = hex comment;
          selection_foreground = hex fg;

          active_tab_background = hex fg;
          active_tab_foreground = hex bg;
          inactive_tab_background = hex comment;
          inactive_tab_foreground = hex bg;

          cursor = hex comment;
          cursor_text_color = hex bg;

          color0 = hex base.black;
          color1 = hex base.red;
          color2 = hex base.green;
          color3 = hex base.yellow;
          color4 = hex base.blue;
          color5 = hex base.magenta;
          color6 = hex base.cyan;
          color7 = hex base.white;

          color8 = hex bright.black;
          color9 = hex bright.red;
          color10 = hex bright.green;
          color11 = hex bright.yellow;
          color12 = hex bright.blue;
          color13 = hex bright.magenta;
          color14 = hex bright.cyan;
          color15 = hex bright.white;

          color16 = hex base.orange;
          color17 = hex base.pink;
        };
    };
  };
}



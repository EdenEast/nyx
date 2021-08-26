{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.app.alacritty;
in
{
  options.nyx.modules.app.alacritty = {
    enable = mkEnableOption "alacritty configuration";
    fontSize = mkOption {
      description = "Override font size";
      type = with types; nullOr int;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.alacritty ];
    xdg.configFile."alacritty".source = ../../../config/.config/alacritty;

    xdg.dataFile."alacritty/nyx-config.yml".text = let
      fontText = if cfg.fontSize != null then ''
        font:
          size: ${toString cfg.fontSize}
      '' else "";
    in
      ''
        ${fontText}
      '';
  };
}

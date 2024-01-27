{ inputs, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.app.ghostty;
in
{
  imports = [ inputs.ghostty-module.homeModules.default ];

  options.nyx.modules.app.ghostty = {
    enable = mkEnableOption "ghostty configuration";
    # package = mkOption {
    #   description = "Package for alacritty";
    #   type = with types; nullOr package;
    #   default = pkgs.alacritty;
    # };

    fontSize = mkOption {
      description = "Override font size";
      type = types.int;
      default = 12;
    };
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        config-file = [ (toString (./. + "/everfox.ghostty")) ];

        title = "Ghostty 👻";

        cursor-style-blink = false;
        mouse-hide-while-typing = true;

        font-size = cfg.fontSize;

        quit-after-last-window-closed = true;
      };
    };
  };
}

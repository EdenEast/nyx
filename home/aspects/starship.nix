{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.configs.starship;
in
{
  options.nyx.configs.starship = {
    enable = mkEnableOption "starship configuration";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      package = pkgs.starship;
    };

    xdg.configFile."starship".source = ../dots/.config/starship;
  };
}

{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.aspects.starship;
in
{
  options.nyx.aspects.starship = {
    enable = mkEnableOption "starship configuration";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      package = pkgs.starship;
    };

    xdg.configFile."starship".source = ../files/.config/starship;
  };
}

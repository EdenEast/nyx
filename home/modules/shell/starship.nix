{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.shell.starship;
in
{
  options.nyx.modules.shell.starship = {
    enable = mkEnableOption "starship configuration";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      package = pkgs.starship;
    };

    xdg.configFile."starship".source = ../../../config/.config/starship;
  };
}

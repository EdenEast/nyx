{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.shell.starship;
in {
  options.nyx.aspects.shell.starship = {
    enable = mkEnableOption "starship configuration";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      package = pkgs.starship;
    };

    xdg.configFile."starship".source = ../../files/.config/starship;
  };
}

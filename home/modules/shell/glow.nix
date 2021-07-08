{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.shell.glow;
in
{
  options.nyx.modules.shell.glow = {
    enable = mkEnableOption "glow configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.glow ];
    xdg.configFile."glow".source = ../../../config/.config/glow;
  };
}

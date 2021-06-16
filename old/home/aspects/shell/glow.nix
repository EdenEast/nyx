{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.shell.glow;
in {
  options.nyx.aspects.shell.glow = {
    enable = mkEnableOption "glow configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.glow ];
    xdg.configFile."glow".source = ../../files/.config/glow;
  };
}

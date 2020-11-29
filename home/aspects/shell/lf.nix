{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.shell.lf;
in {
  options.nyx.aspects.shell.lf = { enable = mkEnableOption "lf configuration"; };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.lf ];
    xdg.configFile."lf".source = ../../files/.config/lf;
  };
}

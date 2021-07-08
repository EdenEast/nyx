{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.shell.zellij;
in
{
  options.nyx.modules.shell.zellij = {
    enable = mkEnableOption "zellij configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.zellij ];
    xdg.configFile."zellij".source = ../../../config/.config/zellij;
  };
}

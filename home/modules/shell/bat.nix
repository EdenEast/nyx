{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.shell.bat;
in
{
  options.nyx.modules.shell.bat = {
    enable = mkEnableOption "bat configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.bat ];
  };
}


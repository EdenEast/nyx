{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.shell.bat;
in {
  options.nyx.aspects.shell.bat = {
    enable = mkEnableOption "bat configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.bat ];
    xdg.configFile."bat".source = ../../files/.config/bat;
  };
}


{ config, lib, ... }:

with lib;
let cfg = config.nyx.aspects.shell.xdg;
in {
  options.nyx.aspects.shell.xdg.enable = mkEnableOption "xdg configuration";

  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      mime.enable = true;
    };
  };
}


{ config, lib, ... }:

with lib;
let cfg = config.nyx.modules.shell.xdg;
in {
  options.nyx.modules.shell.xdg.enable = mkEnableOption "xdg configuration";

  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      mime.enable = true;
    };
  };
}


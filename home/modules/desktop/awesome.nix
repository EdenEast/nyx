{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.desktop.awesome;
in {
  options.nyx.modules.desktop.awesome = {
    enable = mkEnableOption "awesome window manager";
  };

  config = mkIf cfg.enable {
    xsession = {
      enable = true;
      scriptPath = ".hm-xsession";

      windowManager.awesome = {
        enable = true;
      };
    };
  };
}

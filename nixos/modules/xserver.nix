{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.xserver;
in {
  options.nyx.modules.xserver = {
    enable = mkEnableOption "x server";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      layout = "us";

      # enable touchpad support
      libinput.enable = true;

      # Setting display manager to use startx from home-manager
      displayManager.startx.enable = true;

      desktopManager = {
        xterm.enable = false;
        session = [{
          name = "home-manager";
          start = ''
            ${pkgs.runtimeShell} $HOME/.hm-xsession &
            waitPID=$!
          '';
        }];
      };
    };
  };
}



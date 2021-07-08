{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.caps;
in
{
  options.nyx.modules.caps.enable = mkEnableOption "Caps to escape+crtl";

  config = mkIf cfg.enable {
    # Map CapsLock to Esc on single press and Ctrl on when used with multiple keys.
    services.interception-tools = {
      enable = true;
      plugins = [ pkgs.interception-tools-plugins.caps2esc ];
      udevmonConfig = ''
        - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
          DEVICE:
            EVENTS:
              EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
      '';
    };
  };
}

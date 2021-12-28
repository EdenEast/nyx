{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.bluetooth;
in
{
  options.nyx.modules.bluetooth.enable = mkEnableOption "Bluetooth";

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;

    services.blueman.enable = true;
  };
}

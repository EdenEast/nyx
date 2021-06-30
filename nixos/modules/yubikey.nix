{ config, inputs, lib, name, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.user;
in {
  options.nyx.modules.yubikey.enable = mkEnableOption "yubikey support";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      yubikey-personalization
      yubikey-manager
    ];

    services = {
      # Required for gpg smartcard (yubikey) to work
      pcscd.enable = true;

      # Required for Yubikey device to work
      udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];
    };
  };
}

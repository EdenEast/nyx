{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.services.yubikey = {
    enable = lib.mkEnableOption "yubikey support";
  };

  config = lib.mkIf config.myNixOS.services.yubikey.enable {
    environment.systemPackages = with pkgs; [
      yubikey-personalization
      yubikey-manager
    ];

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    services = {
      # Required for gpg smartcard (yubikey) to work
      pcscd.enable = true;

      # Required for Yubikey device to work
      udev.packages = with pkgs; [yubikey-personalization libu2f-host];
    };
  };
}

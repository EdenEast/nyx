{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.gdm = {
    enable = lib.mkEnableOption "gdm display manager";

    autoLogin = lib.mkOption {
      description = "User to autologin.";
      default = null;
      type = lib.types.nullOr lib.types.str;
    };
  };

  config = lib.mkIf config.myNixOS.services.gdm.enable {
    security.pam.services.gdm = {
      # enableGnomeKeyring = true;
      fprintAuth = false;
      gnupg.enable = true;
      kwallet.enable = true;
    };

    services.displayManager = {
      autoLogin = lib.mkIf (config.myNixOS.services.gdm.autoLogin != null) {
        enable = true;
        user = config.myNixOS.services.gdm.autoLogin;
      };

      gdm.enable = true;
    };
  };
}

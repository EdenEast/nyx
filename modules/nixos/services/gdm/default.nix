{
  config,
  lib,
  ...
}: {
  options.my.nixos.services.gdm = {
    enable = lib.mkEnableOption "gdm display manager";

    autoLogin = lib.mkOption {
      description = "User to autologin.";
      default = null;
      type = lib.types.nullOr lib.types.str;
    };
  };

  config = lib.mkIf config.my.nixos.services.gdm.enable {
    security.pam.services.gdm = {
      # enableGnomeKeyring = true;
      fprintAuth = false;
      gnupg.enable = true;
      kwallet.enable = true;
    };

    services.displayManager = {
      autoLogin = lib.mkIf (config.my.nixos.services.gdm.autoLogin != null) {
        enable = true;
        user = config.my.nixos.services.gdm.autoLogin;
      };

      gdm.enable = true;
    };
  };
}

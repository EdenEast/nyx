{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.nixos.desktop.gnome.enable = lib.mkEnableOption "GNOME desktop environment";

  config = lib.mkIf config.my.nixos.desktop.gnome.enable {
    # home-manager.sharedModules = [
    #   {
    #     config.my.home.desktop.gnome.enable = true;
    #   }
    # ];

    services.desktopManager.gnome.enable = true;
    system.nixos.tags = ["gnome"];
    my.nixos = {
      desktop.enable = true;
      services.yubikey.pinentry = pkgs.pinentry-gnome3;
    };
  };
}

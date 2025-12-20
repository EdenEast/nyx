{
  config,
  lib,
  ...
}: {
  options.myNixOS.desktop.gnome.enable = lib.mkEnableOption "GNOME desktop environment";

  config = lib.mkIf config.myNixOS.desktop.gnome.enable {
    # home-manager.sharedModules = [
    #   {
    #     config.myHome.desktop.gnome.enable = true;
    #   }
    # ];

    services.desktopManager.gnome.enable = true;
    system.nixos.tags = ["gnome"];
    # myNixOS.desktop.enable = true;
  };
}

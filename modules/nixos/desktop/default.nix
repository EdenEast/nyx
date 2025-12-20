{
  config,
  lib,
  self,
  ...
}: {
  imports = self.lib.importsAllNixFiles ./.;

  options.myNixOS.desktop.enable = lib.mkEnableOption "minimal graphical desktop configuration";

  config = lib.mkIf config.myNixOS.desktop.enable {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # home-manager.sharedModules = [
    #   {
    #     config.myHome.desktop.enable = true;
    #   }
    # ];

    services = {
      gnome.gnome-keyring.enable = true;
      gvfs.enable = true; # Mount, trash, etc.
      libinput.enable = true;
    };
  };
}

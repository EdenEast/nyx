{
  config,
  lib,
  ...
}: {
  options.myNixOS.desktop.cosmic.enable = lib.mkEnableOption "COSMIC desktop environment";

  config = lib.mkIf config.myNixOS.desktop.cosmic.enable {
    # home-manager.sharedModules = [
    #   {
    #     config.myHome.desktop.cosmic.enable = true;
    #   }
    # ];

    services.desktopManager.cosmic.enable = true;
    system.nixos.tags = ["cosmic"];
    myNixOS.desktop.enable = true;
  };
}

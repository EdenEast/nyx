{
  config,
  lib,
  ...
}: {
  options.my.nixos.desktop.cosmic.enable = lib.mkEnableOption "COSMIC desktop environment";

  config = lib.mkIf config.my.nixos.desktop.cosmic.enable {
    home-manager.sharedModules = [
      {
        config.my.home.desktop.cosmic.enable = true;
      }
    ];

    services.desktopManager.cosmic.enable = true;
    system.nixos.tags = ["cosmic"];
    my.nixos.desktop.enable = true;
  };
}

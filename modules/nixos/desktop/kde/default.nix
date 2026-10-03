{
  config,
  lib,
  ...
}: {
  options.my.nixos.desktop.kde.enable = lib.mkEnableOption "kde desktop environment";

  config = lib.mkIf config.my.nixos.desktop.kde.enable {
    home-manager.sharedModules = [
      {
        config.my.home.desktop.kde.enable = true;
      }
    ];

    programs = {
      kdeconnect.enable = true;
    };

    services.desktopManager.plasma6.enable = true;

    system.nixos.tags = ["kde"];
    my.nixos.desktop.enable = true;
  };
}

{
  config,
  lib,
  ...
}: {
  options.my.home.desktop.kde = {
    enable = lib.mkEnableOption "kde desktop environment";
  };

  config = lib.mkIf config.my.home.desktop.kde.enable {
    my.home.desktop.enable = true;
  };
}

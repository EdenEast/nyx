{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.desktop.gnome = {
    enable = lib.mkEnableOption "GNOME desktop environment";
    dock = lib.mkEnableOption "GNOME dash-to-dock extension";
  };

  config =
    lib.mkIf config.myHome.desktop.gnome.enable {
    };
}

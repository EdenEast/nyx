{
  config,
  lib,
  ...
}: {
  options.my.home.desktop.gnome = {
    enable = lib.mkEnableOption "gnome desktop environment";
  };

  config = lib.mkIf config.my.home.desktop.gnome.enable {
    my.home.desktop.enable = true;
  };
}

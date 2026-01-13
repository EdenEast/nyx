{
  config,
  lib,
  ...
}: {
  options.my.home.desktop.cosmic = {
    enable = lib.mkEnableOption "cosmic desktop environment";
  };

  config = lib.mkIf config.my.home.desktop.cosmic.enable {
    my.home.desktop.enable = true;
  };
}

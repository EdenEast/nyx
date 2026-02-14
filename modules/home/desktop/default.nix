{
  config,
  lib,
  self,
  ...
}: {
  imports = self.lib.fs.scanPaths ./.;

  options.my.home.desktop.enable = lib.mkEnableOption "Base desktop";

  config = lib.mkIf config.my.home.desktop.enable {
    my.home.programs = {
      ghostty.enable = lib.mkDefault true;
      zen.enable = lib.mkDefault true;
    };
  };
}

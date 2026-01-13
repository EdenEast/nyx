{
  config,
  lib,
  self,
  ...
}: {
  imports = self.lib.importsAllNixFiles ./.;

  options.my.home.desktop.enable = lib.mkEnableOption "Base desktop";

  config = lib.mkIf config.my.home.desktop.enable {
    my.home.programs = {
      ghostty.enable = lib.mkDefault true;
      zen.enable = lib.mkDefault true;
    };
  };
}
